class V1::Dashboard::SpeculateActual
  attr_reader :comparative
  
  def initialize(date_start, date_end, wdays)
    config = ::V1::UserConfig.new.get

    begin_data = ::Log.order(data: :asc).first.data.to_date
    logs = ::Log.range_data(date_start, date_end)

    @comparative = (date_start..date_end).each_with_object({}) do |day, means|
      equal_day  = lambda { |log| log[:data].to_date == day }
      read_pages = logs.select(&equal_day).map { |l| l.read_pages }

      wdays[day.wday] << read_pages.sum
      reads_wday  = wdays[day.wday].flatten
      total_pages = reads_wday.sum.to_f
      count_reads = (begin_data..day).step(7).map { |d| d }.size.to_f

      mean = (total_pages / count_reads).round(3)
      spec_mean = ((mean * config.per_extimativa) + mean).round(3)

      means[day.to_s] = {
        pages:     read_pages.sum,
        spec_mean: spec_mean
      }
    end
  end
end
