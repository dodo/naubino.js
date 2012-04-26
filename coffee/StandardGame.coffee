# TODO LEVEL UP
#   number of colors
#   number of naubs per spam
#   speed up
#
# @extends Game
define ["Game"], (Game) -> class StandardGame extends Game
  constructor: (canvas) ->
    super(canvas)

  ### state machine ###
  oninit: ->
    @inner_clock = 0 # to avoid resetting timer after pause
    @points = 0
    basket = 150
    @basket_size = basket
    Naubino.background.basket_size = basket
    @naub_replaced.add (number) => @graph.cycle_test(number)
    @naub_destroyed.add => @points++
    @cycle_found.add (list) => @destroy_naubs(list)

    # game parameters
    @spammer_interval = 300
    @number_of_colors = 2

    @spammers = {
      pair:
        method: => @create_naub_pair(null, null, @max_color(), @max_color() )
        probability: 5
      triple:
        method: @create_naub_triple
        probability: 0
    }

  max_color: -> Math.floor(Math.random() * (@number_of_colors))

  map_spammers: ->
    sum = 0
    for name, spammer of @spammers
      sum += spammer.probability
      {range:sum,  name, method:spammer.method}
      

  spam: ->
    probabilites = for name, spam of @spammers
      spam.probability
    max = probabilites.reduce (f,s) -> f+s
    min = 0
    dart = Math.floor(Math.random() * (max - min )) + min
    for spammer in @map_spammers()
      if dart < spammer.range
        console.log spammer.name
        spammer.method()
        return





  onchangestate: (e,f,t)-> #console.info "ruleset recived #{e}: #{f} -> #{t}"

  onbeforeplay: ->

  onplaying: ->
    super() #takes care of starting animation and physics
    Naubino.background.animation.play()
    Naubino.background.start_stepper()
    @spamming = setInterval @event, 300
    @checking = setInterval @check, 300

  onleaveplaying:->
    super() # takes care of halting physics
    clearInterval @spamming
    clearInterval @checking

  onpaused:      ->
    super() # takes care of halting animation
    Naubino.background.animation.pause()
    Naubino.background.stop_stepper()

  onbeforestop: (e,f,t) -> confirm "do you realy want to stop the game?"

  onstopped: (e,f,t) ->
    unless e is 'init'
      Naubino.background.animation.stop()
      Naubino.background.stop_stepper()
      @animation.stop()
      @stop_stepper()
      @clear()
      @clear_objects()
      @points = 0
    return true

  check: =>
    basket = @count_basket()
    if @capacity() < 75
      console.log @capacity()
      if Naubino.background.pulsating == off
        Naubino.background.start_pulse()
    else if Naubino.background.pulsating == on
      Naubino.background.stop_pulse()



  event: =>
    if @inner_clock == 0
      @spam()
    @inner_clock = (@inner_clock + 1) % 10


