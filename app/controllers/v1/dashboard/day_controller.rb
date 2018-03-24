class V1::Dashboard::DayController < ApplicationController
  def index
    render json: { controller: 'DayController' }
  end
end