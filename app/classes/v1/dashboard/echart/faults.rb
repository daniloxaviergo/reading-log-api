class V1::Dashboard::Echart::Faults
  
  def initialize(count)
    config = ::V1::UserConfig.new.get
    @percentage = ((count.to_i / config.max_faltas.to_i) * 100).round(2)
  end

  def graph
    {
      tooltip: {
        formatter: "{a}: {c}%"
      },
      toolbox: {},
      series: [
        {
          name: 'Faults',
          type: 'gauge',
          detail: { formatter: '{value}%' },
          data: [
            { value: @percentage }
          ]
        }
      ]
    }
  end
end
