struct Root: Equatable {
    var block: BlockToken
}

enum BlockToken: Equatable {
    indirect case blockquote(BlockToken)
    case table(InlineToken)
}

enum InlineToken: Equatable {
    case code(String)
    case text(String)
}


extension Root {
    static var blockLens: Lens<Root, BlockToken> {
        .init(get: \.block,
              set: {
            var result = $0
            result.block = $1
            return result
        })
    }
}
