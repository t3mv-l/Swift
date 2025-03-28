//
//  MyOwnToDoListTests.swift
//  MyOwnToDoListTests
//
//  Created by Артём on 28.03.2025.
//

import Foundation
import XCTest
@testable import MyOwnToDoList

final class MyOwnToDoListTests: XCTestCase {
    var vc: ViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        vc = ViewController()
        vc.taskListTableView = UITableView()
        vc.countLabel = UILabel()
    }

    override func tearDownWithError() throws {
        vc = nil
        try super.tearDownWithError()
    }

    func testFetchTodos() throws {
        let expectation = XCTestExpectation(description: "Fetch todos from API")
        let url = URL(string: "https://dummyjson.com/todos")!
        let mockData = try! JSONEncoder().encode(TodoResponse(todos: [Todo(id: 1, todo: "Test todo", description: "This is a test", date: "2023-10-01", completed: false)]))
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        URLSession.setMockData(mockData: mockData, forUrl: url)
        vc.session = session
        vc.fetchTodos()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.vc.todos.isEmpty, "Todos should not be empty")
            XCTAssertEqual(self.vc.todos.count, 30, "There should be thirty Todo")
            XCTAssertEqual(self.vc.todos[0].todo, "Do something nice for someone you care about", "The todo text should match")
            XCTAssertEqual(self.vc.todos[0].completed, false, "Completing status should match")
            XCTAssertEqual(self.vc.todos[14].todo, "Buy a new house decoration", "The todo text should match")
            XCTAssertEqual(self.vc.todos[14].description, nil, "Description should match")
            XCTAssertEqual(self.vc.todos[29].todo, "Go to the gym", "The todo text should match")
            XCTAssertEqual(self.vc.todos[29].completed, true, "Completing status should match")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testPerformanceExample() throws {
        let url = URL(string: "https://dummyjson.com/todos")!
        let expectation = XCTestExpectation(description: "Fetch todos from API")
                    
        measure {
            let data = try? Data(contentsOf: url)
            if data != nil {
                expectation.fulfill()
            }
        }
                    
        wait(for: [expectation], timeout: 5)
    }
}

extension URLSession {
    private struct Mock {
        static var data: Data?
        static var error: Error?
    }
            
    public static func setMockData(mockData: Data, forUrl url: URL) {
        Mock.data = mockData
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
    }
            
    public class MockURLProtocol: URLProtocol {
        public override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
                
        override class public func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
                
        override public func startLoading() {
            if let data = Mock.data {
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
            if let error = Mock.error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
        }

        override public func stopLoading() {}
    }
}
