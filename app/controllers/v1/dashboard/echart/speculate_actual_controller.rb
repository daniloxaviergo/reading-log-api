class V1::Dashboard::Echart::SpeculateActualController < ApplicationController
  def index
    previous_week = 15.days.ago.to_date
    logs  = Log.range_data(previous_week)
    wdays = V1::GroupLog.new(logs).by_wday

    hoje, previous_week = (Time.zone.now.end_of_day), 14.days.ago.to_date
    spec_efec = V1::Dashboard::SpeculateActual.new(previous_week, hoje, wdays)
    echart = ::V1::Dashboard::Echart::SpeculateActual.new(spec_efec.comparative)

    render json: { echart: echart.graph }
  end
end
