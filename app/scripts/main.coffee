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

doc_width = body.width()
doc_height = $(document).height()

random_start = 200
random_end = 1000

getRandomArbitrary = (min, max) =>
  Math.random() * (max - min) + min

dude = {
  startPos: [(body.width()/2 - 530/2),200],
  pos: [(body.width()/2 - 530/2),200],
  sprite: new Sprite('images/img_dudeloop.png', [0,0], [530,288],13,[0,1,2,3,4,5,6])
}

monitor = {
  pos: [ body.height() + 300, 0],
  sprite: new Sprite('images/monitor.png', [0,0], [157,196],1,[0]),
  last_onscreen: 0,
  onscreen: false,
  next_onscreen: getRandomArbitrary random_start, random_end
  speed: 5
}

controller = {
  pos: [ body.height() + 300, 0],
  sprite: new Sprite('images/controller.png', [0,0], [109,255],1,[0]),
  last_onscreen: 0,
  onscreen: false
  next_onscreen: getRandomArbitrary random_start, random_end
  speed: 1
}

clouds = []
tweets = []

main = () =>
  now = Date.now()
  dt = ( now - lastTime ) / 1000.0

  update(dt)
  render()

  lastTime = now
  frame = requestAnimFrame(main)
  frame

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
    'images/bg.jpg',
    'images/monitor.png',
    'images/controller.png'
  ])
  resources.onReady( init )

$(document).ready loadResources

reset = () =>
  #console.log "reset does nothing yet"

update = (dt) =>
  doTwitterSearch dt
  updateEntities dt
  updateDude dt
  updateMonitor dt
  updateController dt


updateEntities = (dt) =>
  updateDude dt

updateDude = (dt) =>
  angle += 3 * Math.PI / 180
  newX = dude.startPos[0] + ( radius * Math.cos angle )
  newY = dude.startPos[1] + ( radius * Math.sin angle )
  dude.pos = [ newX, newY ]
  dude.sprite.update dt

updateThing = (thing,dt) =>
  if thing.onscreen
    if ( thing.last_onscreen - now ) * -1 > 1
      thing.pos[1] -= thing.speed

      if thing.pos[1] + thing.sprite.size[1] < 0
        thing.last_onscreen = now        
        thing.onscreen = false
        thing.next_onscreen = getRandomArbitrary random_start, random_end
        thing.next_onscreen *= 1000

    thing.sprite.update dt

  else
    if ( thing.last_onscreen - now ) * -1 > thing.next_onscreen
      thing.onscreen = true
      thing.pos[1] = doc_height
      thing.pos[1] += thing.sprite.size[1] + 1

      minX = thing.sprite.size[0]
      maxX = doc_width - thing.sprite.size[0]
      newX = getRandomArbitrary minX, maxX

      thing.pos[0] = newX

updateController = (dt) =>
  updateThing controller, dt

updateMonitor = (dt) =>
  updateThing monitor, dt

render = () =>
  ctx.fillStyle = terrainPattern
  ctx.fillRect 0, 0, canvas.width, canvas.height

  renderEntity monitor
  renderEntity controller

  renderEntity dude

  renderEntities clouds
  renderEntities tweets

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
