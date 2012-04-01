define ['StateMachine', 'Naubino'], (StateMachine, Naubino) ->
 "use strict"
 class WelcomeGame
  constructor: ->
    StateMachine.create
      target: this
      initial: 'playing'
      error: (a,b,c,d,e,f,err) -> throw err

  onplaying: (ev, from, to) =>
    naubino = new Naubino
    ctx = naubino.canvas.overlay.getContext '2d'
    ctx.fillText 'welcome', 40, 40
