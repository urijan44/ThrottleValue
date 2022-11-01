import XCTest
@testable import ThrottleValue

final class ThrottleValueTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    
    func test_ignore_value() {
        @ThrottleValue(0, interval: 1) var value: Int
        value = 1
        let exp1 = expectation(description: "1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            value = 2
            exp1.fulfill()
        }
        
        let exp2 = expectation(description: "2")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            value = 3
            exp2.fulfill()
        }
        
        let exp3 = expectation(description: "3")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            value = 4
            exp3.fulfill()
        }
        
        wait(for: [exp1, exp2, exp3], timeout: 1)
        XCTAssertEqual(value, 1)
    }
    
    func test_write_value() {
        @ThrottleValue(0, interval: 1) var value: Int
        value = 1
        let exp = expectation(description: "1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            value = 5
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2)
        XCTAssertEqual(value, 5)
    }
}
