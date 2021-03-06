import {re, word, ws, string, any, optional, forward,
  all, many, list, between,
  rule, tag as attr, merge, join,
  grammar} from "panda-grammar"

import {prefix, suffix, lk, thru, til,
  ignore, tag, none, negate, first, msg} from "./helpers"

parser = ->

  memoize = (p) ->
    cache = {}
    (s) -> cache[s] ?= p s

  #
  # beginning/end of line parsing
  #

  [ bol, indent ] = do (lead = []) ->

    [

      (s) ->
        p = all lead...
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

      openStyle = (s) ->
        if s[0] == delimiter && !status
          status = true
          value: undefined, rest: s[1..]

      closeStyle = (s) ->
        if s[0] == delimiter
          status = false
          value: undefined, rest: s[1..]

      status = false

    ) ->

      tag name, rule (between openStyle, closeStyle,
        (forward -> close closeStyle, text)), ({value}) -> value

  em = style "em", "_"
  strong = style "strong", "*"
  code = style "code", "`"

  url = do (

    url = undefined
    scheme = re /^(https?|mailto|ftp|sftp|ssh)/
    domain = re /^[A-Za-z0-9\~\-]+/
    host = undefined
    tld = re /^(com|org|edu|gov)/
    path = undefined
    component = re /^\w+/
    query = undefined
    assignment = undefined
    name = re /^\w+/
    value = re /^\w+/
    fragment = all (string "#"), re /^w+/

    ) ->

      host = list (string "."), domain
      path = all (string "/"),
        (optional (list (string "/"), component)),
        optional string "/"
      assignment = all name, (string "="), optional value
      query = all (string "?"),
        (list (string "&"), assignment),
        optional string "&"

      url = all scheme, (string "://"), host, path,
        (optional query), (optional fragment)

      do (
        m = undefined
        value = undefined
        rest = undefined
        length = undefined
      ) ->

        (s) ->
          if (m = url s)?
            {rest} = m
            length = s.length - rest.length
            aURL = s[0...(length)]
            value = [ [[ "text", aURL ]], aURL ]
            {value, rest}


  [ link, links ] = do (

      linkText = undefined
      delimitedLinkText = undefined
      linkTextOpen = string "["
      linkTextClose = string "]"
      delimitedURL = undefined
      urlOpen = string "("
      urlClose = string ")"
      catalog = []
      value = undefined

    ) ->

      linkText = forward -> close linkTextClose, text
      delimitedLinkText = between linkTextOpen, linkTextClose, linkText

      delimitedURL = between urlOpen, urlClose, til urlClose

      [
        memoize rule (any url, (all delimitedLinkText, delimitedURL)), ({value}) ->
          catalog.push value[1]
          [
            "a"                   # tag name
            href: value[1]        # attributes
            value[0]              # subtree
          ]

        (s) ->
          _parse s
          catalog

      ]

  emoji = do (

      emojis = undefined

      rules = undefined

      emoji = undefined
      code = undefined

    ) ->

      emojis =
        ":)": "🙂"
        ":D": "😃"
        ";)": "😉"
        ":(": "☹️"
        ":p": "😛"
        ":'(": "😢"             # tears
        ":'D": "😅"             # relief
        ":/": "😕"
        ":o": "😯"
        "<3": "❤️"
        "</3": "💔"              # broken heart
        ":+1:": "👍"
        ":-1:": "👎"             # thumbs down
        ":100:": "💯"
        ":sparkle:": "✨"
        ":rocket:": "🚀"
        ":wow:": "✨🚀"
        ":adele:": "💜"

      rules = for code, emoji of emojis
        do (code, emoji) ->
          rule (string code), -> [ "text", emoji ]

      any rules...

  styled = any em, strong, code, link, emoji

  [ text, close ] = do (

      # initially, we just want to parse any text
      stop = []
      unstyled = undefined

    ) ->

      unstyled = memoize tag "text", til forward -> any stop..., styled, eol

      [

        many any unstyled, styled

        (p, q) ->
          (s) ->
            stop.push p
            m = q s
            stop.pop()
            m

      ]

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

  ul = tag "ul", indent (re /^\- */), many tag "li", between bol, eol, text

  # TODO need a more sophisticated indent to handle 1. 2. 3.
  ol = tag "ol", indent (re /^\+ */), many tag "li", between bol, eol, text

  #
  # blockquote
  #

  bq = tag "blockquote", indent (re /^\> */), forward -> start

  #
  # paragraphs
  #

  # TODO for the moment, we don't handle blocks immediately following eol

  eop = any (all bol, eol), (all eol, negate bol)
  bop = all bol, negate string ">"
  p = tag "p", suffix eop, many tag "line", between bop, eol, text

  block = any heading, ul, ol, fence, p, bq

  start = many first all block, optional many blank

  _parse = grammar start

  {styled, url, link, heading, fence, ul, ol, bq, p, parse: _parse, links}

parse = (s) ->
  p = parser()
  p.parse s

export {parser, parse}
