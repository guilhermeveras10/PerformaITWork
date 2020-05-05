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
    
    //MARK: - API
    
    func fetch() {
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
        }
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        view.backgroundColor = .white
        navigationItem.title = "Notificacoes"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        return cell
    }
}
