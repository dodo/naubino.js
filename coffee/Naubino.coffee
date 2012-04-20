########################################################
#     _   __            __    _                 _      #
#    / | / /___ ___  __/ /_  (_)___  ____      (_)____ #
#   /  |/ / __ `/ / / / __ \/ / __ \/ __ \    / / ___/ #
#  / /|  / /_/ / /_/ / /_/ / / / / / /_/ /   / (__  )  #
# /_/ |_/\__,_/\__,_/_.___/_/_/ /_/\____(_)_/ /____/   #
#                                        /___/         #
########################################################

# TODO questionable approach
# window.onload = ->
#   Naubino.constructor()


define "Background Game Graph Keybindings Menu Overlay StandardGame TestCase Settings Tutorial".split(" "), (Background, Game, Graph, KeyBindings, Menu, Overlay, StandardGame, TestCase, Settings, Tutorial) -> class Naubino
  constructor: () ->
    console.log "Naubino Constructor"

    @graph = new Graph()
    @colors = Settings.colors.output
    @create_fsm()
    @Signal = window.signals.Signal
    @add_signals()
    @add_listeners()

  setup: ->
    @init_dom()
    @init_layers()

    @setup_keybindings()
    @setup_cursorbindings()


  print: -> @gamediv.insertAdjacentHTML("afterend","<img src=\"#{@game_canvas.toDataURL()}\"/>")

  init_dom: () ->
    @gamediv           = document.querySelector("#gamediv")
    @overlay_canvas    = document.querySelector("#overlay_canvas")
    @menu_canvas       = document.querySelector("#menu_canvas")
    @game_canvas       = document.querySelector("#game_canvas")
    @background_canvas = document.querySelector("#background_canvas")

    for canvas in  @gamediv.querySelectorAll("canvas")
      canvas.width = Settings.canvas.width
      canvas.height = Settings.canvas.height

  init_layers: ->
    @gamediv.max-width     = Settings.canvas.width

    @background    = new Background(@background_canvas)
    @game_standart = new StandardGame(@game_canvas, @graph)
    @game_testcase = new TestCase(@game_canvas, @graph)
    @game_tutorial = new Tutorial(@game_canvas, @graph)
    #@game          = @game_standart
    @game          = @game_testcase
    #@menu          = new Menu(@menu_canvas)
    @overlay       = new Overlay(@overlay_canvas)

    #@menu.init()
    #@menu.animation.play()
    @game.init()
    @play() # testcase



  ###
  Everything has to have state
  ###
  create_fsm: ->
    StateMachine.create {
      target: this
      initial: {state : 'stopped' , event: 'init'}
      events: Settings.events
    }

  list_states: ->
    @.name = "Naubino"
    for o in [ @, @menu, @game, @overlay.animation, @menu.animation, @game.animation, @background.animation]
      switch o.current
        when 'playing' then console.info o.name, o.current
        when 'paused'  then console.warn o.name, o.current
        when 'stopped' then console.warn o.name, o.current
        else console.error o.name, o.current

  onchangestate: (e,f,t)-> console.info "Naubino changed states #{e}: #{f} -> #{t}"
  onbeforeplay: (event, from, to) -> @game.play()
  #onenterplaying: -> @menu.play()

  toggle: ->
    switch @current
      when 'playing' then @pause()
      when 'paused'  then @play()

  onbeforepause: (event, from, to) ->
    unless from == "init"
      #console.time('state_paused')
      @game.pause()
      @menu.pause()

  onenterpaused: ->
    #console.timeEnd('state_paused')
    #@game.animation.pause()

  onpause: (event, from, to) ->

  onbeforestop: (event, from, to) ->
    @game.stop()
    @menu.stop()





  ###
  Signals connect everything else that does not react to events
  ###

  add_signals: ->
    # user interface
    @mousedown       = new @Signal()
    @mouseup         = new @Signal()
    @mousemove       = new @Signal()
    @keydown         = new @Signal()
    @keyup           = new @Signal()
    @touchstart      = new @Signal()
    @touchend        = new @Signal()
    @touchmove       = new @Signal()

    # gameplay
    @naub_replaced   = new @Signal()
    @naub_joined     = new @Signal()
    @naub_destroyed  = new @Signal()
    @cycle_found     = new @Signal()
    @naub_focused    = new @Signal()
    @naub_unfocused  = new @Signal()

    # menu
    @menu_button     = new @Signal()
    @menu_focus      = new @Signal()
    @menu_blur       = new @Signal()


  add_listeners: ->
    @menu_focus.add =>
      @menu.hovering = @menu_button.active = true

    @menu_blur.add =>
      @menu.hovering = @menu_button.active = false



  setup_keybindings: () ->
    @keybindings = new KeyBindings()
    window.onkeydown = (key) => @keybindings.keydown(key)
    window.onkeyup = (key) => @keybindings.keyup(key)
    @keybindings.enable 32, => @toggle()

  setup_cursorbindings: () ->
    # TODO mouse events should be handled though Signals
    onmousemove = (e) =>
      @mousemove.dispatch e.pageX - @overlay_canvas.offsetLeft, e.pageY - @overlay_canvas.offsetTop

    onmouseup = (e) =>
      @mouseup.dispatch e.pageX - @overlay_canvas.offsetLeft, e.pageY - @overlay_canvas.offsetTop

    onmousedown = (e) =>
      @mousedown.dispatch e.pageX - @overlay_canvas.offsetLeft, e.pageY - @overlay_canvas.offsetTop

    @overlay_canvas.addEventListener("mousedown"  , onmousedown , false)
    @overlay_canvas.addEventListener("mouseup"    , onmouseup   , false)
    @overlay_canvas.addEventListener("mousemove"  , onmousemove , false)
    @overlay_canvas.addEventListener("mouseout"   , onmouseup   , false)

    @overlay_canvas.addEventListener("touchstart" , onmousedown , false)
    @overlay_canvas.addEventListener("touchend"   , onmouseup   , false)
    @overlay_canvas.addEventListener("touchmove"  , onmousemove , false)
