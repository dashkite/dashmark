import {string, forward} from "panda-grammar"

import $helpers from "../helpers"
import $text from "./text"

export default (context) ->

  {between, til, tag, memoize} = $helpers context
  {text, close} = $text context

  em: tag "em", between (string "_"),
    forward -> close (string "_"), text

  strong: tag "strong", between (string "*"),
    forward -> close (string "*"), text

  code: tag "code", between (string "`"),
    til string "`"
