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
}
