class NextSongBroadcastJob < ApplicationJob
  queue_as :default

  def perform(song_elem, current)
    ActionCable.server.broadcast 'song_channel', next: { song_elem: song_elem, current: current }
  end
end
