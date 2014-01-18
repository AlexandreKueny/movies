class FilmsController < ApplicationController
  before_action :set_film, only: [:show, :edit, :update, :destroy, :download]

  # GET /films
  # GET /films.json
  def index
    @films = Film.includes(:torrent).order(name: :asc)
  end

  # GET /films/deleted
  # GET /films/deleted.json
  def deleted
    @films = Film.deleted.includes(:torrent).order(name: :asc)
  end

  # GET /films/1
  # GET /films/1.json
  def show
  end

  # GET /films/new
  #def new
  #  @film = Film.new
  #end

  # GET /films/1/edit
  def edit
  end

  # POST /films
  # POST /films.json
  #def create
  #  @film = Film.new(film_params)
  #
  #  respond_to do |format|
  #    if @film.save
  #      format.html { redirect_to @film, notice: 'Film was successfully created.' }
  #      format.json { render action: 'show', status: :created, location: @film }
  #    else
  #      format.html { render action: 'new' }
  #      format.json { render json: @film.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PATCH/PUT /films/1
  # PATCH/PUT /films/1.json
  def update
    respond_to do |format|
      if @film.update(film_params)
        format.html { redirect_to @film, notice: 'Film was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @film.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /films/1
  # DELETE /films/1.json
  def destroy
    @film.destroy
    respond_to do |format|
      format.html { redirect_to films_url }
      format.json { head :no_content }
    end
  end

  def sync(msg = '')
    msg << LoadFilm.new.load_films.msg.join(',')
    redirect_to sync_link, notice: msg
  end

  def sync_all
    msg = LoadTorrent.new.load_torrents.msg
    sync msg
  end

  def download
    torrent_path = File.join(CFG.torrents_base_path, @film.torrent.path)
    system "start #{CFG.torrents_downloader} \"#{torrent_path.gsub('/','\\')}\""
    render :nothing => true, :layout => false
    #redirect_to torrents_url #notice: LoadTorrent.new.load_torrents.msg
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_film
      @film = Film.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def film_params
      params.require(:film).permit(:name, :path, :comment, :torrent_id)
    end

  def sync_link
    deleted_films? ? deleted_films_url : films_url
  end

   def deleted_films?
     Film.deleted.count > 0
   end
end
