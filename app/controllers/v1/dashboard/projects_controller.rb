class V1::Dashboard::ProjectsController < ApplicationController
  def index
    filter = { status: [:running] }
    @projects = Project.only_status(filter)
    @projects = Project.eager_load(:logs).where(id: @projects.map(&:id))
                                         .order_progress
                                         .order('logs.data DESC')
                                         .all
    json_pj = ActiveModelSerializers::SerializableResource.new(@projects).as_json
    render json: json_pj.merge(stats: stats)
  end

  private

  def stats
    total_pages = @projects.map(&:total_page).flatten.sum.to_f
    pages       = @projects.map(&:page).flatten.sum.to_f

    {
      progress_geral: ((pages / total_pages) * 100).round(3),
      total_pages:    total_pages,
      pages:          pages
    }
  end
end
