class V1::Dashboard::Echart::TotalLog
  
  def initialize(total_week)
    @total_week = total_week
  end

  def graph
    {
      tooltip: {
        trigger: 'axis'
      },

      legend: {
        data: []
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
        data: xAxis
      },

      series: [
        {
          name: 'Total',
          type: 'line',
          itemStyle: { normal: { opacity: 0.3 } },
          markLine: {
            data: [
              { type: 'average', name: '' },
            ]
          },
          areaStyle: {
            normal: {
              opacity: 0.3,
            }
          },
          smooth: true,
          data: series.flatten,
        }
      ]
    }
  end

  private 

  def series
    @total_week.map { |week| week[:count_reads] }
  end

  def xAxis
    @total_week.map do |week|
      begin_week = week[:begin_week].to_date
      end_week   = week[:end_week].to_date


      "#{ ('%02d' % begin_week.day) }/#{end_week.strftime('%d-%b-%y')}"
    end
  end
end
