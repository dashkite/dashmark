import {string, any, forward} from "panda-grammar"
import {between, til, tag} from "./grammar"

import $text from "./text"

export default (context) ->

  {text, close} = $text context

  em = tag "em", between (string "_"),
    forward -> close (string "_"), text

  strong = tag "strong", between (string "*"),
    forward -> close (string "*"), text

  code = tag "code", between (string "`"),
    til string "`"

  styled = any em, strong, code

  {em, strong, code, styled}
