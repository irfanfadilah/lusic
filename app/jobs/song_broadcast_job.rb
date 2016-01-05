class SongBroadcastJob < ApplicationJob
  queue_as :default

  def perform(song)
    ActionCable.server.broadcast 'song_channel', song: render_song(song)
  end

  private
    def render_song(song)
      ApplicationController.renderer.render(partial: "songs/song", locals: { song: song })
    end
end
