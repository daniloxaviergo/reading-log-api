# docker container exec ruby bash -c 'cd /usr/src/app/reading-log-api/; rails neural_dataset'
# docker container exec -it ruby bash -c 'cd /usr/src/app/reading-log-api/; rails console'

# Time.at(1645796143)

desc "Update database from leituras.txt"
task :dxupdate => :environment do
  projects = YAML.load_file('/leituras.txt')

  last_update = Log.order(data: :desc).first
  # last_update = Log.order(data: :asc).first
  last_update = last_update && last_update[:data].beginning_of_day

  projects.each do |project|
    logs = project.delete(:logs)
    logs = logs.select do |log|
      last_update.blank? || log[:data].to_datetime.in_time_zone > last_update
    end
    
    next if logs.empty?
    db_project = Project.where(name: project[:nome]).first
    # pensar uma forma de utilizar o merge com scopes activerecord ticks
    # Project.joins(:logs).merge(Log.range_data('123'))
    # Project.joins(:logs).merge(Log.order_wday)

    if db_project
      update_project(db_project, project, logs)
    else
      create_project(project, logs)      
    end

    puts "\n"
  end
end

task :dxreading_day => :environment do
  logs  = Log.all
  wdays = V1::GroupLog.new(logs).by_wday
  puts "[#{wdays[Date.today.wday].join(',')}]"
  puts ''
  puts ''
  puts "{#{wdays[Date.today.wday].map { |w| "\"#{w.to_i}\" => 0"}.join(',')}}"
end

task :dxlinear_data => :environment do
  linear = {}
  projects = Project.all.running.order(:id)
  projects.each do |project|
    logs = project.logs
    service = V1::GroupLog.new(logs)

    pages_by_day = service.by_data.map { |l| l[:end_page] }.reverse
    number_days = pages_by_day.size.times.map { |i| i+1 }
    linear[project.name] = {
      pages_by_day: pages_by_day,
      number_days: number_days
    }

    # puts project.name
  end

  File.open('/usr/src/app/linear_data','w') do |f|
    f.write(linear.to_json)
  end
end

task :dxholtwinters => :environment do
  project_ids = Log.select('logs.project_id').joins(:project)
                   .where('projects.page = projects.total_page')
                   .group('logs.project_id')
                   .order('logs.project_id DESC')
                   .limit(15).map { |l| l.project_id }

  days_reading_project = {}
  Log.where(project_id: project_ids).order(id: :asc).each do |log|
    days_reading_project[log.project_id] ||= []
    next if days_reading_project.size > 40

    days_reading_project[log.project_id].push(log.created_at.to_date.to_s)
  end

  frequency_read_project = {}
  days_reading_project.each_with_index.each do |(project_id, dates)|
    frequency_read_project[project_id] ||= []
    first_read = dates.first.to_date

    last_read  = (first_read + 40.days)
    last_read  = last_read > dates.last.to_date ? dates.last.to_date : last_read

    (first_read..last_read).each do |date|
      read_in_day = dates.include?(date.to_s) ? '2' : '1'
      frequency_read_project[project_id].push(read_in_day)
    end
  end

  frequency_in_read_project = {}
  Project.includes(:logs).running.each do |project|
    first_read = project.logs.order(id: :asc).last.created_at.to_date
    last_read  = project.logs.order(id: :asc).first.created_at.to_date
    read_dates = project.logs.order(id: :asc).map { |l| l.created_at.to_date.to_s }

    dates = {}
    (first_read..last_read).each do |date|
      read_in_day = read_dates.include?(date.to_s) ? '2' : '1'
      dates[date.to_s] = read_in_day
    end

    projects_day_of_read = {}
    # puts project.name
    # puts "dates.keys.size: #{dates.keys.size}"
    # utiliza dates para fazer a previsão
    if dates.keys.size > 30 #40
      frequency_in_read_project[project.name] = dates.values
    else
      # utiliza a 'media' dos projetos
      days_to_add = 1
      while (days_to_add < 40) do
        date = (first_read + days_to_add.days).to_s

        if dates[date.to_s].present?
          projects_day_of_read[project.id] = dates[date.to_s]
          days_to_add = days_to_add + 1
          next
        end

        idx_seach_history_read = days_to_add - 1
        history_reads = frequency_read_project.each_with_index.map do |(project_id, dates)|
          dates[idx_seach_history_read]
        end

        reads_count   = (history_reads || []).select { |h| h == '2' }.count
        unreads_count = (history_reads || []).select { |h| h == '1' }.count

        read_in_day = reads_count > unreads_count ? '2' : '1'
        dates[date.to_s] = read_in_day

        days_to_add = days_to_add + 1
      end

      # puts dates.to_json;
      frequency_in_read_project[project.name] = dates.values
    end
  end

  # puts frequency_in_read_project
  # puts frequency_read_project
  File.open('/usr/src/app/holtwinters','w') do |f|
    f.write(frequency_in_read_project.to_json)
  end
end

task :neural_dataset => :environment do
  project_ids = Log.select('logs.project_id').joins(:project)
                   .where('projects.page >= projects.total_page')
                   .group('logs.project_id')
                   .order('logs.project_id DESC')
                   .map { |l| l.project_id }

  days_reading_project = {}
  Log.where(project_id: project_ids).order(id: :asc).each do |log|
    days_reading_project[log.project_id] ||= []
    days_reading_project[log.project_id].push(log.created_at.to_date.to_s)
  end

  frequency_read_project = {}
  days_reading_project.each_with_index.each do |(project_id, dates)|
    next if dates.blank? || dates.length < 3

    frequency_read_project[project_id] ||= []
    first_read = dates.first.to_date
    last_read  = dates.last.to_date

    day_number = 1
    (first_read..last_read).each do |date|
      read_in_day = dates.include?(date.to_s) ? 0.2 : 0.1
      # day_number_read = ["0.#{project_id}".to_f, day_number, read_in_day]
      day_number_read = [project_id.to_i, day_number, read_in_day]

      frequency_read_project[project_id].push(day_number_read)
      day_number = day_number + 1
    end
  end

  text_csv = []
  frequency_read_project.keys.each do |key|
    frequency_read_project[key].each do |read_project|
      text_csv.push(read_project.join(','))
    end
  end

  File.open('/usr/src/app/neural_dataset.csv','w') do |f|
    f.write(text_csv.join("\n"))
  end
end

def create_project(project, logs)
  started_at = project.delete(:inicio)
  project[:started_at] = started_at

  p_name = project.delete(:nome)
  project[:name] = p_name

  db_project = Project.create(project)
  puts "Importando: #{db_project.name}"
  update_logs(db_project, logs)
end

def update_project(db_project, project, logs)
  puts "Atualizando: #{db_project.name}"
  attrs = {
    total_page: project[:total_page],
    started_at: project[:inicio],
    page:       project[:page]
  }
  db_project.update(attrs)

  update_logs(db_project, logs)
end

def update_logs(db_project, logs)
  logs ||= []
  logs.each do |log|
    data   = log[:data].to_datetime.in_time_zone
    db_log = db_project.logs.where(data: data).first

    if db_log
      # print(" #{log[:end_page]} ")
      next
    end

    log.delete(:from_web) # adicionar attribute
    log[:created_at] = data
    log[:updated_at] = data
    log[:data]       = data

    print(" #{log[:end_page]} ")
    Log.create(log.merge(project_id: db_project.id))
  end

end
