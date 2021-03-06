define ->
#upper case function to avoid overwriting defaults
cp.Vect::Copy   = -> new cp.Vect @.x, @.y
cp.Vect::Length = -> Math.sqrt(@.x * @.x + @.y * @.y)
cp.Vect::Angle  = -> cp.v.toangle(this)
cp.Vect::IsZero = -> @x == @y == 0
cp.Vect::AddPolar = (dir, len) ->
    @x += Math.cos(dir) * len
    @y += Math.sin(dir) * len

cp.Constraint::IsRogue= ->
  (@a.isRogue() and not @a.isStatic()) or
  (@b.isRogue() and not @b.isStatic())

window.Util =
  shuffle: (a) ->
    b = a.slice()
    for x, i in b
      j = Math.floor Math.random() * b.length
      [b[i], b[j]] = [b[j], b[i]]
    b


  extend: (obj, mixin) ->
    for name, method of mixin
      console.log name
      obj[name] = method

  include: (klass, mixin) ->
    @extend klass.prototype, mixin
