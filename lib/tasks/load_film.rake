namespace :movies do
  desc 'Refresh Film DB'
  task(loadfilms: :environment) do
    puts "#{Time.now.strftime('%d/%m/%Y %H:%M:%S')} loaddb: start refresh of Film DB"
    puts LoadFilm.new.load_films.msg
    puts "#{Time.now.strftime('%d/%m/%Y %H:%M:%S')} loaddb: end   refresh of Film DB"
  end
end

