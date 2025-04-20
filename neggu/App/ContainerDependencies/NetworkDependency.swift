//
//  NetworkDependency.swift
//  neggu
//
//  Created by 유지호 on 4/20/25.
//

extension DIContainer {
    
    func registerNetworkDependencies() {
        register(AuthService.self) {
            DefaultAuthService()
        }
        
        register(ClosetService.self) {
            DefaultClosetService()
        }
        
        register(LookBookService.self) {
            DefaultLookBookService()
        }
        
        register(UserService.self) {
            DefaultUserService()
        }
        
        register(InsightService.self) {
            DefaultInsightService()
        }
    }
    
}
