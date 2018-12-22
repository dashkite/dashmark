import assert from "assert"
import {print, test, success} from "amen"
import {parse, render, convert,
  styled, heading, fence, ul, ol, bq, p, start} from "../src/index"
import {log, json} from "../src/helpers"

do ->

  print await test "Dashmark", [

    # test "parse styles (em, strong, code)", ->
    #
    #   assert.deepEqual (styled "*hello world*"),
    #     rest: ''
    #     value: [ "strong", [[ "text", "hello world" ]]]
    #
    #   assert.deepEqual (styled "_hello world_"),
    #     rest: ''
    #     value: [ "em", [[ "text", "hello world" ]]]
    #
    #   assert.deepEqual (styled "`hello world`"),
    #     rest: ''
    #     value: [ "code", [[ "text", "hello world" ]]]
    #
    # test "parse headings (h1, h2, ...)", ->
    #
    #   assert.deepEqual (heading "# hello world"),
    #     rest: ''
    #     value: [ "h1", [[ "text", "hello world" ]]]
    #
    #   assert.deepEqual (heading "## hello world"),
    #     rest: ''
    #     value: [ "h2", [[ "text", "hello world" ]]]
    #
    # test "code fence", ->
    #
    #   input = """
    #     ```coffee
    #     foo = -> 'bar'
    #     ```
    #     """
    #
    #   assert.deepEqual (fence input),
    #     rest: ''
    #     value: [
    #       "pre"
    #       language: "coffee"
    #       [[
    #         "code"
    #         [[
    #           "text"
    #           "foo = -> 'bar'"
    #           ]]
    #         ]]
    #     ]
    #
    # test "lists (ul, ol)", [
    #
    #   test "ul", ->
    #
    #     input = """
    #       - This is the first item
    #       - This is the second item
    #       - This is the third item
    #       """
    #
    #     assert.deepEqual (ul input),
    #      rest: ""
    #      value: [
    #        "ul"
    #        [
    #          [
    #            "li"
    #            [[  "text", "This is the first item" ]]
    #          ]
    #          [
    #            "li"
    #            [[  "text", "This is the second item" ]]
    #          ]
    #          [
    #            "li"
    #            [[  "text", "This is the third item" ]]
    #          ]
    #        ]
    #      ]
    #
    #   test "ol", ->
    #
    #     input = """
    #       + This is the first item
    #       + This is the second item
    #       + This is the third item
    #       """
    #
    #     assert.deepEqual (ol input),
    #      rest: ""
    #      value: [
    #        "ol"
    #        [
    #          [
    #            "li"
    #            [[  "text", "This is the first item" ]]
    #          ]
    #          [
    #            "li"
    #            [[  "text", "This is the second item" ]]
    #          ]
    #          [
    #            "li"
    #            [[  "text", "This is the third item" ]]
    #          ]
    #        ]
    #      ]
    # ]
    #
    # test "paragraphs (p)", ->
    #
    #   assert.deepEqual (p "This is just a paragraph."),
    #     rest: ""
    #     value: [
    #       "p"
    #       [[ "line",
    #         [[ "text", "This is just a paragraph." ]]
    #       ]]
    #     ]
    #
    #   assert.deepEqual (p "This is just a paragraph.\n"),
    #     rest: ""
    #     value: [
    #       "p"
    #       [[ "line",
    #         [[ "text", "This is just a paragraph." ]]
    #       ]]
    #     ]

    test "blockquote", ->
      assert.equal "", (bq """
        >  This is the first line.
        >
        >This is the second line.
        > This is the third line.
        >
        >>This is the second line.
        >> This is the third line.
        >>
      """).rest

    # test "start rule", ->
    #
    #   assert.equal "", (start """
    #     # Hi There
    #
    #     This is *dashmark*, inspired by _markdown_.
    #
    #     ## Bulleted List
    #
    #     Features include:
    #
    #     - code fences, with language attribute
    #     - proper subset for quick/easy parsing
    #
    #     ## Code Fence
    #
    #     ```coffee
    #     foo = -> "hello world"
    #     ```
    #   """).rest


  ]

  process.exit if success then 0 else 1
