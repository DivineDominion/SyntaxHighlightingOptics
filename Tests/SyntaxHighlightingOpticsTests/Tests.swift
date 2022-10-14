import XCTest
@testable import SyntaxHighlightingOptics
import CasePaths

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
}
