# TODO clean up menu code -- will do in naub_rethought
define ["Layer", "Naub", "Graph", "Shapes", "Factory"], (Layer, Naub, Graph, { Ball, StringShape, PlayButton, PauseButton, MainButton }, Factory) -> class Menu extends Layer
  constructor: (canvas) ->
    super(canvas)
    @name = "menu"
    @graph = new Graph this
    @factory = new Factory this
    @animation.name = "menu.animation"

    @objects = {}
    @hovering = off

    @listener_size = @default_listener_size = 45
    Naubino.mousemove.add @move_pointer
    Naubino.mousedown.add @click
    Naubino.menu_button.active = false
   
    @center = new cp.v(20,25)
    @cube_size = 45
    @default_fps = @fps = 35
    
    StateMachine.create {
      target:this
      events: Naubino.settings.events
      error: (e, from, to, args, code, msg) -> console.error "#{@name}.#{e}: #{from} -> #{to}\n#{code}::#{msg}"
    }

  # changing the state a little
  oninit: ->
    @add_buttons()
    @start_stepper()

  buttons:
    main:
      position:  new cp.v(20,25)
      function: ->
        console.info "menu"
      shapes: [new MainButton]
      #shapes: []
    play:
      function: -> Naubino.play()
      position: new cp.v(70,32)
      shapes: [new Ball, new PlayButton]
    help:
      function: -> Naubino.tutorial()
      position: new cp.v(55,65)
      shapes: [new Ball, new StringShape "?", "white"]
    exit:
      function: -> Naubino.stop()
      position: new cp.v(20,80)
      shapes: [new Ball, new StringShape "X", "white"]

  add_buttons: ->
    @objects[name] = @factory.add_button(button.position, button.function, button.shapes) for name, button of @buttons
    @objects.main.life_rendering = on

  onenterplaying: ->
    @objects.play.focus = -> Naubino.pause()
    @objects.play.shapes.pop()
    @objects.play.add_shape new PauseButton
    @objects.play.update()

  onenterpaused: ->
    @objects.play.focus = -> Naubino.play()
    @objects.play.shapes.pop()
    @objects.play.add_shape new PlayButton
    @objects.play.update()

  onenterstopped: (e,f,t) -> @onenterpaused() unless e is 'init'

  step: ->
    for name, naub of @objects
      if @hovering
        naub.pos = cp.v.lerp(naub.pos, naub.fixed_pos, 0.1) unless name == "main"
        naub.isClickable = yes if naub.pos == naub.fixed_pos
      else
        naub.pos = cp.v.lerp(naub.pos, @center, 0.15) unless name == "main"
        naub.isClickable = no

  ## can I touch this?
  move_pointer: (x,y) -> [@pointer.x, @pointer.y] = [x,y]

  click: (x, y) =>
    @mousedown = true

    for name, naub of @objects
      if naub.isHit @pointer
        naub.focus()
        @focused_naub = naub
        break

  draw: ->
    @draw_menu()
    @draw_listener_region()

  draw_menu: ->
    @ctx.clearRect(0, 0, Naubino.game_canvas.width, Naubino.game_canvas.height)
    @ctx.save()
    for name, naub of @objects
      naub.draw_join(@ctx,@objects.main)
      naub.draw(@ctx)
    @objects.main.draw(@ctx)
    @objects.main.draw_joins()
    @ctx.restore()

  activate_menu: ->
    Naubino.menu_focus.dispatch()
    @animation.refresh_timer @default_fps

    @for_each (b) -> b.isClickable = yes
    @listener_size = 90
    @start_stepper()

  deactivate_menu: ->
    Naubino.menu_blur.dispatch()

    @for_each (b) -> b.isClickable = no
    @listener_size = @default_listener_size
    setTimeout (
      =>
        console.log @fps
        @stop_stepper()
        @animation.refresh_timer 3
        console.log "refreshed menu timer"
        console.log @fps
    ),1000



  draw_listener_region: ->
    @ctx.save()
    @ctx.beginPath()
    @ctx.arc 0, 15, @listener_size, 0, Math.PI*2, true

    if @ctx.isPointInPath(@pointer.x,@pointer.y)
      @activate_menu() unless @hovering
    else
      @deactivate_menu() if @hovering

    #@ctx.stroke() # like to see it
    @ctx.closePath()
    @ctx.restore()

