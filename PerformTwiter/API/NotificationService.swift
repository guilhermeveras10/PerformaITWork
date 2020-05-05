//
//  NotificationService.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 04/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        var values:[String:Any] = ["timestamp" : Int(NSDate().timeIntervalSince1970),
                                   "uid": currentUID,
                                   "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        }
    }
    
    func fetchNotifications(completion: @escaping([Notificacion]) -> Void) {
        var notifications = [Notificacion]()
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATIONS.child(currentUID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notificacion(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
