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
