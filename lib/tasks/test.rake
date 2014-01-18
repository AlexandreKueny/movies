namespace :movies do
  desc 'test'
  task(test: :environment) do
    puts "#{Time.now.strftime('%d/%m/%Y %H:%M:%S')} loaddb: start test"
    puts Film.assign_complex_torrent
    puts "#{Time.now.strftime('%d/%m/%Y %H:%M:%S')} loaddb: end   test"
  end
end

