desc "Update database from leituras.txt"
task :dxupdate => :environment do
  projects = YAML.load_file('/home/danilo/Documents/scripts/manager_reader/leituras.txt')

  projects.each do |project|
    logs       = project.delete(:logs)
    db_project = Project.where(nome: project[:nome]).first

    if db_project
      update_project(db_project, project, logs)
    else
      create_project(project, logs)      
    end

    puts "\n"
  end
end

def create_project(project, logs)
  db_project = Project.create(project)

  puts "Importando: #{db_project.nome}"
  update_logs(db_project, logs)
end

def update_project(db_project, project, logs)
  puts "Atualizando: #{db_project.nome}"
  attrs = {
    total_page: project[:total_page],
    inicio:     project[:inicio],
    page:       project[:page]
  }
  db_project.update(attrs)

  update_logs(db_project, logs)
end

def update_logs(db_project, logs)
  logs ||= []
  logs.each do |log|
    data   = log[:data].to_datetime.asctime.to_datetime.utc
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