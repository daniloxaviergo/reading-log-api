class MeanLog
  attr_reader :means, :geral, :speculate

  def initialize(logs)
    logs = logs.group_by { |l| l[:wday] }
    logs = logs.map do |(wday, grouped)|
      resp = grouped.first.to_hash
      resp[:read_pages] = grouped.map { |g| g[:read_pages] }.flatten
      resp
    end

    @means = logs.each_with_object({}) do |log, obj|
      total_pages = log[:read_pages].sum.to_f
      count_reads = log[:read_pages].length.to_f

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
