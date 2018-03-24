class V1::Dashboard::Echart::DayWeekController < ApplicationController
  def index
    render json: { controller: 'Echart::DayWeekController' }
  end
end