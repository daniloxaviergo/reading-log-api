class V1::Dashboard::Echart::FaultsWeekDayController < ApplicationController
  def index
    hoje, previous_month = (Time.zone.now.utc.end_of_day), (Date.today - 6.months)
    faults = ::V1::Dashboard::FaultsWeekDay.new(previous_month, hoje)
    echart = ::V1::Dashboard::Echart::FaultsWeekDay.new(faults)
    return render json: { echart: echart.graph }
  end
end
