//
//  DataFetchPhase.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 24/07/2022.
//

import Foundation

enum DataFetchPhase<V> {
    case empty
    case success(V)
    case failure(Error)
    
    var value: V? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
}


