class V1::Dashboard::Echart::FaultsController < ApplicationController
  def index
    hoje, previous_month = (Time.zone.now.utc.end_of_day), (Date.today - 30)
    faults = ::V1::Dashboard::Faults.new(previous_month, hoje)
    echart = ::V1::Dashboard::Echart::Faults.new(faults.count)
    return render json: { echart: echart.graph }
  end
end
