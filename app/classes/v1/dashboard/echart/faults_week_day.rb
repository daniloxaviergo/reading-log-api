class V1::Dashboard::Echart::FaultsWeekDay
  
  def initialize(faults)
    @faults = faults
  end

  def graph
    {
      tooltip: {
        trigger: 'axis'
      },
      radar: {
        name: {
          textStyle: {
            color: '#fff',
            backgroundColor: '#999',
            borderRadius: 3,
            padding: [3, 5]
         }
        },
        indicator: [
          { name: 'Sunday'   , max: 5 },
          { name: 'Monday'   , max: 5 },
          { name: 'Tuesday'  , max: 5 },
          { name: 'Wednesday', max: 5 },
          { name: 'Thursday' , max: 5 },
          { name: 'Friday'   , max: 5 },
          { name: 'Saturday' , max: 5 }
        ]
      },
      series: [
        {
          type: 'radar',
          tooltip: {
            trigger: 'item'
          },
          itemStyle: {normal: {areaStyle: {type: 'default'}}},
          data: [
            {
              name: 'Faults by Week Day',
              value: series_data,
              label: {normal: {show: true}}
            }
          ]
        }
      ]
    }
  end

  private

  def series_data
    7.times.map { |wday| @faults.counts[wday] }
  end
end
