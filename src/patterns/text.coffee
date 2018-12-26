import {any, many, forward} from "panda-grammar"
import {til, tag} from "./grammar"
import {once} from "./helpers"

import $lines from "./lines"
import $styles from "./styles"

escape = (c, p) ->
  do (skip = false) ->
    (s) ->
      console.warn {skip, s}
      if skip
        skip = false
        undefined
      else
        if s[0] != c
          p s
        else
          skip = true
          undefined

export default (context) ->

  # initially, we just want to parse any text
  context.closing ?= []

  {eol} = $lines context

  close = (p, q) ->
    (s) ->
      context.closing.push p
      m = q s
      context.closing.pop()
      m

  closing = (s) -> ((any context.closing...) s)

  # defer initialization to avoid circular dependency with styles
  # once combinator ensures we don't execute this twice for a given context
  initialize = once ->
    {styled} = $styles context
    normal = til any closing, styled, eol
    {normal, styled}

  text = forward ->
    {normal, styled} = initialize()
    many any (tag "text", normal), styled

  {text, close, closing}
