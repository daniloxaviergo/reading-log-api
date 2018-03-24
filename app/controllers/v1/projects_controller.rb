class V1::ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  def index
    # render com includes
    # render json: Project.first, include: ['logs'] # nome dos relacionamentos
    projects = Project.all
    projects = Project.eager_load(:logs).where(id: projects.map(&:id))
                                        .order('logs.data DESC')
                                        .all
    render json: projects
  end

  def show
    render json: @project, action: :show
  end

  private 

  def set_project
    @project = Project.eager_load(:logs).order('logs.data DESC').find(params[:id])
  end
end