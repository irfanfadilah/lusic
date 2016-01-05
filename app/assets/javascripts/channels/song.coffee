App.song = App.cable.subscriptions.create "SongChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data['next']
      # Next Song
      current = data['next']['current']['id']
      $("##{data['next']['song_elem']}").slideUp()
      $("#source").attr "src", data['next']['current']['file']
      if Cookies.get("mode") == "discjockey"
        $("#player")[0].load()
        $("#player")[0].play()
      setTimeout ->
        $("##{data['next']['current']['slug']}").append '<span class="label label-primary">Now Playing</span>'
        return
      , 1000
    else if data['song']
      # Add Song
      $("#playlist").append data['song']
    else if data['list']
      # Refresh Song List
      $("#song-list").html data['list']
