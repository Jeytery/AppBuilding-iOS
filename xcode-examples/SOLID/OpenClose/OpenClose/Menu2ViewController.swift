//
//  Menu2ViewController.swift
//  OpenClose
//
//  Created by Jeytery on 18.10.2022.
//

import Foundation
import UIKit
import SnapKit

class Menu2ViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    struct CellContent {
        let groupName: String
        let content: [String ]
    }
    
    private let cellContents: [CellContent] = [
        .init(groupName: "Users Types", content: ["Common", "Admins", "Banned"]),
        .init(groupName: "Animals", content: ["Cats", "Dogs"]),
        .init(groupName: "Apple Programming languages", content: ["Swift", "Objective-C"]),
        .init(groupName: "Android Programming languagees", content: ["Kotlin", "Java"])
    ]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        title = "clean"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension Menu2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.textLabel?.text = cellContents[indexPath.section].content[indexPath.row]
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return cellContents[section].content.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellContents.count
    }
    
    func tableView(
        _ tableView: UITableView,
        titleForFooterInSection section: Int
    ) -> String? {
        return cellContents[section].groupName
    }
}

