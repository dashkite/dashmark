import {re, word, ws, string, any, optional, forward,
  all, many, list, between,
  rule, tag as attr, merge, join,
  grammar} from "panda-grammar"

import {prefix, suffix, lk, thru, til,
  ignore, tag, negate, first, msg} from "./helpers"

#
# beginning/end of line parsing
#

# TODO need to be more flexible on whitespace for bol
escape = (s) -> s.replace /[.*+?^${}()|[\]\\]/g, "\\$&"

[ bol, indent ] = do (lead = []) ->

  [

    (s) ->
      p = do (r = "")->
        for q in lead
          r += (escape q) + "[ ]*"
        re ///^#{r}///
      if (m = p s)?
        {rest} = m
        {rest}

    (q, p) ->
      (s) ->
        lead.push q
        m = p s
        lead.pop()
        m

  ]

eof = (s) -> if s == "" then rest: ""

eol = any (string "\n"), eof

blank = all bol, eol

#
# text parsing
#

style = (name, delimiter) ->

  do (

    open = (s) ->
      if s[0] == delimiter && !_status
        _status = true
        value: undefined, rest: s[1..]

    close = (s) ->
      if s[0] == delimiter
        _status = false
        value: undefined, rest: s[1..]

    text = undefined

    status = false


  ) ->

    # TODO i think the forward -> styled part here is a bug
    #      ex: _some *text*_
    text = tag "text", til any eol, (lk close), forward -> styled
    tag name, rule (between open, close, text), ({value}) -> [ value ]

em = style "em", "_"
strong = style "strong", "*"
code = style "code", "`"

link = rule (all (between (string "["), (string "]"), (til lk string "]")),
  between (string "("), (string ")"), re /^[^)]+/), ({value}) ->
    [ _text, url ] = value
    [ "a", { href: url }, (text _text).value ]

styled = any em, strong, code, link

unstyled = tag "text", til any styled, eol

text = many any unstyled, styled

#
# headings
#

h = (n) -> suffix eol,
  tag "h#{n}", prefix (all bol, re ///^\#{#{n}}\s+///), text
heading = any ((h i) for i in [1..5])...

#
# code fences
#

fence = do (

  marker = string "```"

  open = undefined

  close = undefined

  value = undefined
  attributes = undefined
  code = undefined

) ->

  open =  between marker, eol, (attr "language", optional re /^\w+/)

  close = all eol, bol, marker, eol

  rule (all open, tag "text", thru close), ({value}) ->
    [ attributes, code ] = value
    [ "pre", attributes, [[ "code", [ code ]]]]


#
# lists
#

# TODO for the moment, we just handle top-level lists

ul = tag "ul", indent "- ", many tag "li", between bol, eol, text

# TODO need a more sophisticated indent to handle 1. 2. 3.
ol = tag "ol", indent "+ ", many tag "li", between bol, eol, text

#
# blockquote
#

bq = tag "blockquote", indent ">", forward -> start

#
# paragraphs
#

# TODO for the moment, we don't handle blocks immediately following eol

eop = any (all bol, eol), (all eol, negate bol)
bop = all bol, negate string ">"
p = tag "p", suffix eop, many tag "line", between bop, eol, text

block = any heading, ul, ol, fence, p, bq

start = many first all block, optional many blank

parse = grammar start

export {styled, heading, fence, ul, ol, bq, p, start, parse}
