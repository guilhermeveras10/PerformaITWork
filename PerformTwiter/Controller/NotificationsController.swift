//
//  NotificationsController.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 23/04/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import UIKit

class NotificationsController: UIViewController {
    
    //MARK: - Propeties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
    }
    
    //MARK: - Helpers
    
    func configureInterface() {
        view.backgroundColor = .white
        navigationItem.title = "Notificacoes"
    }
}
