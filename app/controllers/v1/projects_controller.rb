module V1
  class ProjectsController < ApplicationController
    def index
      render json: [{id: 1} , {id: 2}]
    end
  end
end