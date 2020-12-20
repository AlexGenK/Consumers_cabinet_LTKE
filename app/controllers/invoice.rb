class Invoice < ApplicationController
	require 'humanize'

	InvData = Struct.new(:quantity, :price, :sum, :vat, :sum_vat)

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
    	dog_num = @consumer.dog_gas_num
    	dog_date = @consumer.dog_gas_date
    else
    	units = 'тис.кВт.год'
    	product = 'електроенергію'
    	dog_num = @consumer.dog_en_num
    	dog_date = @consumer.dog_en_date
    end

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
      pdf.text "п/р #{receiver.account} у банку #{receiver.bank},"
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
    table_data = [['№', 'Товари (роботи, послуги)', 'Кіл-сть', 'Од.', 'Ціна без ПДВ', 'Сума без ПДВ'],
            ['1', "Доплата за #{product} у #{UA_MONTHS_MIS[Time.current.month]} #{Time.current.year} р.", 
            ActiveSupport::NumberHelper.number_to_delimited(data.quantity, delimiter: ' '),
            units, 
            ActiveSupport::NumberHelper.number_to_delimited(data.price, delimiter: ' '), 
            ActiveSupport::NumberHelper.number_to_delimited(data.sum, delimiter: ' ')]]
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
      pdf.text ActiveSupport::NumberHelper.number_to_delimited(data.sum, delimiter: ' '), align: :right, style: :bold
    end
    pdf.move_down 2
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 455) do
      pdf.text "Сума ПДВ:", align: :right, style: :bold
    end
    pdf.bounding_box([460, y], width: 80) do
      pdf.text ActiveSupport::NumberHelper.number_to_delimited(data.vat, delimiter: ' '), align: :right, style: :bold
    end
    pdf.move_down 2
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 455) do
      pdf.text "Вього із ПДВ:", align: :right, style: :bold
    end
    pdf.bounding_box([460, y], width: 80) do
      pdf.text ActiveSupport::NumberHelper.number_to_delimited(data.sum_vat, delimiter: ' '), align: :right, style: :bold
    end
    pdf.move_down 10
    pdf.text "Всього найменувань 1, на суму #{ActiveSupport::NumberHelper.number_to_delimited(data.sum_vat, delimiter: ' ')} грн.", size: 10
    pdf.move_down 2
    sum_vat_parts = data.sum_vat.to_s.split('.')
    pdf.text "#{sum_vat_parts[0].to_i.humanize(locale: 'ua').capitalize} грн. #{sum_vat_parts[1]} коп.", style: :bold
    pdf.move_down 2
    vat_parts = data.vat.to_s.split('.')
    pdf.text "У т.р. ПДВ: #{vat_parts[0].to_i.humanize(locale: 'ua')} грн. #{vat_parts[1]} коп.", style: :bold

    pdf.stroke_axis
    pdf.draw_text now.strftime('Сгенеровано %d.%m.%Y в %T'), size: 10, at: [0, 0]
    return pdf
  end

end