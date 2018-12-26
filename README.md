# DashMark

DashMark is D ashKite's Markdown-inspired markup format. It's simpler than Markdown, but we may add features in the future.

DashMark currently supports:

- Bold and italics.
- Fenced and inline code (monospaced type).
- Hypertext: plain and wiki-style.
- Common emoji.
- “Smart” typography.

In comparison to Markdown, DashMark does _not_ support:

- Headings.
- Lists.
- Blockquotes.
- Image links.
- Indented code-blocks.
- Link references.
- Tables.
- Raw HTML.

DashMark also differs from Markdown in other small ways. Some of these are purely syntactical (a single asterisk denotes bold text, for example) and some are semantic (due mostly to Markdown's regular-expression-based origins). Both share a similar objective: to make it easy to introduce rich formatting with plain text.

## Example

```
This is *DashMark*, _inspired_ by Markdown, but _simpler_.

You can write `monospaced text` inline or via "fenced" blocks:

​```
To be or not to be
That is the question
​```

You can drop a URL anywhere and it will be converted into a link:

https://dashkite.com/home/dan

Or you can use [wiki-style links](https://dashkite.com/join).

Emojis are supported via emoticons. :) And quotes are “replaced” by smart quotes, dashes by -- em-dashes -- and so on.
```
