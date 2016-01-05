class SongListBroadcastJob < ApplicationJob
  queue_as :default

  def perform(files)
    ActionCable.server.broadcast 'song_channel', list: render_list(files)
  end

  private
    def render_list(files)
      ApplicationController.renderer.render(partial: "songs/list", locals: { files: files })
    end
end
