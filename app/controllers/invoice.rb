class Invoice < ApplicationController
	require 'humanize'

	InvData = Struct.new(:quantity, :price, :sum, :vat, :sum_vat, :percent, :day, :month)

  def pdf_form(data, **args)
    # document preparation
    now = DateTime.now
    pdf = Prawn::Document.new
    receiver = Receiver.first
    pdf.font_families.update("Segoe UI" => {
      :normal => Rails.root.join("app/assets/fonts/SegoeUI.ttf"),
      :bold => Rails.root.join("app/assets/fonts/SegoeUI-Bold.ttf"),
    })
    pdf.font 'Segoe UI'
    if args[:style] == 'gas'
    	units = 'тис. м3'
    	product = 'газ'
    	dog_num = @consumer.dog_num
    	dog_date = @consumer.dog_date
      account = receiver.account_gas
      bank = receiver.bank_gas
    else
    	units = 'кВт.год'
    	product = 'електроенергію'
    	dog_num = @consumer.dog_num
    	dog_date = @consumer.dog_date
      account = receiver.account
      bank = receiver.bank
    end

    p args[:percent]

    # document header
    pdf.text "Рахунок на оплату б/н від #{l(now, format: '%-d %B %Y')} р.", size: 14, style: :bold
    pdf.stroke_horizontal_rule
    pdf.move_down 10
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 100) do
      pdf.text 'Постачальник:'
    end
    pdf.bounding_box([105, y], width: 435) do
      pdf.text receiver.name, style: :bold
    end
    pdf.bounding_box([105, pdf.cursor], width: 435) do
      pdf.text "п/р #{account} у банку #{bank},"
    end
    pdf.bounding_box([105, pdf.cursor], width: 435) do
      pdf.text "#{receiver.address},"
    end
    pdf.bounding_box([105, pdf.cursor], width: 435) do
      pdf.text "Код за ЄДРПОУ #{receiver.edrpou}, ІПН #{receiver.ipn}"
    end
    pdf.move_down 10
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 100) do
      pdf.text 'Покупець:'
    end
    pdf.bounding_box([105, y], width: 435) do
      pdf.text @consumer.full_name, style: :bold
    end
    pdf.move_down 10
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 100) do
      pdf.text 'Договір:'
    end
    pdf.bounding_box([105, y], width: 435) do
      pdf.text "№#{dog_num} від #{dog_date&.strftime('%d.%m.%Y')} р."
    end
    pdf.move_down 10
    # table
    formulation = get_formulation(data, product)
    table_data = [['№', 'Товари (роботи, послуги)', 'Кіл-сть', 'Од.', 'Ціна без ПДВ', 'Сума без ПДВ'],
            ['1', formulation, 
            ActiveSupport::NumberHelper.number_to_delimited(data.quantity, delimiter: ' '),
            units, 
            ActiveSupport::NumberHelper.number_to_delimited(data.price, delimiter: ' '), 
            float_format(data.sum)]]
    pdf.table(table_data, column_widths: [30, 235, 80, 45, 70, 80]) do
      row(0).columns(0..5).align = :center
      row(0).columns(0..5).background_color = "F0F0F0"

      row(1).size = 10
      row(1).columns(0).align = :center
      row(1).columns(2).align = :right
      row(1).columns(3).align = :center
      row(1).columns(4..6).align = :right
    end
    pdf.move_down 10
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 455) do
      pdf.text "Всього:", align: :right, style: :bold
    end
    pdf.bounding_box([460, y], width: 80) do
      pdf.text float_format(data.sum), align: :right, style: :bold
    end
    pdf.move_down 2
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 455) do
      pdf.text "Сума ПДВ:", align: :right, style: :bold
    end
    pdf.bounding_box([460, y], width: 80) do
      pdf.text float_format(data.vat), align: :right, style: :bold
    end
    pdf.move_down 2
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 455) do
      pdf.text "Вього із ПДВ:", align: :right, style: :bold
    end
    pdf.bounding_box([460, y], width: 80) do
      pdf.text float_format(data.sum_vat), align: :right, style: :bold
    end
    pdf.move_down 10
    pdf.text "Всього найменувань 1, на суму #{float_format(data.sum_vat)} грн.", size: 10
    pdf.move_down 2
    sum_vat_parts = ActionController::Base.helpers.number_with_precision(data.sum_vat, precision: 2).split(',')
    pdf.text "#{sum_vat_parts[0].to_i.humanize(locale: 'ua').capitalize} грн. #{sum_vat_parts[1]} коп.", style: :bold
    pdf.move_down 2
    vat_parts = ActionController::Base.helpers.number_with_precision(data.vat, precision: 2).split(',')
    pdf.text "У т.р. ПДВ: #{vat_parts[0].to_i.humanize(locale: 'ua')} грн. #{vat_parts[1]} коп.", style: :bold

    pdf.draw_text now.strftime('Сгенеровано %d.%m.%Y в %T'), size: 10, at: [0, 0]
    return pdf
  end

  def float_format(float)
    ActionController::Base.helpers.number_with_precision(float, delimiter: ' ', precision: 2)
  end

  def calculate_invoice
    sum_vat = params[:sum].to_f.round(2)
    price = params[:tariff].to_f
    sum = (sum_vat - (sum_vat / 6)).round(2)
    vat = (sum_vat - sum).round(2)
    if (sum == 0) || (price == 0)
      quantity = 0
    else
      quantity = (sum/price).round(5)
    end
    InvData.new(quantity, price, sum, vat, sum_vat, params[:percent], params[:day], params[:month])
  end

  protected

  def get_formulation(data, product)
    if params[:period] == 'prev'
      t = Time.now.beginning_of_month - 1.day
      return "Доплата за #{product} #{l(t, format: '%B %Y')}"
    end
    if data.percent && data.day && data.month
      case data.month
      when '1'
        t = Time.now.beginning_of_month - 1.day
        period = "#{UA_MONTHS_MIS[t.month]} #{t.year}"
      when '-1'
        t = Time.now.end_of_month + 1.day
        period = "#{UA_MONTHS_MIS[t.month]} #{t.year}"
      else
        period = "#{UA_MONTHS_MIS[Time.now.month]} #{Time.now.year}"
      end
      formulation = "Платіж #{data.percent}% до #{data.day}.#{Time.now.strftime('%m.%Y')} за #{product} у #{period}"
    else
      formulation = "Оплата за #{product}"
    end
    return formulation
  end

end