class V1::LogsController < ApplicationController
  before_action :set_project, only: [:index]

  def index
    logs = @project.logs.first(4)
    render json: logs, include: ['project']
  end

  private 

  def set_project
    @project = Project.eager_load(:logs).order('logs.data DESC').find(params[:project_id])
  end
end
