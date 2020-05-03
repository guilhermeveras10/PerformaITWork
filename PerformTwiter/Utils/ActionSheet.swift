//
//  ActionSheet.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 03/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "ActionSheetCell"

class ActionSheet: NSObject {
    //MARK: - Propeties
    private let tableview = UITableView()
    private let user: User
    private var window: UIWindow?
    
    private lazy var blackView: UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    init(user: User) {
        self.user = user
        super.init()
        configurateTable()
    }
    
    //MARK: - Helpers
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableview)
        tableview.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 300)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableview.frame.origin.y -= 300
        }
    }
    
    func configurateTable() {
        tableview.backgroundColor = .red
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        tableview.layer.cornerRadius = 5
        tableview.isScrollEnabled = false
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableview.frame.origin.y += 300
        }
    }
}

//MARK: - UITableViewDataSource

extension ActionSheet: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ActionSheet: UITableViewDelegate {
    
}
