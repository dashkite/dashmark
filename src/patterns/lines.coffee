import {string, any, all} from "panda-grammar"

#
# beginning/end of line parsing
#

export default (context) ->

  context.indent ?= []

  indent = (q, p) ->
    (s) ->
      context.lead.push q
      m = p s
      context.lead.pop()
      m

  bol = (s) ->
    indented = all context.indent...
    if (m = indented s)?
      {rest} = m
      {rest}

  eof = (s) -> if s == "" then rest: ""

  eol = any (string "\n"), eof

  blank = all bol, eol

  {bol, eol, eof, blank, indent}
