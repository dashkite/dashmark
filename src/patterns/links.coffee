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
