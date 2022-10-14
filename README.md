# AST Syntax Highlighting with Optics

Would it be possible, and feasible, to express syntax highlighting rules via _optics_?

## Current Achievment

Given an Abstract Syntax Tree stub of this form:

```swift
let ast = Root(block: .blockquote(.table(.code("Hello"))))
```

We can express getting to the inline `.code` inside a `.table` inside a `.blockquote` from the document root like so:

```swift
let deepReach = Root.blockLens
  >>> /BlockToken.blockquote
  >>> /BlockToken.table
  >>> /InlineToken.code

let value = deepReach.tryGet(ast) // → "Hello"
```

## References and Inspiration

- Yasuhiro Inami: "Make your own code formatter in Swift - iOS Conf SG 2019", 2019-01-20, <https://www.youtube.com/watch?v=_F9KcXSLc_s>
    - Inami's `Actomaton` introduced me to `CasePath`: <https://github.com/Actomaton/Actomaton>
- ["Lenses and prisms in Swift"](https://theswiftdev.com/lenses-and-prisms-in-swift/) comes with some great examples; the "box type" `AffineTraversal` wasn't part of that, though ;(
