class V1::Dashboard::Echart::MeanProgress
  
  def initialize(comparative)
    @config = ::V1::UserConfig.new.get
    @comparative = comparative
  end

  def graph
    {
      tooltip: {
        trigger: 'axis',
        formatter: "{b}: {c}%"
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

      visualMap: {
        top: 10,
        right: 10,
        pieces: [
          {
            gt: 0,
            lte: 10,
            color: '#6c757d'
          }, {
            gt: 10,
            lte: 20,
            color: '#17a2b8'
          }, {
            gt: 20,
            lte: 50,
            color: '#007bff'
          }, {
            gt: 50,
            color: '#28a745'
          }
        ],
        outOfRange: {
          color: '#cc0033'
        }
      },

      series: [
        {
          name: 'Progress',
          type: 'line',
          smooth: false,
          data: series_data_page,
          markPoint: {
            itemStyle: {
              color: '#999'
            },
            data: [
              { type: 'max', name: '' },
              { type: 'min', name: '' }
            ]
          },
          markLine: {
            lineStyle: {
              normal: {
                color: '#333'
              }
            },
            data: [
              { type: 'average' }
            ]
          }
        }
      ]
    }
  end

  private 

  def series_data_page
    @comparative.values.map do |data|
      ((data[:pages] / data[:mean] * 100) - 100).round(2)
    end
  end

  def xAxis
    @comparative.keys.map do |day|
      day.to_date.strftime('%d-%m (%a)')
    end
  end
end
