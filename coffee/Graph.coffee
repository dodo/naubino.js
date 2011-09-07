class Graph
  constructor: () ->
    @joins_count = 0
    @joins = {}

  add_join: (a,b) ->
    @joins_count++
    join = [ a.number, b.number ]
    @joins[@joins_count] = join
    @joins_count

  remove_join: (id)->
    delete @joins[id]


  joinList: ->
    console.log "joinList"
    console.log join for id, join of @joins