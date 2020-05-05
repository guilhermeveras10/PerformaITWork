//
//  NotificacionViewModel.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 04/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

struct NotificacionViewModel {
    
    private let notification: Notificacion
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var notificationMessage: String {
        switch type {
        case .follow: return " Comecou a seguir voce"
        case .like: return " Curtiu seu tweet"
        case .reply: return " Compartilhou seu tweet"
        case .retweet: return " Compartilhou seu tweet"
        case .mention: return " Fez mencao ao seu tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        
        let atribbutedTitle = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        atribbutedTitle.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        atribbutedTitle.append(NSAttributedString(string: " \(timestamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return atribbutedTitle
    }
    
    init(notification: Notificacion) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
