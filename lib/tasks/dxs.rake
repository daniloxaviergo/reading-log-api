desc "Update database from leituras.txt"
task :dxupdate => :environment do
  projects = YAML.load_file('/home/danilo/Documents/scripts/manager_reader/leituras.txt')

  last_update = Log.order(data: :desc).first
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
