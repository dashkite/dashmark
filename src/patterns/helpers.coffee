once = (f) ->
  do (k=undefined) ->
    -> if k? then k else (k = f())

export {once}
