Naubino.Menu = class Menu extends Naubino.Layer
  constructor: (canvas) ->
    super(canvas)
    @canvas = Naubino.background
    @buttons = {}
    @pointer
    @paused = true
    @pointer = @center

    # fragile calibration! don't fuck it up!
    @fps = 1000 / 10
    @dt = @fps/1500
    
    @add_buttons()
    @pause()

  ## tempus fugit
  start_timer: ->
    if @paused
      @loop = setInterval(@mainloop, @fps )
      @paused = false

  stop_timer: ->
    clearInterval @loop
    @paused = true
  
  pause: ->
    if @paused
      @start_timer()
    else
      @stop_timer()

  mainloop: ()=>
    @draw()
    @draw_listener_region()

  step: ->
    for name, naub of @buttons
      naub.step (@dt)


  draw_main_button: (ctx) ->
    cube_size = 75

    ctx.save()
    ctx.translate(@physics.pos.x, @physics.pos.y)
    ctx.rotate(Math.PI/6)
    ctx.beginPath()
    ctx.rect( -cube_size/4, -cube_size/4, cube_size/2, cube_size/2)
    ctx.fillStyle = @shape.color_to_rgba @shape.style.fill
    ctx.fill()
    ctx.closePath()
    ctx.restore()

    ctx.save()
    ctx.translate(@physics.pos.x, @physics.pos.y)
    ctx.fillStyle = 'white'
    ctx.textAlign = 'center'
    ctx.font= 'bold 33px Helvetica'
    ctx.fillText(Naubino.game.points, 0,10, cube_size)
    ctx.restore()

  draw_listener_region: ->
    @ctx.save()
    @ctx.beginPath()
    @ctx.arc 0, 0, 100, 0, Math.PI*2, true
    @ctx.lineWidth = 1
    @ctx.strokeStyle = "grey"
    @ctx.stroke()
    #if @ctx.isPointInPath(@pointer.x,@pointer.y)
    @ctx.closePath()
    @ctx.restore()

  add_buttons: ->

    @buttons.main = new Naubino.Naub()
    @buttons.main.draw = @draw_main_button
    @buttons.main.physics.pos.Set(20,25)

    @buttons.play = new Naubino.Naub()
    @buttons.play.physics.pos.Set(70,30)
    @buttons.play.focus = -> console.log "pressed play"

    @buttons.main.join_with(@buttons.play)

  draw: ->
    @ctx.clearRect(0, 0, Naubino.world_canvas.width, Naubino.world_canvas.height)
    @ctx.save()
    @buttons.main.draw_joins(@ctx)
    @buttons.main.draw(@ctx)
    @buttons.play.draw(@ctx)
    @ctx.restore()

  ## can I touch this?
  click: (x, y) ->
    @mousedown = true
    button = @get_obj x, y
    if button
      button.focus()

  get_obj: (x, y) ->
    for name, naub of @buttons
      if naub.isHit(x, y)
        return naub

  move_pointer: (x,y) ->
    [@pointer.x, @pointer.y] = [x,y]
