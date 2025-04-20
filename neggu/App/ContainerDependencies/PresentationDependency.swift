//
//  PresentationDependency.swift
//  neggu
//
//  Created by 유지호 on 8/8/24.
//

extension DIContainer {
    
    func registerPresentationDependencies() {
        // MARK: Auth
        register(LoginView.self) {
            LoginView()
        }
        
        register(SignUpView.self) {
            SignUpView()
        }
        
        register(SignUpCompleteView.self) {
            SignUpCompleteView()
        }
        
        register(OnboardingView.self) {
            OnboardingView()
        }
        
        
        
        // MARK: Closet
        register(ClosetViewModel.self) { [unowned self] in
            let closetService = self.resolve(ClosetService.self)
            let userService = self.resolve(UserService.self)
            return ClosetViewModel(
                userService: userService,
                closetService: closetService
            )
        }
        
        register(ClosetView.self) {
            ClosetView()
        }
        
        
        register(ClothesDetailViewModel.self) { [unowned self] in
            let service = self.resolve(ClosetService.self)
            return ClothesDetailViewModel(closetService: service)
        }
        
        register(ClothesDetailView.self) { [unowned self] id in
            let viewModel = self.resolve(ClothesDetailViewModel.self)
            return ClothesDetailView(viewModel: viewModel, clothesID: id)
        }
        
        
        register(ClothesRegisterViewModel.self) { [unowned self] in
            let closetService = self.resolve(ClosetService.self)
            return ClothesRegisterViewModel(closetService: closetService)
        }
        
        register(ClothesRegisterView.self) { [unowned self] editType in
            let viewModel = self.resolve(ClothesRegisterViewModel.self)
            return ClothesRegisterView(
                viewModel: viewModel,
                editType: editType
            )
        }
        
        
        
        // MARK: LookBook
        register(LookBookViewModel.self) { [unowned self] in
            let userService = self.resolve(UserService.self)
            let closetService = self.resolve(ClosetService.self)
            let lookBookService = self.resolve(LookBookService.self)
            return LookBookViewModel(
                userService: userService,
                closetService: closetService,
                lookBookService: lookBookService
            )
        }
        
        register(LookBookMainView.self) {
            LookBookMainView()
        }
        
        
        register(LookBookDetailViewModel.self) { [unowned self] in
            let lookBookService = self.resolve(LookBookService.self)
            return LookBookDetailViewModel(lookBookService: lookBookService)
        }
        
        register(LookBookDetailView.self) { id in
            let viewModel = self.resolve(LookBookDetailViewModel.self)
            return LookBookDetailView(viewModel: viewModel, lookBookID: id)
        }
        
        
        register(LookBookRegisterViewModel.self) { [unowned self] in
            let closetService = self.resolve(ClosetService.self)
            let lookBookService = self.resolve(LookBookService.self)
            return LookBookRegisterViewModel(
                closetService: closetService,
                lookBookService: lookBookService
            )
        }
        
        register(LookBookRegisterView.self) { [unowned self] code, clothes in
            let viewModel = self.resolve(LookBookRegisterViewModel.self)
            return LookBookRegisterView(
                viewModel: viewModel,
                inviteCode: code,
                editingClothes: clothes
            )
        }
    }
    
}
