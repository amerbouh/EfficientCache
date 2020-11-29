//
//  CacheItem.swift
//  EfficientCache
//
//  Created by Anas Merbouh on 2020-09-09.
//  Copyright © 2020 Anas Merbouh. All rights reserved.
//

import Foundation

internal class CacheItem: NSObject, NSCoding, NSSecureCoding {
    
    public static var supportsSecureCoding: Bool = true
    
    // MARK: - Types
    
    private enum CodingKey: String {
        case value
        case expirationDate
    }
    
    // MARK: - Properties
    
    /// The object that is being cached.
    public let value: Any
    
    /// A Date representing the date at which the cached object is no longer
    /// valid.
    public let expirationDate: Date
    
    // MARK: - Initialization
    
    public init(value: Any, expirationDate: Date) {
        self.value = value
        self.expirationDate = expirationDate
    }
    
    required public init?(coder: NSCoder) {
        guard let value = coder.decodeObject(forKey: CacheItem.CodingKey.value.rawValue),
              let expirationDate = coder.decodeObject(of: NSDate.self, forKey: CacheItem.CodingKey.expirationDate.rawValue) else { return nil }
        
        // Initialize the object's properties
        self.value = value as AnyObject
        self.expirationDate = expirationDate as Date
    }
    
    // MARK: - Methods
    
    public func isExpired() -> Bool {
        return expirationDate.timeIntervalSinceNow < 0
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(value, forKey: CacheItem.CodingKey.value.rawValue)
        coder.encode(expirationDate, forKey: CacheItem.CodingKey.expirationDate.rawValue)
    }
    
}
