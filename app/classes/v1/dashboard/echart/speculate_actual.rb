class V1::Dashboard::Echart::SpeculateActual
  
  def initialize(comparative)
    @config = ::V1::UserConfig.new.get
    @comparative = comparative
  end

  def graph
    {
      tooltip: {
        trigger: 'axis'
      },

      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },

      yAxis: {
        type: 'value'
      },

      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: xAxis.compact
      },

      series: [
        {
          name: 'Pages',
          type: 'line',
          smooth: true,
          itemStyle: {
            normal: {
              areaStyle: {
                type: 'default'
              }
            }
          },
          data: series_data_page,
          markPoint: {
            data: [
              { type: 'max', name: '' },
              { type: 'min', name: '' }
            ]
          },
          markLine: {
            lineStyle: {
              normal: {
                color: "#333"
              }
            },
            data: [
              { name: 'pages_per_day', yAxis: @config.pages_per_day }
            ]
          }
        },
        {
          name: 'Mean',
          type: 'line',
          smooth: true,
          itemStyle: {
            normal: {
              areaStyle: {
                type: 'default'
              }
            }
          },
          data: series_data_mean
        }
      ]
    }
  end

  private 

  def series_data_page
    @comparative.values.map do |data|
      data[:pages]
    end
  end

  def series_data_mean
    @comparative.values.map do |data|
      data[:spec_mean]
    end
  end

  def xAxis
    @comparative.keys.map do |day|
      day.to_date.strftime('%d-%m (%a)')
    end
  end
end
