class V1::Dashboard::Echart::TotalController < ApplicationController
  def index
    total_week = ::V1::TotalLog.new(Log.all).by_week
    echart     = ::V1::Dashboard::Echart::TotalLog.new(total_week)
    return render json: { echart: echart.graph }
  end
end
