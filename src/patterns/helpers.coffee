import {rule, all, any} from "panda-grammar"

prefix = (before, p) ->
  rule (all before, p), ({value}) -> value[1]

suffix = (after, p) ->
  rule (all p, after), ({value}) -> value[0]

lk = (p) ->
  (s) ->
    if (p s)?
      value: undefined, rest: s

thru = (stop) ->
  (s) ->
    rest = s
    value = ""
    while rest.length > 0
      if (m = stop rest)?
        {rest} = m
        break
      else
        value += rest[0]
        rest = rest[1..]
    if value.length > 0
      {value, rest}

til = (p) -> thru lk p

negate = (p) ->
  (s) ->
    if !(p s)?
      rest: s

none = (px...) ->
  q = any px...
  (s) -> rest: s if !(m = q s)?


ignore = (p) -> rule p, -> undefined

tag = (name, p) -> rule p, ({value}) -> [ name, value ]

first = (p) -> rule p, ({value}) -> value[0]

json = (x) -> JSON.stringify x, null, 2

msg = (tag, p) ->
  (s) ->
    console.warn "#{tag} - parsing '#{s[0..5]}...'"
    m = p s
    console.warn "#{tag} - produced", json m
    m

log = (x) -> console.warn json x

memoize = (p) ->
  cache = {}
  (s) -> cache[s] ?= p s

between = (args...) ->
  switch args.length
    when 2
      open = close = args[0]
      p = args[1]
    when 3
      [ open, close, p ] = args

  rule (all open, p, close), ({value: [,v]}) -> v

export {prefix, suffix, lk, thru, til, ignore, tag, none, negate, first,
  json, msg, log, memoize, between}
