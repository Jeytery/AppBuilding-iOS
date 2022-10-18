//
//  MenuViewController.swift
//  OpenClose
//
//  Created by Jeytery on 18.10.2022.
//

import Foundation
import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        title = "not clean"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Users"
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Cats"
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Dogs"
            }
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = "Girls"
        }
        else if indexPath.section == 3 {
            cell.textLabel?.text = "Mans"
        }
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if section == 1 {
            return 2
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}

