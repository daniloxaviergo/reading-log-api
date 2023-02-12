class Project < ApplicationRecord
  SQLS = {
    running: "#{table_name}.page != #{table_name}.total_page",
    sleeping: "#{table_name}.id > 0" # todo
  }.freeze

  has_many :logs, -> { order(data: :desc) }
  has_many :watsons

  scope :order_progress,-> {
    order(Arel.sql("#{table_name}.\"page\"::float / #{table_name}.\"total_page\"::float DESC"))
  }
  scope :running,  -> { where(SQLS[:running]) }
  scope :sleeping, -> { where(SQLS[:sleeping]) }

  scope :only_status, -> (filter) {
    scoped = all

    statuses = filter[:status].presence
    if statuses && statuses.is_a?(Array)
      valid_statuses = %w(running)
      statuses = statuses.select { |s| valid_statuses.include?(s.to_s) }

      sql = statuses.map do |status|
        next if SQLS[status].empty?

        SQLS[status]
      end

      scoped = scoped.where(sql.join(' OR '))
    end

    scoped
  }

  def progress
    ((page.to_f / total_page.to_f) * 100).round(2)
  end

  def status
    return 'unstarted' if logs.empty?
    return 'finished'  if finished?
    return 'running'   if running?
    return 'sleeping'  if sleeping?
    return 'stopped'
  end

  def median_day
    (page.to_f / days_reading.to_f).round(2)
  end

  def finished_at
    days_reading     = (Date.today - started_at).to_i
    future_days_read = (days_reading.to_f * total_page.to_f) / page.to_f
    
    return last_read[:data].to_date if finished?
    Date.today + future_days_read.round.days
  end

  def logs_count
    logs.size
  end

  def finished?
    page >= total_page
  end

  def running?
    days_unreading < config.em_andamento_range
  end

  def sleeping?
    days_unreading < config.dormindo_range
  end

  def days_unreading
    return @days_unreading if @days_unreading.present?
    base_data = last_read && last_read[:data].to_date || started_at

    @days_unreading = (Date.today - base_data).to_i
    @days_unreading
  end

  def days_reading
    (Date.today - started_at).to_i
  end

  private

  def last_read
    @last_read ||= logs.first
    @last_read
  end

  def config
    @config ||= ::V1::UserConfig::new.get
    @config
  end
end
