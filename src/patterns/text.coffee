import $lines from "./lines"
import $styles from "./styles"

export default (context) ->

  {eol} = lines context
  {styles} = styles context

  styled = any em, strong, code

  # initially, we just want to parse any text
  context.closing ?= []

  close: (p, q) ->
    (s) ->
      closing.push p
      m = q s
      closing.pop()
      m

  closing: (s) -> any context.closing...

  text: memoize tag "text",
    many any (til forward -> any closing, styled, eol), styled
