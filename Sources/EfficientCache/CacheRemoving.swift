//
//  CacheRemoving.swift
//  EfficientCache
//
//  Created by Anas Merbouh on 2020-09-12.
//  Copyright © 2020 Anas Merbouh. All rights reserved.
//

import Foundation

public protocol CacheRemoving {

    /// Removes all the items from the cache.
    func removeAll(completionHandler: ((Error?) -> Void)?) -> Void
    
    /// Removes the item with the given key from the cache.
    ///
    /// - parameter key: A String representing the unique key of the item in the cache.
    /// - parameter completionHandler: A closure representing the block of code called
    ///                                once the operation completes.
    func removeItem(forKey key: String, completionHandler: ((Error?) -> Void)?) -> Void
    
}
