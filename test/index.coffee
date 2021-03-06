import assert from "assert"
import {print, test, success} from "amen"
import {parser, parse, render, convert} from "../src/index"
import {log, json} from "../src/helpers"

do ->

  print await test "Dashmark", [

    test "parse styles (em, strong, code)", ->

      {styled} = parser()
      assert.deepEqual (styled "*hello world*"),
        rest: ''
        value: [ "strong", [[ "text", "hello world" ]]]

      assert.deepEqual (styled "_hello world_"),
        rest: ''
        value: [ "em", [[ "text", "hello world" ]]]

      assert.deepEqual (styled "`hello world`"),
        rest: ''
        value: [ "code", [[ "text", "hello world" ]]]

    test "parse headings (h1, h2, ...)", ->

      {heading} = parser()
      assert.deepEqual (heading "# hello world"),
        rest: ''
        value: [ "h1", [[ "text", "hello world" ]]]

      assert.deepEqual (heading "## hello world"),
        rest: ''
        value: [ "h2", [[ "text", "hello world" ]]]


    test "url", ->

      {url} = parser()
      assert.deepEqual (url "http://dashkite.com/home/dan"),
        value: [
            [[ "text", "http://dashkite.com/home/dan" ]]
            "http://dashkite.com/home/dan"
          ]
        rest: ""

    test "links", ->

      {link} = parser()
      assert.deepEqual (link "[this is a link](#anything)"),
        value: [
            "a"
            href: "#anything"
            [[ "text", "this is a link" ]]
          ]
        rest: ""

    test "code fence", ->

      input = """
        ```coffee
        foo = -> 'bar'
        ```
        """
      {fence} = parser()
      assert.deepEqual (fence input),
        rest: ''
        value: [
          "pre"
          language: "coffee"
          [[
            "code"
            [[
              "text"
              "foo = -> 'bar'"
              ]]
            ]]
        ]

    test "lists (ul, ol)", [

      test "ul", ->

        input = """
          - This is the first item
          - This is the second item
          - This is the third item
          """

        {ul} = parser()
        assert.deepEqual (ul input),
         rest: ""
         value: [
           "ul"
           [
             [
               "li"
               [[  "text", "This is the first item" ]]
             ]
             [
               "li"
               [[  "text", "This is the second item" ]]
             ]
             [
               "li"
               [[  "text", "This is the third item" ]]
             ]
           ]
         ]

      test "ol", ->

        input = """
          + This is the first item
          + This is the second item
          + This is the third item
          """

        {ol} = parser()
        assert.deepEqual (ol input),
         rest: ""
         value: [
           "ol"
           [
             [
               "li"
               [[  "text", "This is the first item" ]]
             ]
             [
               "li"
               [[  "text", "This is the second item" ]]
             ]
             [
               "li"
               [[  "text", "This is the third item" ]]
             ]
           ]
         ]
    ]

    test "paragraphs (p)", ->

      {p} = parser()
      assert.deepEqual (p "This is just a paragraph."),
        rest: ""
        value: [
          "p"
          [[ "line",
            [[ "text", "This is just a paragraph." ]]
          ]]
        ]

      {p} = parser()
      assert.deepEqual (p "This is just a paragraph.\n"),
        rest: ""
        value: [
          "p"
          [[ "line",
            [[ "text", "This is just a paragraph." ]]
          ]]
        ]

    test "blockquote", ->

      {bq} = parser()
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

    test "convert", ->
      expected = "<h1>Hi There</h1><p>This is <strong>dashmark</strong>, inspired by <em>markdown</em>. 🙂<h2>Links</h2><p>This is <a href='https://dashkite.com'>a <em>link</em></a>.<p>You can also have them as literals:<p><a href='https://dashkite.com/home/dan'>https://dashkite.com/home/dan</a><h2>Bulleted List</h2><p>Features include:<ul><li>code fences, with <code>language</code> attribute</li><li>proper subset for quick/easy parsing</li></ul><h2>Code Fence</h2><pre language='coffee'><code>foo = -> \"hello world\"</code></pre><h2>Blockquote</h2><blockquote><p>This is quoted text.<br/></p>With line-breaks.</blockquote>"

      document = """
        # Hi There

        This is *dashmark*, inspired by _markdown_. :)

        ## Links

        This is [a _link_](https://dashkite.com).

        You can also have them as literals:

        https://dashkite.com/home/dan

        ## Bulleted List

        Features include:

        - code fences, with `language` attribute
        - proper subset for quick/easy parsing

        ## Code Fence

        ```coffee
        foo = -> "hello world"
        ```

        ## Blockquote

        > This is quoted text.
        > With line-breaks.
      """

      assert.equal expected, convert document

      {links} = parser()
      assert.deepEqual (links document), [
        "https://dashkite.com"
        "https://dashkite.com/home/dan"
      ]

  ]

  process.exit if success then 0 else 1
