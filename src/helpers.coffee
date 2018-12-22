import {rule, all} from "panda-grammar"

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

# debug = (p) -> rule p, (match) -> console.log {match}
#
# snowball = do (snowball = undefined) ->
#
#   snowball = (d) ->
#
#     ({value}) ->
#
#       do (
#
#         tag = undefined
#         _tag = undefined
#         tree = undefined
#         _tree = undefined
#         result = undefined
#
#         ) ->
#
#           for [ _tag, _tree ] in value
#             if _tag == tag
#               tree = [ tree..., d, _tree... ]
#             else
#               if tree?
#                 result.push [ tag, tree ]
#               else
#                 result = []
#               tag = _tag
#               tree = [ _tree... ]
#
#           result.push [ tag, tree ]
#           result
#
#   (d, p) -> rule p, snowball d

export {prefix, suffix, lk, thru, til, ignore, tag, negate, first,
  json, msg, log}
