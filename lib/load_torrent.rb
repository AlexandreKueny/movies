# encoding: utf-8

# Update torrents
class LoadTorrent
  attr_reader :msg
  attr_reader :status

  def initialize #:notnew:
    @msg = []
    @torrents=[]
    @status = false
    @counters = init_counters
    @torrent_base_path = Pathname.new(CFG.torrents_base_path)
  end

  # load the torrents table with the content of the disk
  # @return [Array] of message string if ok, false else
  def load_torrents
    update_torrents
    #rescue => e
    #  my_msg("Fatal error: #{e.class},#{e.message}", true)
    #  log_message
    #  self
  end

  private

  def update_torrents
    my_msg('Start updating torrent DB', false)
    import_time = Time.zone.now
    list_dir @torrent_base_path do |entry|
      _f = {}
      _f[:name] = entry.basename(entry.extname).to_s
      _f[:path] = entry.relative_path_from(@torrent_base_path).to_s
      t = TorrentFile.open(entry).to_h
      _f[:t_films] = convert_torrent t
      create_or_update_torrent(import_time, _f)
    end
    after_update(import_time)

    my_msg('End   updating torrent DB', false)
    log_message
    self
  end


  def list_dir(base, &block)
    base.each_child do |entry|
      if entry.directory?
        list_dir entry, &block
      else
        block_given? ? yield(entry) : entry
      end
    end
  end

  def create_or_update_torrent(import_time, torrent_entry)
    torrent = set_torrent_attr(import_time, torrent_entry)
    # save the record
    torrent.save!(validate: false)
  end

  def set_torrent_attr(import_time, torrent_entry)
    torrent = load_torrent(torrent_entry)

    torrent.assign_attributes(
        name: torrent_entry[:name],
        path: torrent_entry[:path],
        import_at: import_time,
        deleted_at: nil)
    t_films = torrent.t_films.all
    torrent_entry[:t_films].each do |film|
      unless t_films.map{|t| t.name}.include?(film[:name])
        torrent.t_films.build(
            name: film[:name],
            size: film[:size]
        )
      end
    end
    torrent
  end

  def load_torrent(torrent_entry)
    torrent = Torrent.where(name: torrent_entry[:name]).first_or_initialize
    @counters[:new_count] += 1 if torrent.changed?
    torrent
  end

  def init_counters
    Hash[total_count: 0, new_count: 0, deleted_count: 0]
  end

  def after_update(import_time)
    my_msg("#{@counters[:new_count]} torrent(s) added", true)
    # delete mailboxes if they don't exist anymore
    delete_torrents import_time
    my_msg("#{Torrent.where('import_at < ?', import_time).count} torrent(s) deleted", true)
    my_msg("#{Torrent.current.count} torrent(s)", true)
  end

  def delete_torrents(import_time)
    Torrent.current.where('import_at < ?', import_time).update_all(deleted_at: Time.zone.now)
    Torrent.deleted.each do |torrent|
      my_msg("#{torrent.name} is deleted at #{torrent.deleted_at}", true)
    end
  end

  def convert_torrent(t)
    if files = t['info']['files']
      fa=[]
      files.each do |f|
        f['path'].each do |g|
          if g =~ /\.(avi|mkv|mpeg|mp4)\Z/
            fa << {name: g.force_encoding('UTF-8'), size: f['length']}
          end
        end
      end
      fa
    else
      [{name: t['info']['name'], size: t['info']['length']}]

    end
  end


  # append output msg to ret_msg and log msg
  def my_msg(msg = nil, put_msg = false)
    Rails.logger.info { "#{self.class}: #{msg}" }
    @msg << msg if put_msg
    true
  end

  # Add messages to History
  def log_message
    #History.new(
    #    mailbox_name: 'N/A',
    #    name: @updater,
    #    message: Array(@msg).join(',')
    #).save!
  end
end
