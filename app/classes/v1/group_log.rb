class V1::GroupLog
  attr_reader :logs
  
  def initialize(logs)
    @logs = logs
  end

  def by_data
    grouped_logs = logs.order(data: :desc).group_by { |l| l.data.to_date }
    grouped_logs.map do |(data, grouped)|
      resp = grouped.first.to_hash
      resp[:read_pages] = grouped.map(&:read_pages).flatten.sum
      resp
    end
  end

  def by_wday
    grouped_logs = by_data
    7.times.each_with_object({}) do |wday, obj|
      equal_wday = lambda { |log| log[:wday] == wday }
      read_pages = grouped_logs.select(&equal_wday).map { |l| l[:read_pages] }
      obj[wday]  = read_pages
    end
  end
end
