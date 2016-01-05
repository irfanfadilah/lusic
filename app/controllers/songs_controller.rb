class SongsController < ApplicationController
  before_action :set_song, only: [:next]
  before_action :list_all_files, only: [:index, :next, :search]

  # GET /songs
  # GET /songs.json
  def index
    if params[:admin].present?
      cookies[:admin] = params[:admin]
    end
    @current = decide_song
    @songs_in_playlist = Song.all
  end

  # # GET /songs/1
  # # GET /songs/1.json
  # def show
  # end

  # # GET /songs/new
  # def new
  #   @song = Song.new
  # end

  # # GET /songs/1/edit
  # def edit
  # end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(title: params[:song], file: "/music/#{params[:song]}.mp3")
    SongBroadcastJob.perform_later(@song) if @song.save
    respond_to { |format| format.js }
  end

  # # PATCH/PUT /songs/1
  # # PATCH/PUT /songs/1.json
  # def update
  #   respond_to do |format|
  #     if @song.update(song_params)
  #       format.html { redirect_to @song, notice: 'Song was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @song }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @song.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /songs/1
  # # DELETE /songs/1.json
  # def destroy
  #   @song.destroy
  #   respond_to do |format|
  #     format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  # Next song in playlist
  def next
    @song.destroy
    @current = decide_song
    NextSongBroadcastJob.perform_later(@song.slug, @current)
    respond_to { |format| format.js }
  end

  # Upload song to local server
  def upload
    flash = if params[:song].present?
      params[:song].each { |song| SongUploader.new.store!(song) }
      list_all_files
      SongListBroadcastJob.perform_later(@files)
      { notice: "#{params[:song].length} song(s) added successfully!" }
    else
      { alert: "Please select one or more songs to be uploaded!" }
    end
    redirect_to root_path, flash
  end

  # Search songs and return it to user
  def search
    @query = params[:q]
    @files = @files.select { |song| song.downcase.include? @query.downcase } if @query.present?
    respond_to { |format| format.js }
  end

  # Switch mode
  def mode
    cookies[:mode] = if cookies[:mode].eql? "discjockey"
      mode = "Audience"; "audience"
    elsif cookies[:mode].eql? "audience"
      mode = "DiscJockey"; "discjockey"
    end
    redirect_to root_path, notice: "Switched to #{mode} Mode"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # # Never trust parameters from the scary internet, only allow the white list through.
    # def song_params
    #   params.require(:song).permit(:title, :file)
    # end

    # Decide current song to play
    def decide_song
      if Song.count.eql? 0
        random_song = @files.sample
        song = Song.create(title: random_song, file: "/music/#{random_song}.mp3")
        SongBroadcastJob.perform_later(song)
      end
      Song.first
    end

    # All files
    def list_all_files
      @files = Dir.glob("public/music/*.mp3").sort_by { |file| file.downcase }.map! do |file|
        [["public/music/", ""], [".mp3", ""]].each { |word| file.sub!(word[0], word[1]) }; file
      end
    end
end
