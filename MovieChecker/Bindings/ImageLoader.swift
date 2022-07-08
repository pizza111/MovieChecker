//
//  ImageLoader.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 08/07/2022.
//

import SwiftUI
import UIKit
//import UIKit

//we use NSCache to cache the data locally. It's similar to dictionary but it has build in mechanism to automatically relase objects from the memory if the system memory is low. We also store this as a global variable.
private let _imageChache = NSCache<AnyObject, AnyObject>()

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    var imageCache = _imageChache
    
    func loadImage(with url: URL) {
        let urlString = url.absoluteString
        if let imaageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            
        }
    }
}
