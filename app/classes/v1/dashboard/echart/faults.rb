class V1::Dashboard::Echart::Faults
  
  def initialize(count)
    config = ::V1::UserConfig.new.get
    @percentage = ((count.to_f / config.max_faltas.to_f) * 100).round(2)
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
