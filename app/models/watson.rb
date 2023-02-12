class Watson < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :log, optional: true
end
