//
//  MainTabBarController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 23/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    //MARK: - Propeties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    let actionBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.rgb(red: 177/255, green: 176/255, blue: 176/255)
        btn.setImage(UIImage(named: "new_tweet"), for: .normal)
        btn.addTarget(self, action: #selector(newTweet), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticadUser()
    }
    
    //MARK: - Selectors
    
    @objc func newTweet() {
        guard let user = user else { return }
        let controller = UploadTwiiterController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - API
    
    func fetch() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticadUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            fetch()
            configureInterface()
            configureViewControllers()
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //MARK: - Helpers
    
    func configureInterface() {
        view.addSubview(actionBtn)
        actionBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionBtn.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers() {
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateConfigureRoot(image: UIImage(named: "home_unselected"), rootView: feed)
    
        let explore = ExploreController()
        let nav2 = templateConfigureRoot(image: UIImage(named: "search_unselected"), rootView: explore)
        
        let notification = NotificationsController()
        let nav3 = templateConfigureRoot(image: UIImage(named: "like_unselected"), rootView: notification)
        
        let conversation = ConversationsController()
        let nav4 = templateConfigureRoot(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootView: conversation)
        
        viewControllers = [nav1,nav2,nav3,nav4]
    }
    
    func templateConfigureRoot(image: UIImage?, rootView: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootView)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
