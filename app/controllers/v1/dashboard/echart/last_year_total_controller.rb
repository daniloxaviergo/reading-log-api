class V1::Dashboard::Echart::LastYearTotalController < ApplicationController
  def index
    total_week = ::V1::TotalLog.new(Log.all.where("logs.data > ?", 1.year.ago)).by_week
    echart     = V1::Dashboard::Echart::LastYearTotalLog.new(total_week)
    return render json: { echart: echart.graph }
  end
end
