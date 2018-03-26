class StatsLog
  attr_reader :mean, :max

  def initialize(logs)
    grouped_logs = logs.order_data.group_by { |l| l.data.to_date }
    grouped_logs = grouped_logs.map do |(data, grouped)|
      resp = grouped.first.to_hash
      resp[:read_pages] = grouped.map(&:read_pages).flatten.sum
      resp
    end

    @mean = MeanLog.new(grouped_logs)
    @max  = MaxLog.new(grouped_logs)
  end
end