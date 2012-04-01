define ['Naubino', 'WelcomeGame'], (Naubino, WelcomeGame) ->
  window.onload = ->
    naubino = new Naubino $('#Naubino'),
      initial: 'welcome'
      callbacks:
        onwelcome: (ev, from, to) ->
          @game = new WelcomeGame
