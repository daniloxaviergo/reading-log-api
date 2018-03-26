class Log < ApplicationRecord
  belongs_to :project

  before_validation :set_data
  before_validation :set_wday

  after_validation :set_page_project

  scope :order_data, -> { order(data: :desc) }
  scope :group_by_week_day, -> {
    select_sql = ["#{table_name}.*",
                  "EXTRACT(DOW FROM #{table_name}.data) AS wday"]
    select_sql = select_sql.join(',')

    select(select_sql).group("wday, id")
  }

  scope :range_data, -> (date_start, date_end) {
    criteria = "#{table_name}.data < ? AND #{table_name}.data > ?"
    where(criteria, date_start, date_end)
  }

  # date_start = hoje, date_end = hoje - 7
  scope :last_week, -> {
    date_start = Date.today.end_of_day
    date_end   = (Date.today - 7).beginning_of_day

    range_data(date_start, date_end)
  }

  # date_start = hoje - 7, date_end = hoje - 14
  scope :previous_week, -> {
    date_start = (Date.today - 7).end_of_day
    date_end   = (Date.today - 14).beginning_of_day
    
    range_data(date_start, date_end)
  }

  def read_pages
    (end_page - start_page).to_f
  end

  private

  def set_data
    self.data ||= Time.now.asctime.to_datetime
  end

  def set_wday
    self.wday ||= data.wday
  end

  def set_page_project
    self.project.page = end_page
    self.project.save
  end
end
