class MeanLog
  attr_reader :means, :geral, :speculate

  def initialize(logs, first_read)
    logs = logs.group_by { |l| l[:wday] }
    logs = logs.map do |(wday, grouped)|
      resp = grouped.first.to_hash
      resp[:read_pages] = grouped.map { |g| g[:read_pages] }.flatten
      resp
    end

    begin_data = first_read.data.to_date
    @means = logs.each_with_object({}) do |log, obj|
      total_pages = log[:read_pages].sum.to_f
      log_data    = log[:data].to_date
      count_reads = (begin_data..log_data).step(7).map { |d| d }.size.to_f

      mean = (total_pages / count_reads).round(3)
      idx  = log[:wday]
      obj[idx] = mean
    end

    count = @means.to_a.size # all days of week
    total = @means.to_a.map { |m| m.last }.sum # sum pages by week
    @geral = (total / count).round(3)

    @speculate = MeanSpeculateLog.new(self)
  end

  def by_wday(wday)
    @means[wday]
  end

  def compare(wday, previous_mean)
    (by_wday(wday) / previous_mean).round(3)
  end
end
