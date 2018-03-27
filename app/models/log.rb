class Log < ApplicationRecord
  belongs_to :project

  before_validation :set_data
  before_validation :set_wday

  after_validation :set_page_project

  scope :order_wday, -> { order(wday: :asc) }
  scope :range_data, -> (date_start, date_end=nil) {
    if date_end.present?
      criteria = "#{table_name}.data < ? AND #{table_name}.data > ?"
      where(criteria, date_end, date_start)
    else
      criteria = "#{table_name}.data < ?"
      where(criteria, date_start)
    end
  }

  # date_start = hoje, date_end = hoje - 7
  scope :last_week, -> {
    date_end   = Date.today.end_of_day
    date_start = (Date.today - 7).beginning_of_day

    range_data(date_start, date_end)
  }

  # date_start = hoje - 7, date_end = hoje - 14
  scope :previous_week, -> {
    date_end   = (Date.today - 7).end_of_day
    date_start = (Date.today - 14).beginning_of_day
    
    range_data(date_start, date_end)
  }

  def to_hash
    attributes.symbolize_keys
  end

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
