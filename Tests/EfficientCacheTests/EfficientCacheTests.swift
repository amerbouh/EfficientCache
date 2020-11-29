import XCTest
@testable import EfficientCache

final class EfficientCacheTests: XCTestCase {
    
    var cache: EfficientCache<NSString>!
    var testKey: String!
    var testValue: NSString!
    
    override func setUpWithError() throws {
        let cachesDirectory = try FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        // Initialize the cache instance.
        cache = EfficientCache(name: "UnitTests", cacheDirectory: cachesDirectory)
        testKey = "testKey"
        testValue = "testValue"
    }

    override func tearDown() {
        super.tearDown()
        
        // Release the cache instance.
        cache = nil
        testKey = nil
        testValue = nil
    }
    
    func testGetItem() throws {
        try cache.add(testValue, forKey: testKey)
        let expectation = XCTestExpectation(description: "Return the item that was added")
        
        // Get the saved item from the cache.
        cache.getItem(forKey: testKey) { (item) in
            XCTAssertNotNil(item)
            
            // Fulfill the expectation.
            expectation.fulfill()
        }
        
        // Wait for the task is fulfilled.
        wait(for: [expectation], timeout: 5.0, enforceOrder: false)
    }
        
    func testAddItem() throws {
        let expectation = XCTestExpectation(description: "Add the item to the cache")
        
        // Save an item on the cache.
        cache.save(testValue, forKey: testKey, update: false) { [unowned self] (error) in
             XCTAssertNil(error)
            
            // Load the cached item.
            let cachedItem = self.cache.load(forKey: self.testKey)
            
            //  Verify whether or not the cached item is nil.
            XCTAssertNotNil(cachedItem)
            
            // Fulfill the expectation.
            expectation.fulfill()
        }
        
        // Wait for the task is fulfilled.
        wait(for: [expectation], timeout: 5.0, enforceOrder: false)
    }
        
    func testRemoveItem() throws {
        try cache.add(testValue, forKey: testKey)
        let expectation = XCTestExpectation(description: "Remove the item to the cache")
        
        // Remove the item.
        cache.removeItem(forKey: testKey) { [unowned self] (error) in
             XCTAssertNil(error)
            
            // Load the removed item.
            let cachedItem = self.cache.load(forKey: self.testKey)
            
            //  Verify whether or not the cached item is nil.
            XCTAssertNil(cachedItem)
            
            // Fulfill the expectation.
            expectation.fulfill()
        }
        
        // Wait for the task is fulfilled.
        wait(for: [expectation], timeout: 5.0, enforceOrder: false)
    }

    static var allTests = [
        ("testGetItem", testGetItem),
        ("testAddItem", testAddItem),
        ("testRemoveItem", testRemoveItem),
    ]
}
