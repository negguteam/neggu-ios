//
//  String+Extension.swift
//  neggu
//
//  Created by 유지호 on 1/21/25.
//

import Foundation

extension String {
    
    func isValidNickname() -> Bool {
        let nicknameRegex = "^[가-힣a-z0-9]{1,7}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return predicate.evaluate(with: self)
    }
    
}
