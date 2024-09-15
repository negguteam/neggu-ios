//
//  DIContainer.swift
//  neggu
//
//  Created by 유지호 on 8/8/24.
//

import Foundation

public final class DIContainer {
    
    public static let shared = DIContainer()
    
    private var factories = [String: () -> Any]()
    
    
    private init() { }
    
    
    public func register<T>(_ serviceType: T.Type, _ object: @escaping () -> T) {
        let key = String(describing: serviceType)
        factories[key] = object
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        let key = String(describing: serviceType)
        
        guard let factory = factories[key] else {
            preconditionFailure("\(key) should be registered!")
        }
        
        return factory() as! T
    }
    
}
