
getRandomInt = (min, max) ->
  return Math.floor(Math.random() * (max - min)) + min

queueTag = (tagName) ->
  variantSize = window.audios[tagName].length
  random = getRandomInt(0, variantSize)
  variant = "#{tagName}#{random}"
  console.log("Push #{variant}")
  window.audioQueue.push variant

playNext = ->
  if window.audioQueue.length != 0
    playTag(window.audioQueue.shift())

playTag = (variant) ->
  console.log("Play variant #{variant}")
  audioElement = window.hashAudios[variant]
  audioElement.play()

getTag = (element) ->
  element.get(0).tagName.toLowerCase()

traverse = (element) ->
  tagName = getTag(element)
  if tagName of window.audios
    console.log(tagName)
    queueTag(tagName)
  element.children().each (idx, child) ->
    traverse($(child))

traverseDocument = ->
  $('#requested-page').load 'google.html', null, ->
    $('#requested-page').each (index) ->
      traverse($(this))
    playNext()

jQuery ->
  window.audios = {
    'a': [
      'a0',
      'a1',
      'a2',
      'a3',
      'a4',
      'a5',
    ],
    'br': [
      'br0',
    ],
    'div': [
      'div0',
      'div1',
      'div2',
    ],
    'li': [
      'li0',
      'li1',
    ],
    'p': [
      'p0',
    ],
    'table': [
      'table0',
    ],
    'td': [
      'td0'
    ],
    'tr': [
      'tr0',
    ],
    'ul': [
      'ul0',
      'ul1',
    ],
  }

  window.hashAudios = {}
  window.audioQueue = []

  for tag, variants of audios
    for variant in variants
      audio = new Audio()
      audio.src = "audio/#{variant}.opus"

      audio.addEventListener 'ended', ->
        playNext()
      audio.load()
      hashAudios[variant] = audio

  traverseDocument()
