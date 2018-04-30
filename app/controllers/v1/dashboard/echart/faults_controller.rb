class V1::Dashboard::Echart::FaultsController < ApplicationController
  def index
    hoje, previous_month = (Time.zone.now.end_of_day), (30.days.ago.to_date)
    faults = ::V1::Dashboard::Faults.new(previous_month, hoje)
    echart = ::V1::Dashboard::Echart::Faults.new(faults.count)
    return render json: { echart: echart.graph }
  end
end
