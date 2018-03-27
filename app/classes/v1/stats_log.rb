class V1::StatsLog
  attr_reader :mean, :max

  def initialize(logs)
    first_read   = logs.order(data: :asc).first
    grouped_logs = logs.order(data: :desc).group_by { |l| l.data.to_date }
    grouped_logs = grouped_logs.map do |(data, grouped)|
      resp = grouped.first.to_hash
      resp[:read_pages] = grouped.map(&:read_pages).flatten.sum
      resp
    end

    @mean = ::V1::MeanLog.new(grouped_logs, first_read)
    @max  = ::V1::MaxLog.new(grouped_logs)
  end
end