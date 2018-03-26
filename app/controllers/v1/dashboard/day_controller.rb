class V1::Dashboard::DayController < ApplicationController
  def index
    last_week_pages     = Log.last_week.map(&:read_pages).sum
    previous_week_pages = Log.previous_week.map(&:read_pages).sum
    # > 1 positivo # < 1 negativo
    percentage_pages    = (last_week_pages.to_f) / previous_week_pages.to_f

    wday = Date.today.wday
    statsLog = StatsLog.new(Log.all)#.mean.speculate.by_wday(1).inspect

    stats = {
      previous_week_pages: previous_week_pages,
      percentage_pages:    percentage_pages.round(3),
      last_week_pages:     last_week_pages,

      max_day:             statsLog.max.by_wday(wday),
      mean_day:            statsLog.mean.by_wday(wday),
      mean_geral:          statsLog.mean.geral,
      speculate_mean_day:  statsLog.mean.speculate.by_wday(wday)
    }

    render json: { stats: stats }
  end
end