class V1::Dashboard::Faults
  attr_reader :count
  
  def initialize(date_start, date_end)
    logs   = ::Log.range_data(date_start, date_end)
    @count = (date_start..date_end).map do |day|
      equal_day  = lambda { |log| log[:data].to_date == day }
      read_pages = logs.select(&equal_day).map { |l| l.read_pages }

      next 1 if read_pages.sum.zero?
    end.compact.sum
  end
end
