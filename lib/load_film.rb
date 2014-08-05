# encoding: utf-8

# Update films
class LoadFilm
  attr_reader :msg
  attr_reader :status

  def initialize #:notnew:
    @msg = []
    @films=[]
    @status = false
    @counters = init_counters
    @film_base_path = Pathname.new(CFG.films_base_path)
    @job = nil
  end

  def before(job)
    @job = job
  end

  # load the films table with the content of the disk
  # @return [Array] of message string if ok, false else
  def load_films
    update_films
  rescue => e
    my_msg("Fatal error: #{e.class},#{e.message}", true)
    log_message
    self
  end

  private

  def update_films
    my_msg('Start updating film DB', false)
    import_time = Time.zone.now
    films = list_films @film_base_path
    films.each_with_index do |entry, index|
      _f = {}
      _f[:name] = entry.basename(entry.extname).to_s
      _f[:path] = entry.relative_path_from(@film_base_path).to_s
      _f[:size] = entry.size
      create_or_update_film(import_time, _f)
      update_job_status(90*(index+1)/films.size) #TODO:
    end
    after_update(import_time)

    my_msg('End   updating film DB', false)
    log_message
    update_job_status(100)
    self
  end

  def update_job_status(value)
    return unless @job
    @job.update!(job_process_status: value)
  end

  def list_films(base)
    films=[]
    Dir.glob(File.join(base, '**', '*')) do |entry|
       films << Pathname.new(entry) if File.file?(entry)
    end
    films
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

  def create_or_update_film(import_time, film_entry)
    film = set_film_attr(import_time, film_entry)
    # save the record
    film.save!(validate: false)
  end

  def set_film_attr(import_time, film_entry)
    film = load_film(film_entry)

    film.assign_attributes(
        name: film_entry[:name],
        size: film_entry[:size],
        path: film_entry[:path],
        import_at: import_time,
        duplicate: false,
        deleted_at: nil,
        torrent: nil)
    film
  end

  def load_film(film_entry)
    film = Film.where(name: film_entry[:name]).first_or_initialize
    @counters[:new_count] += 1 if film.changed?
    film
  end

  def init_counters
    Hash[total_count: 0, new_count: 0, deleted_count: 0]
  end

  def after_update(import_time)
    my_msg("#{@counters[:new_count]} film(s) added", true)
    # delete mailboxes if they don't exist anymore
    my_msg("#{Film.where('import_at < ?', import_time).count} film(s) deleted", true)
    delete_films import_time
    my_msg("#{Film.find_duplicates.count} duplicate film(s) by size", true)
    Film.mark_duplicates
    update_job_status(97)
    Film.assign_torrents
    my_msg("#{Film.current.count} film(s)", true)
  end

  def delete_films(import_time)
    Film.current.where('import_at < ?', import_time).update_all(deleted_at: Time.zone.now)
    Film.deleted.each do |film|
      my_msg("#{film.name} is deleted at #{film.deleted_at}",true)
    end
    update_job_status(95)
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
