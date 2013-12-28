namespace :movies do
  desc 'Refresh Torrent DB'
  task(loadtorrents: :environment) do
    puts "#{Time.now.strftime('%d/%m/%Y %H:%M:%S')} loaddb: start refresh of Torrent DB"
    puts LoadTorrent.new.load_torrents.msg
    puts "#{Time.now.strftime('%d/%m/%Y %H:%M:%S')} loaddb: end   refresh of Torrent DB"
  end
end

