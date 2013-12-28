class TFilmsController < ApplicationController
  before_action :set_t_film, only: [:show, :edit, :update, :destroy]

  # GET /t_films
  # GET /t_films.json
  def index
    @t_films = TFilm.includes(:torrent).order(name: :asc)
  end

  # GET /t_films/1
  # GET /t_films/1.json
  def show
  end

  # GET /t_films/new
  def new
    @t_film = TFilm.new
  end

  # GET /t_films/1/edit
  def edit
  end

  # POST /t_films
  # POST /t_films.json
  def create
    @t_film = TFilm.new(t_film_params)

    respond_to do |format|
      if @t_film.save
        format.html { redirect_to @t_film, notice: 'T film was successfully created.' }
        format.json { render action: 'show', status: :created, location: @t_film }
      else
        format.html { render action: 'new' }
        format.json { render json: @t_film.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /t_films/1
  # PATCH/PUT /t_films/1.json
  def update
    respond_to do |format|
      if @t_film.update(t_film_params)
        format.html { redirect_to @t_film, notice: 'T film was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @t_film.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /t_films/1
  # DELETE /t_films/1.json
  def destroy
    @t_film.destroy
    respond_to do |format|
      format.html { redirect_to t_films_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_t_film
      @t_film = TFilm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def t_film_params
      params.require(:t_film).permit(:name, :size, :torrent)
    end
end
