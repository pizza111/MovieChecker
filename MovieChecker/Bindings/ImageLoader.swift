//
//  ImageLoader.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 08/07/2022.
//

import SwiftUI
import UIKit

//we use NSCache to cache the data locally. It's similar to dictionary but it has build in mechanism to automatically relase objects from the memory if the system memory is low. We also store this as a global variable.
private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    var imageCache = _imageCache
    
    func loadImage(with url: URL) {
        let urlString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
