class V1::TotalLog
  attr_reader :logs
  
  def initialize(logs)
    @logs = ::V1::GroupLog.new(logs).by_data
  end

  def by_week
    reads, idx_begin_week = sequentially_reads, 0

    (date_beginning_of_week..date_end_of_week).step(7).map do |data|
      idx_end_week   = idx_end_week(idx_begin_week)
      count_reads    = reads_of_week(reads, idx_begin_week, idx_end_week)
      idx_begin_week = idx_next_week(idx_begin_week)

      {
        end_week:    data.end_of_week,
        begin_week:  data,
        count_reads: count_reads
      }
    end
  end

  private 

  def idx_next_week(idx_begin_week)
    idx_begin_week + 7
  end

  def idx_end_week(idx_begin_week)
    idx_begin_week + 6
  end

  def reads_of_week(reads, idx_begin_week, idx_end_week)
    sequentially_reads[idx_begin_week..idx_end_week].sum
  end

  def sequentially_reads
    return @sequentially_reads if @sequentially_reads.present?

    reads = Array(date_beginning_of_week..date_end_of_week).map do |data|
      log = @logs.find { |l| l[:data].to_date == data }

      (log && log[:read_pages]) || 0
    end

    @sequentially_reads = reads
  end

  def date_end_of_week
    Date.today.end_of_week
  end

  def date_beginning_of_week
    @logs.last[:data].to_date.beginning_of_week
  end
end
