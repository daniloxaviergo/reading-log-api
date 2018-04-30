class V1::Dashboard::DayController < ApplicationController
  def index
    last_week_pages     = Log.last_week.map(&:read_pages).sum
    previous_week_pages = Log.previous_week.map(&:read_pages).sum
    # > 1 positivo # < 1 negativo
    per_pages           = (last_week_pages.to_f) / previous_week_pages.to_f

    wday     = Date.current.wday
    statsLog = V1::StatsLog.new(Log.all)

    mean_last_week   = 15.days.ago.end_of_day
    statsLogLastWeek = V1::StatsLog.new(Log.range_data(mean_last_week))

    previous_mean = statsLogLastWeek.mean.by_wday(wday)
    per_mean_day  = statsLog.mean.compare(wday, previous_mean)

    previous_spec_mean = statsLogLastWeek.mean.speculate.by_wday(wday)
    per_spec_mean_day  = statsLog.mean.speculate.compare(wday, previous_mean)

    stats = {
      previous_week_pages: previous_week_pages,
      last_week_pages:     last_week_pages,
      per_pages:           per_pages.round(3),
      
      max_day:             statsLog.max.by_wday(wday),
      mean_day:            statsLog.mean.by_wday(wday),
      mean_geral:          statsLog.mean.geral,
      per_mean_day:        per_mean_day,
      spec_mean_day:       statsLog.mean.speculate.by_wday(wday),
      per_spec_mean_day:   per_spec_mean_day
    }

    render json: { stats: stats }
  end
end