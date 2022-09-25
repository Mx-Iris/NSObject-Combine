import XCTest
@testable import NSObject_Combine
import Combine

final class NSObjectCombineTests: XCTestCase {
    
    var subject: PassthroughSubject<Int, Never> = .init()
    class CancellableTest: HasCancellable {
        
        
        init() {
            [1].publisher.sink { _ in
                
            }
            .store(in: &combine.cancellables)
        }
        
    }
    func testExample() throws {
        let subscription = {
            self.subject
                .sink { num in
                    print(num)
                }
                .store(in: &self.combine.cancellables)
            print(self.combine.cancellables)
        }
        subscription()
        subscription()
        
        
        (0..<10).forEach { num in
            subject.send(num)
        }
    }
}
