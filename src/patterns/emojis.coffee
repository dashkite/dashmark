emoji = do (

    emojis = undefined

    rules = undefined

    emoji = undefined
    code = undefined

  ) ->

    emojis =
      ":)": "🙂"
      ":D": "😃"
      ";)": "😉"
      ":(": "☹️"
      ":p": "😛"
      ":'(": "😢"             # tears
      ":'D": "😅"             # relief
      ":/": "😕"
      ":o": "😯"
      "<3": "❤️"
      "</3": "💔"              # broken heart
      ":+1:": "👍"
      ":-1:": "👎"             # thumbs down
      ":100:": "💯"
      ":sparkle:": "✨"
      ":rocket:": "🚀"
      ":wow:": "✨🚀"
      ":adele:": "💜"

    rules = for code, emoji of emojis
      do (code, emoji) ->
        rule (string code), -> [ "text", emoji ]

    any rules...
