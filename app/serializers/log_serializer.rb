class LogSerializer < ActiveModel::Serializer
  attributes :id, :data, :start_page, :end_page, :note

  belongs_to :project
end
