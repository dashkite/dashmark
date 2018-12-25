  #
  # lists
  #

  # TODO for the moment, we just handle top-level lists

  ul = tag "ul", indent (re /^\- */), many tag "li", between bol, eol, text

  # TODO need a more sophisticated indent to handle 1. 2. 3.
  ol = tag "ol", indent (re /^\+ */), many tag "li", between bol, eol, text
