import {string, any, all} from "panda-grammar"

#
# beginning/end of line parsing
#

export default (context) ->

  context.indent = []

  bol = (s) ->
    p = all context.lead...
    if (m = p s)?
      {rest} = m
      {rest}

  eof = (s) -> if s == "" then rest: ""

  eol = any (string "\n"), eof

  blank = all bol, eol

  indent = (q, p) ->
    (s) ->
      context.lead.push q
      m = p s
      context.lead.pop()
      m

  {bol, eol, eof, blank, indent}
