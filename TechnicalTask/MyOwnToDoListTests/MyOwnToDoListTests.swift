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
    var bottomToolBar: UIToolbar!
    var searchBar: UISearchBar!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc.taskListTableView = UITableView()
        vc.taskListTableView.delegate = vc
        vc.taskListTableView.dataSource = vc
        vc.searchBar = UISearchBar()
        vc.searchBar.delegate = vc
        vc.loadViewIfNeeded()
        vc.viewDidLoad()
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
    
    func testAddNewTask() throws {
        let newTaskTitle = "New Task Title"
        let newTaskDescription = "This is a new task description"
        
        let createTaskVC = CreateTaskViewController()
        createTaskVC.createTaskTextView = UITextView()
        createTaskVC.delegate = vc
        createTaskVC.createTaskTextView.text = "\(newTaskTitle)\n\(newTaskDescription)"
        
        vc.todos = []
        
        createTaskVC.newTaskCreatedButton(UIButton())
        
        XCTAssertEqual(vc.todos.count, 1, "Task count should be 1")
        XCTAssertEqual(vc.todos.last?.todo, newTaskTitle, "The last task's title should match the new task's title")
        XCTAssertEqual(vc.todos.last?.description, newTaskDescription, "The last task's description should match the new task's description")
        XCTAssertEqual(vc.countLabel.text, "1 Задач", "Count label should display the correct number of tasks")
        
        let anotherTaskTitle = "Another Task Title"
        let anotherTaskDescription = "This is another task description"
        createTaskVC.createTaskTextView.text = "\(anotherTaskTitle)\n\(anotherTaskDescription)"
        createTaskVC.newTaskCreatedButton(UIButton())
        
        XCTAssertEqual(vc.todos.count, 2, "Task count should be 2")
        XCTAssertEqual(vc.todos.last?.todo, anotherTaskTitle, "The last task's title should match another task's title")
        XCTAssertEqual(vc.todos.last?.description, anotherTaskDescription, "The last task's description should match another task's description")
        XCTAssertEqual(vc.countLabel.text, "2 Задач", "Count label should display the correct number of tasks")
        XCTAssertEqual(vc.todos.last?.completed, false, "Completing status should match")
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
