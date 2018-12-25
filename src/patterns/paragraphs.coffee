  #
  # paragraphs
  #

  # TODO for the moment, we don't handle blocks immediately following eol

  eop = any (all bol, eol), (all eol, negate bol)
  bop = all bol, negate string ">"
  p = tag "p", suffix eop, many tag "line", between bop, eol, text
