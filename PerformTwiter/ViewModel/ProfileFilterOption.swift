//
//  ProfileFilterOption.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 28/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

enum ProfileFilterOption: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    
    var description: String {
        switch self {
        case .tweets: return "Ideias"
        case .replies: return "Compartilhamentos"
        case .likes: return "Likes"
        }
    }
    
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    var followersString: NSAttributedString {
        return atribbutedString(withValue: user.stats?.followers ?? 0, text: "Seguidores")
    }
    
    var followingString: NSAttributedString {
        return atribbutedString(withValue: user.stats?.following ?? 0, text: "Seguindo")
    }
    
    var actionBtnTitle: String {
        if user.isCurrentUser {
            return "Editar Perfil"
        }
        if !user.isFollowed && !user.isCurrentUser {
            return "Seguir"
        }
        if user.isFollowed {
            return "Seguindo"
        }
        return "Carregando"
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var username: String {
        return "@\(user.username)"
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func atribbutedString(withValue value: Int, text: String) -> NSAttributedString {
        let atribbutedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        atribbutedTitle.append(NSAttributedString(string: "\(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return atribbutedTitle
    }
}
