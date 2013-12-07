requestAnimFrame = ( () ->
  window.requestAnimationFrame or
    window.webkitRequestAnimationFrame or
    window.mozRequestAnimationFrame or
    window.oRequestAnimationFrame or
    window.msRequestAnimationFrame or
    (callback) ->
      window.setTimeout callback, 1000/60
  )()

canvas = document.createElement "canvas"
ctx = canvas.getContext "2d"

body = $("body")
document.getElementById('container').appendChild canvas

terrainPattern = 0

lastTime = 0

main = () =>
  now = Date.now()
  dt = ( now - lastTime ) / 1000.0

  update(dt)
  render()

  lastTime = now
  frame = requestAnimFrame(main)
  frame

init = () =>

  canvas.width = body.width() - 30
  canvas.height = $(document).height() - 50


  pattern = resources.get 'images/bg.jpg'
  terrainPattern = ctx.createPattern pattern, 'repeat'

  reset()
  lastTime = Date.now()
  main()


loadResources = () ->
  resources.load([
    'images/img_dudeloop.png',
    'images/bg.jpg'
  ])
  resources.onReady( init )

$(document).ready loadResources

dude = {
  pos: [(body.width()/2 - 530/2),100],
  sprite: new Sprite('images/img_dudeloop.png', [0,0], [530,288],16,[0,1,2,3,4,5,6])
}
clouds = []
tweets = []

reset = () =>
  #console.log "reset does nothing yet"

update = (dt) =>
  doTwitterSearch(dt)
  updateEntities(dt)

updateEntities = (dt) =>
  dude.sprite.update dt

render = () =>
  ctx.fillStyle = terrainPattern
  ctx.fillRect 0, 0, canvas.width, canvas.height

  renderEntity(dude)
  renderEntities(clouds)
  renderEntities(tweets)

renderEntities = (list) =>
  renderEntity ent for ent in list

renderEntity = (entity) =>
  ctx.save()
  ctx.translate( entity.pos[0], entity.pos[1] )
  entity.sprite.render(ctx)
  ctx.restore()

doTwitterSearch = (dt) =>
  #console.log "not searching twitter yet"

# scrollDude = () ->
#   prevTop = 0
#   bgPos = 0
#   console.log "scroll dude!"
#   setTimeout scrollDude, 1000
# scrollDude()
