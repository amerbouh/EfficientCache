//
//  CacheFetching.swift
//  EfficientCache
//
//  Created by Anas Merbouh on 2020-09-13.
//  Copyright © 2020 Anas Merbouh. All rights reserved.
//

import Foundation

public protocol CacheFetching {
    associatedtype T
    
    /// Fetches the item with the given key from the cache.
    ///
    /// - parameter key: A String representing the key of the item to fetch.
    /// - parameter completionHandler: A closure representing the block of code called
    ///                                once the operation completes.
    func getItem(forKey key: String, completionHandler: ((T?) -> Void)?) -> Void
    
}
