//
//  EfficientCache.swift
//  EfficientCache
//
//  Created by Anas Merbouh on 2020-09-09.
//  Copyright © 2020 Anas Merbouh. All rights reserved.
//

import Foundation

public class EfficientCache<X: Cacheable> {
    public typealias T = X
    
    // MARK: - Properties
    
    private let name: String
    private let cacheDirectory: URL
    
    private let cache: NSCache<NSString, CacheItem>
    private let operationsQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    // MARK: - Initialization
    
    /// Initializes and returns an EfficientCache instance with the given cache
    /// name and cache directory.
    ///
    /// - parameter name: A String representing the name of cache.
    /// - parameter cacheDirectory: An URL representing the location of the directory
    ///                             where objects are persisted.
    public init(name: String, cacheDirectory: URL) {
        self.name = name
        self.cache = NSCache()
        self.cacheDirectory = cacheDirectory
    
        // Configure the cache.
        cache.name = name
    }
    
    /// Initializes an EfficientCache instance with the given cache name.
    ///
    /// - parameter name: A String representing the name of cache.
    public convenience init(name: String) throws {
        let cacheDirectory = try FileManager().url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        // Call the class's designated initializer.
        self.init(name: name, cacheDirectory: cacheDirectory)
    }
    
    // MARK: - Methods
    
    internal func getAllKeys() throws -> [String] {
        let urls = try FileManager().contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: [])
        return urls.compactMap { $0.deletingPathExtension().lastPathComponent }
    }
    
    internal func removeItemFromDisk(key: String) throws {
        let itemLocation = generatePath(forKey: key)
        
        // Remove the item using the File Manager.
        try FileManager().removeItem(at: itemLocation)
    }
    
    internal func load(forKey key: String) -> CacheItem? {
        if let cachedItem = cache.object(forKey: key as NSString) {
            return cachedItem
        }
        
        // Obtain the path of the item.
        let itemPath = generatePath(forKey: key)
        
        // Create a Data instance from the contents of the file at the given path.
        guard let archivedItem = try? Data(contentsOf: itemPath) else { return nil }
        
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: CacheItem.self, from: archivedItem)
    }
    
    internal func add(_ item: X, forKey key: String) throws {
        let cacheItem = CacheItem(value: item, expirationDate: .distantFuture)
        
        // Add the cache item to the cache.
        cache.setObject(cacheItem, forKey: key as NSString)
        
        // Add item to the device local storage.
        let archive = try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: true)
        let writeLocation = generatePath(forKey: key)
        
        // Write the archive to the given path.
        try archive.write(to: writeLocation)
    }
    
    private func generatePath(forKey key: String) -> URL {
        return cacheDirectory
            .appendingPathComponent(key)
            .appendingPathExtension("cache")
    }
    
}

// MARK: - Cache Saving
extension EfficientCache: CacheSaving {
        
    public func save(_ item: X, forKey key: String, update: Bool, completionHandler: @escaping ((Error?) -> Void)) {
        operationsQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Check if the item already exists on the cache / device's local storage
            // and act according to whether or not the user wants to update it.
            if self.load(forKey: key) != nil, update == false {
                completionHandler(nil)
                return
            }
            
            // Attempt to add the item to the cache / device's local storage.
            do {
                try self.add(item, forKey: key)
               
                // Call the completion handler.
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }
    }

}

// MARK: - Cache Fetching
extension EfficientCache: CacheFetching {
    
    public func getItem(forKey key: String, completionHandler: ((X?) -> Void)?) {
        operationsQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Fetch the item from the cache.
            let item = self.load(forKey: key)?.value as? X
            
            // Call the completion handler.
            completionHandler?(item)
        }
    }
    
}

// MARK: - Cache Removing
extension EfficientCache: CacheRemoving {

    public func removeAll(completionHandler: ((Error?) -> Void)?) {
        cache.removeAllObjects()
        
        // Remove the cache directory.
        operationsQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Attempt to retrieve the keys of the items in the cache.
            do {
                let keys = try self.getAllKeys()
                
                // Remove the associated item of each key.
                keys.forEach {
                    do {
                        try self.removeItemFromDisk(key: $0)
                    } catch {
                        completionHandler?(nil)
                    }
                }
            } catch {
                completionHandler?(nil)
            }
        }
    }
    
    public func removeItem(forKey key: String, completionHandler: ((Error?) -> Void)?) {
        cache.removeObject(forKey: key as NSString)
        
        // Remove the item from the device's local storage.
        operationsQueue.async { [weak self] in
            guard let self = self else { return }
            
            // Attempt to remove the item.
            do {
                try self.removeItemFromDisk(key: key)
                
                // Call the completion handler.
                completionHandler?(nil)
            } catch {
                completionHandler?(error)
            }
            
        }
    }
    
}
