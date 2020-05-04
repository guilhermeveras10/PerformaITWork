//
//  ActionSheetViewModel.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 04/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation

struct ActionSheetViewModel {
    
    private var user: User
    
    var option: [ActionCheetOption] {
        var results = [ActionCheetOption]()
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionCheetOption = user.isFollowed ? .unfolow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}

enum ActionCheetOption {
    case follow(User)
    case unfolow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Seguir @\(user.username)"
        case .unfolow(let user):
            return "Deixar de seguir @\(user.username)"
        case .report:
            return "Denunciar"
        case .delete:
            return "Deletar"
        }
    }
}
