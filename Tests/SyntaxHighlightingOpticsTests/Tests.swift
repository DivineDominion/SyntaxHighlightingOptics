import XCTest
@testable import SyntaxHighlightingOptics
import CasePaths

extension Prism {
    init(casePath: CasePath<Whole, Part>) {
        self.init(
          tryGet: casePath.extract(from:),
          inject: casePath.embed(_:))
    }
}

extension CasePath {
    static func >>> <Whole> (
      l: AffineTraversal<Whole, Root>,
      r: CasePath<Root, Value>
    ) -> AffineTraversal<Whole, Value> {
        return l >>> .init(prism: .init(casePath: r))
    }

    static func >>> <Whole> (
      l: Lens<Whole, Root>,
      r: CasePath<Root, Value>
    ) -> AffineTraversal<Whole, Value> {
        return .init(lens: l) >>> r
    }

    static func >>> <Whole> (
      l: Prism<Whole, Root>,
      r: CasePath<Root, Value>
    ) -> AffineTraversal<Whole, Value> {
        return .init(prism: l) >>> r
    }
}

final class SyntaxHighlightingOpticsTests: XCTestCase {
    let ast = Root(block: .blockquote(.table(.code("Hello"))))

    func testRootBlockLens() throws {
        let lens = Root.blockLens

        let part = lens.get(ast)
        switch part {
        case .blockquote(_): break // expected value
        default: XCTFail("Expected .blockquote, got \(part)")
        }

        let newBlock = BlockToken.table(.text("text"))
        XCTAssertEqual(lens.set(ast, newBlock), Root(block: newBlock))
    }

    func testBlockBlockPrism() {
        // Matches the associated value block *inside* the .blockquote(BlockToken) case.
        let blockquoteTokenCasePath = /BlockToken.blockquote
        let prism = Prism(casePath: blockquoteTokenCasePath)

        XCTAssertEqual(prism.tryGet(ast.block), .table(.code("Hello")))

        // Applying the "setter" to cases is admittedly a bit odd; its basically a wrapper for `BlockToken.blockquote(...)` here.
        let nestedQuote = BlockToken.blockquote(.table(.text("nested quote")))
        XCTAssertEqual(prism.inject(nestedQuote), .blockquote(nestedQuote))
    }

    func testRootBlockquoteTableInlineCode() {
        let deepReach = Root.blockLens
          >>> /BlockToken.blockquote
          >>> /BlockToken.table
          >>> /InlineToken.code

        XCTAssertEqual(deepReach.tryGet(ast), "Hello")
    }

    func testRulePicking() {
        // This is a rather hamfisted attempt at expressing a theme's highlighting rules. We always have to start at the root; that's not very useful. And from the `any` type we need to dispatch to a function with an existential.
        let rootRules: [any RootAffineTraversalType] = [
          // This will be skipped:
          Root.blockLens
            >>> /BlockToken.table
            >>> /InlineToken.text,

          // This should match:
          Root.blockLens
            >>> /BlockToken.blockquote
            >>> /BlockToken.table
            >>> /InlineToken.code,
        ]

        func toString(_ part: some RootAffineTraversalType) -> (Root) -> String? {
            return { part.tryGet($0) as? String }
        }

        XCTAssertEqual(
          rootRules.lazy
            .compactMap { toString($0)(self.ast) }
            .first,
          "Hello")
    }
}
