

start = ->

  block = any heading, ul, ol, fence, p, bq
  start = many first all block, optional many blank
