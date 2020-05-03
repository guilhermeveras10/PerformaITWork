//
//  AuthService.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 27/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let pwd: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logIn(email: String, pwd: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: pwd, completion: completion)
    }
    
    func registredUser(credentials: AuthCredentials, completion: @escaping(Error?,DatabaseReference) -> Void ) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.pwd) { (result, error) in
                    
                    guard let uid = result?.user.uid else { return }
                    let values = ["email": credentials.email,
                                  "username": credentials.username,
                                  "fullname": credentials.fullname,
                                  "profileImageUrl": profileImageUrl]
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
            
        }
    }
}
