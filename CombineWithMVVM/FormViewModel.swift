//
//  FormViewModel.swift
//  CombineDemoWithUIKit
//
//  Created by mac-00015 on 29/11/19.
//  Copyright © 2019 mac-00015. All rights reserved.
//

import Foundation
import Combine

class FormViewModel {
    
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    let usernameMessagePublisher = PassthroughSubject<String, Never>()
    let passwordMessagePublisher = PassthroughSubject<String, Never>()
    
    var validatedUsername: AnyPublisher<String?, Never> {
        
        return $username
            .map { name in
                
                guard name.count != 0 else {
                    
                    self.usernameMessagePublisher.send("Username can't be blank")
                    return nil
                }
                
                guard name.count > 2 else {
                    
                    self.usernameMessagePublisher.send("Minimum of 3 characters required")
                    return nil
                }
                
                self.usernameMessagePublisher.send("")
                return name
        }
        .eraseToAnyPublisher()
    }
    
    var validatedPassword: AnyPublisher<String?, Never> {
        
        return Publishers.CombineLatest($password, $confirmPassword)
            .receive(on: RunLoop.main)
            .map { pass, confPass in
                
                guard confPass == pass, pass.count > 4 else {
                    
                    self.passwordMessagePublisher.send("Values must match and have at least 5 characters")
                    return nil
                }
                
                self.passwordMessagePublisher.send("")
                
                return pass
        }
        .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<(String, String)?, Never> {
        
        return Publishers.CombineLatest(validatedUsername, validatedPassword)
            .map { name, pass in
                
                guard let name = name, let pass = pass else {
                    return nil
                }
                return (name, pass)
        }
        .eraseToAnyPublisher()
    }
}
