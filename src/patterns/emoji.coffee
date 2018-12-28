import {string, any, rule} from "panda-grammar"

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

px = for code, emoji of emojis
  do (code, emoji) ->
    rule (string code), -> [ "text", emoji ]

emoji = any px...

export default emoji
