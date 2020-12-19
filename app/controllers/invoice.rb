class Invoice < ApplicationController
	require 'humanize'

  def pdf_form(**args)
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
      pdf.text "№#{dog_num} від #{dog_date.strftime('%d.%m.%Y')} р."
    end
    pdf.move_down 10
    # table
    data = [['№', 'Товари (роботи, послуги)', 'Кіл-сть', 'Од.', 'Ціна без ПДВ', 'Сума без ПДВ'],
            ['1', "Доплата за #{product} у #{UA_MONTHS_MIS[Time.current.month]} #{Time.current.year} р.", '449,35929', units, '1 825,98', '820 519,24']]
    pdf.table(data, column_widths: [30, 235, 80, 45, 70, 80]) do
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
      pdf.text "820 519,24", align: :right, style: :bold
    end
    pdf.move_down 2
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 455) do
      pdf.text "Сума ПДВ:", align: :right, style: :bold
    end
    pdf.bounding_box([460, y], width: 80) do
      pdf.text "164 103,85", align: :right, style: :bold
    end
    pdf.move_down 2
    y = pdf.cursor
    pdf.bounding_box([0, y], width: 455) do
      pdf.text "Вього із ПДВ:", align: :right, style: :bold
    end
    pdf.bounding_box([460, y], width: 80) do
      pdf.text "984 623,09", align: :right, style: :bold
    end
    pdf.move_down 10
    pdf.text "Всього найменувань 1, на суму 984 623,09 грн.", size: 10
    pdf.move_down 2
    pdf.text "Дев'ятсот вісімдесят чотири тисячі шістсот двадцять три гривні 09 копійок", style: :bold
    pdf.move_down 2
    pdf.text "У т.р. ПДВ: Сто шістдесят чотири тисячі сто три гривні 85 копійок", style: :bold

    pdf.stroke_axis
    pdf.draw_text now.strftime('Сгенеровано %d.%m.%Y в %T'), size: 10, at: [0, 0]
    return pdf
  end

end