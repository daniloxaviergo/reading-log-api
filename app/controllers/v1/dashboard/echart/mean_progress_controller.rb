class V1::Dashboard::Echart::MeanProgressController < ApplicationController
  def index
    previous_week = (Date.today - 30).end_of_day
    logs  = Log.range_data(previous_week)
    wdays = V1::GroupLog.new(logs).by_wday

    hoje, previous_week = (Time.zone.now.utc.end_of_day), (Date.today - 29)
    spec_efec = V1::Dashboard::SpeculateActual.new(previous_week, hoje, wdays)
    echart = ::V1::Dashboard::Echart::MeanProgress.new(spec_efec.comparative)

    render json: { echart: echart.graph }
  end
end
