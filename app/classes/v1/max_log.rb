class MaxLog
  attr_reader :maxs, :geral
  
  def initialize(logs)
    logs = logs.group_by { |l| l[:wday] }
    logs = logs.map do |(wday, grouped)|
      resp = grouped.first.to_hash
      resp[:read_pages] = grouped.map { |g| g[:read_pages] }.flatten
      resp
    end

    @maxs = logs.each_with_object({}) do |log, obj|
      max = log[:read_pages].max
      idx = log[:wday]
      obj[idx] = max
    end

    @geral = @maxs.to_a.map { |m| m.last }.max
  end

  def by_wday(wday)
    @maxs[wday]
  end
end
