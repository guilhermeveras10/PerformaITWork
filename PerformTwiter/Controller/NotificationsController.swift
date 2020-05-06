//
//  NotificationsController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 23/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NotificAtionCell"

class NotificationsController: UITableViewController {
    
    //MARK: - Propeties
    
    private var notifications = [Notificacion]() {
        didSet {tableView.reloadData()}
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        tableView.reloadData()
    }
    
    //MARK: - API
    
    func fetch() {
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            self.checkUserFollowed(notifications: notifications)
            
        }
    }
    
    func checkUserFollowed(notifications: [Notificacion]) {
        for(index, notification) in notifications.enumerated() {
            if case .follow = notification.type {
                let user = notification.user
                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        view.backgroundColor = .white
        navigationItem.title = "Notificacoes"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    //MARK: - Selectors
    
    @objc func refresh() {
        fetch()
    }
}

//MARK: - TableView Datasource/Delegate

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.delegate = self
        cell.notification = notifications[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }
        TweetsSeervice.shared.fetchTweet(tweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

//MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {
    func didFollowTap(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (error, ref) in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { (error, ref) in
                cell.notification?.user.isFollowed = true
            }
            
        }
    }
    
    func selectProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        let controller = ProfilleController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
