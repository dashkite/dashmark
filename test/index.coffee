import assert from "assert"
import {print, test, success} from "amen"

import {parse} from "../src/index"

do ->

  print await test "Dashmark", [

    test "parse string", ->
      parse "hello"

  ]

  process.exit if success then 0 else 1
