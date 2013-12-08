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
now = 0

radius = 20
angle = 3 * Math.PI / 180

main = () =>
  now = Date.now()
  dt = ( now - lastTime ) / 1000.0

  update(dt)
  render()

  lastTime = now
  frame = requestAnimFrame(main)
  frame

doc_width = body.width()
doc_height = $(document).height()

init = () =>
  canvas.width = doc_width
  canvas.height = doc_height

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
  startPos: [(body.width()/2 - 530/2),200],
  pos: [(body.width()/2 - 530/2),200],
  sprite: new Sprite('images/img_dudeloop.png', [0,0], [530,288],16,[0,1,2,3,4,5,6])
}

monitor = {
  pos: [ doc_height + 300, 0],
  sprite: new Sprite('images/monitor.png', [0,0], [157,196],1,[0])
}

controller = {
  pos: [ doc_height + 300, 0],
  sprite: new Sprite('images/controller.png', [0,0], [109,255],1,[0])
}

clouds = []
tweets = []

reset = () =>
  #console.log "reset does nothing yet"

update = (dt) =>
  doTwitterSearch(dt)
  updateEntities(dt)

updateEntities = (dt) =>
  console.log "now: ", now

  angle += 3 * Math.PI / 180

  newX = dude.startPos[0] + ( radius * Math.cos angle )
  newY = dude.startPos[1] + ( radius * Math.sin angle )

  dude.pos = [ newX, newY ]

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
