renderAttributes = (attributes) ->
  do ->
    for key, value of attributes
      "#{key}='#{value}'"
  .join " "

modes =
  text: (_, s) -> s
  line: (_, tree) -> "#{render tree}<br/>"

mode = (tag) ->
  modes[tag] = (attributes, tree) ->
    attributes = renderAttributes attributes
    if attributes == ""
      "<#{tag}>#{render tree}</#{tag}>"
    else
      "<#{tag} #{attributes}>#{render tree}</#{tag}>"

tags = "h1 h2 h3 h4 h5 p ul li blockquote pre code p em strong"
mode tag for tag in (tags.split " ")

render = (tree) ->
  do ->
    for node in tree
      switch node.length
        when 2
          [ tag, subtree ] = node
          attributes = {}
        when 3
          [ tag, attributes, subtree ] = node
        else
          throw "render: bad node: #{node}"

      modes[tag] attributes, subtree
  .join ""

export {render}
