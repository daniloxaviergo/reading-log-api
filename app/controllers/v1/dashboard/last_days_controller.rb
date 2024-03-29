class V1::Dashboard::LastDaysController < ApplicationController
  def index
    if ago.zero?
      return render json: 'Unprocessable Entity', status: :unprocessable_entity
    end

    if ago == 1
      datab = Date.current.beginning_of_day
      datae = Date.current.end_of_day
      logs = Log.eager_load(:project).where("#{Log.table_name}.data BETWEEN ? AND ?", datab, datae)
    else
      data = (Date.current - ago.days).beginning_of_day
      logs = Log.eager_load(:project).where("#{Log.table_name}.data > ?", data)
    end

    logs = ::V1::GroupLog.new(logs).by_project
    count_pages = logs.map { |l| l[:read_pages] }.flatten.sum
    config      = ::V1::UserConfig.new.get
    spec_days   = "paginas_#{ago}_days"
    stats       = {
      count_pages:     count_pages,
      speculate_pages: config[spec_days]
    }

    render json: { logs: logs, stats: stats }
  end

  private

  def ago
    case params[:type]
    when '1'
      7
    when '2'
      15
    when '3'
      30
    when '4'
      90
    when '5'
      1
    else
      0
    end
  end
end
