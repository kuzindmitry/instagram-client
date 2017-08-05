//
//  SearchedTagsTableView.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation
import UIKit

class SearchedTagsView: UIView {
    
    var tableView: UITableView!
    var tags: [Tag] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurationTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchedTagsView: UITableViewDataSource, UITableViewDelegate {

    func configurationTable() {
        self.tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchedTagsCell")
        self.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchedTagsCell", for: indexPath)
        cell.textLabel?.text = "#" + tags[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .init(rawValue: "SelectSearchedTag"), object: tags[indexPath.row])
        isHidden = true
    }

}
