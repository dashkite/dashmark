import assert from "assert"
import {print, test, success} from "amen"


import $styles from "../src/patterns/styles"
import $text from "../src/patterns/text"

do ->

  print await test "Dashmark", [

    test "styles", do ->
      {em, strong, code} = $styles {}
      [
        test "em", ->
          assert.deepEqual (em "_emphasis_"),
            rest: "", value: [ "em", [[ "text", "emphasis" ]]]

        test "strong", ->
          assert.deepEqual (strong "*strong*"),
            rest: "", value: [ "strong", [[ "text", "strong" ]]]

        test "code", ->
          assert.deepEqual (code "`code`"),
            rest: "", value: [ "code", "code" ]
      ]


    test "text", do ->

      {text} = $text {}

      [

        test "nested styles", ->
          assert.deepEqual (text "_this is a *test*_"),
            rest: ""
            value: [[
              "em"
              [
                [ "text", "this is a " ]
                [ "strong", [[ "text", "test" ]] ]
              ]
            ]]

        test "mixed styles", ->
          assert.deepEqual (text "this is *styled* _text_"),
            rest: ""
            value: [
              [ "text", "this is "]
              [
                "strong"
                [[ "text", "styled" ]]
              ]
              [ "text", " " ]
              [
                "em"
                [[ "text", "text" ]]
              ]
            ]

        test "unmatched characters", ->
          assert.deepEqual (text "use an _ for emphasis"),
            rest: "", value: [[ "text", "use an _ for emphasis" ]]

        test "escaped characters", ->
          assert.deepEqual (text "one \\_ followed by another _"),
            rest: "", value: [[ "text", "one _ followed by another _" ]]
      ]


  ]

  process.exit if success then 0 else 1
