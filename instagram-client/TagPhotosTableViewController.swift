//
//  TagPhotosTableViewController.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation
import UIKit

class TagPhotosTableViewController: UITableViewController {
    
    var photos: [Photo] = []
    var tag: Tag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "#" + tag.name
        loadPhotos()
    }
    
    func loadPhotos() {
        APIManager.shared.getPhotosForTag(tag) { (newPhotos) in
            self.photos = newPhotos
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTagCell", for: indexPath) as! PhotoTableCell
        cell.setPhoto(photos[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
    
}
