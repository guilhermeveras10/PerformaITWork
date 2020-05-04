//
//  ActionSheet.swift
//  PerformTwiter
//
//  Created by Guilherme. Duarte on 03/05/20.
//  Copyright © 2020 Guilherme Duarte. All rights reserved.
//

import Foundation
import UIKit

protocol ActionSheetDelegate: class {
    func didSelect(option: ActionCheetOption)
}

private let reuseIdentifier = "ActionSheetCell"

class ActionSheet: NSObject {
    //MARK: - Propeties
    private let tableview = UITableView()
    private let user: User
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate: ActionSheetDelegate?
    private var tableViewHeight: CGFloat?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelBtn)
        cancelBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelBtn.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        cancelBtn.centerY(inView: view)
        cancelBtn.layer.cornerRadius = 50 / 2
        return view
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancelar", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .systemGroupedBackground
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    init(user: User) {
        self.user = user
        super.init()
        configurateTable()
    }
    
    //MARK: - Helpers
    
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableview.frame.origin.y = y
    }
    
    func show() {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableview)
        let height = CGFloat(viewModel.option.count * 60) + 100
        self.tableViewHeight = height
        tableview.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
    }
    
    func configurateTable() {
        tableview.backgroundColor = .white
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        tableview.layer.cornerRadius = 5
        tableview.isScrollEnabled = false
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
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
        return viewModel.option.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.option[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ActionSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.option[indexPath.row]
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.showTableView(false)
        }) {_ in
            self.delegate?.didSelect(option: option)
        }
    }
}
