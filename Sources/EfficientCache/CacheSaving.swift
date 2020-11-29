//
//  CacheSaving.swift
//  EfficientCache
//
//  Created by Anas Merbouh on 2020-09-09.
//  Copyright © 2020 Anas Merbouh. All rights reserved.
//

import Foundation

public protocol CacheSaving {
    associatedtype T
    
    /// Saves the given item in the cache.
    ///
    /// - parameter item: The item added to the cache.
    /// - parameter key: A String representing the unique key of the item in the cache. It
    ///                  is used to retrieve the item later on.
    /// - parameter update: A boolean indicating whether or not the item should be updated
    ///                     if it exists on the cache or left as is.
    /// - parameter completionHandler: A closure representing the block of code called
    ///                                once the operation completes.
    func save(_ item: T, forKey key: String, update: Bool, completionHandler: @escaping ((Error?) -> Void)) -> Void
    
}
