center_text = (text) ->
  $el = $ '<div>'
  $el.addClass "center_text"
  $el.append $ "<span>#{text}</span>"
  $el

class Welcome
  constructor: ->
    @$el = center_text "Welcome"

class Game
  constructor: ->
    @$el = center_text "Game"

class Pause
  constructor: ->
    @$el = center_text "Pause"

define -> #['Naubino', 'WelcomeGame', 'StandardGame'], (Naubino, WelcomeGame, StandardGame) ->

  welcome = new Welcome
  game = new Game
  pause = new Pause
  welcome.$el.click ->
    welcome.$el.hide()
    game.$el.show()
  game.$el.click ->
    game.$el.hide()
    pause.$el.show()
  pause.$el.click ->
    pause.$el.hide()
    game.$el.show()

  window.onload = ->
    $naubino = $ '#Naubino'
    for layer in [game, welcome, pause]
      $naubino.append layer.$el.hide()
    welcome.$el.show()
