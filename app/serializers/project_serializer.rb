class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :started_at, :progress, :total_page, :page, :status, :logs_count, :days_unreading

  def attributes(fields)
    base_attributes = super

    case @instance_options[:action]
    when :show
      base_attributes.merge(attributes_show)
    else
      base_attributes
    end
  end

  def attributes_show
    {
      median_day: @object.median_day,
      finished_at: @object.finished_at
    }
  end
end
