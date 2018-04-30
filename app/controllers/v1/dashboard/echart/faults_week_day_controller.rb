class V1::Dashboard::Echart::FaultsWeekDayController < ApplicationController
  def index
    hoje, previous_month = (Time.zone.now.end_of_day), (6.months.ago.to_date)
    faults = ::V1::Dashboard::FaultsWeekDay.new(previous_month, hoje)
    echart = ::V1::Dashboard::Echart::FaultsWeekDay.new(faults)
    return render json: { echart: echart.graph }
  end
end
