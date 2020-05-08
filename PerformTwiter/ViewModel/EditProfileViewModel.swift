//
//  EditProfileOptions.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 07/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullname
    case username
    
    var description: String {
        switch self {
        case .username: return "Apelido"
        case .fullname: return "Nome"
        }
    }
}

struct EditProfileViewModel {
    private let user: User
    let option: EditProfileOptions
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .username: return user.username
        case .fullname: return user.fullname
        }
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
}
