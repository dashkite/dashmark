once = (f) ->
  do (k=undefined) ->
    -> if k? then k else (k = f())

last = (ax) -> ax[-1..][0]

export {once, last}
