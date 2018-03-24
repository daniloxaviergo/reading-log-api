class V1::Dashboard::LastDaysController < ApplicationController
  def index
    render json: { controller: 'LastDaysController' }
  end
end