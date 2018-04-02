class V1::StatsLog
  attr_reader :mean, :max

  def initialize(logs)
    first_read   = logs.order(data: :asc).first
    grouped_logs = V1::GroupLog.new(logs).by_data

    @mean = ::V1::MeanLog.new(grouped_logs, first_read)
    @max  = ::V1::MaxLog.new(grouped_logs)
  end
end