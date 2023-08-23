//
//  CacheManager.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 12.08.23.
//

import Foundation
import Kingfisher

final class CacheManager {
    
    static func clean() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        cache.backgroundCleanExpiredDiskCache()
        cache.cleanExpiredMemoryCache()
        cache.clearCache()
    }
}
