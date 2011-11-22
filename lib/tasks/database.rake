namespace :db do
  desc "Create, download, import and anonymize production database dump into local db"
  task :clone_production => %w(db:create_dump db:import_dump db:anonymise_dump)
  
  desc "Create and download production db dump remotely"
  task :create_dump do
    Bundler.with_clean_env{ sh "cap production db:backup" }
  end
  
  def mysql_execute(config_db)
    "mysql -u #{config_db['username']} --password='#{config_db['password']}'"
  end

  desc "Import the latest dump to a local database and run migrations"
  task :import_dump do
    filename = "betterplace.dump.sql.bz2"

    config_db = YAML::load_file('config/database.yml')[RAILS_ENV]
    database_name = config_db['database']
    puts "Loading #{filename} into local '#{RAILS_ENV}' database (#{database_name})"

    # Drop and recreate DB
    `#{mysql_execute(config_db)} -e "DROP DATABASE #{database_name};"`
    `#{mysql_execute(config_db)} -e "CREATE DATABASE #{database_name};"`

    `bunzip2 < #{filename} | mysql -u #{config_db['username']} --password='#{config_db['password']}' #{database_name}`
    puts "command finished"

    Rake::Task['db:migrate'].invoke
  end
  
  desc "Anonymise production data (emails)"
  task :anonymise_dump => :environment do
    ActiveRecord::Base.establish_connection
    puts "Anonymizing user emails ..."
    email = ENV['EMAIL'] || "mimimi@piupiu.at"
    quoter = lambda { |string| ActiveRecord::Base.connection.quote(string) }
    ActiveRecord::Base.connection.execute("update users set email='#{email}' WHERE email NOT like '%@piupiu.at' OR email = 'ismail.hanli@hotmail.com'")
  end
end