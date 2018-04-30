class V1::Dashboard::FaultsWeekDay
  attr_reader :counts
  
  def initialize(date_start, date_end)
    logs     = ::Log.range_data(date_start, date_end)
    _wdays   = 7.times.each_with_object({}) { |wday, obj| obj[wday] = 0 }
    date_end = date_end.to_date

    @counts = (date_start..date_end).each_with_object(_wdays) do |day, wdays|
      equal_day  = lambda { |log| log[:data].to_date == day }
      read_pages = logs.select(&equal_day).map { |l| l.read_pages }

      wdays[day.wday] += 1 if read_pages.sum.zero?
    end
  end
end
