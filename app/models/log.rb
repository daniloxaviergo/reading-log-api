class Log < ApplicationRecord
  belongs_to :project

  before_validation :set_data
  after_validation :set_page_project

  private

  def set_data
    self.data ||= Time.now.asctime.to_datetime
  end

  def set_page_project
    self.project.page = end_page
    self.project.save
  end
end
