//
//  ViewController.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var userImageView:UIImageView!
    @IBOutlet weak var followsLabel:UILabel!
    @IBOutlet weak var followedByLabel:UILabel!
    @IBOutlet weak var usernameLabel:UILabel!
    
    @IBOutlet weak var tableView:UITableView!
    
    var user: User?
    var photos: [Photo] = []
    var searchController: UISearchController!
    var searchedTagsTable: SearchedTagsView!
    var isLoad: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurationSearch()
        loadUserInformation()
        loadPhotos()
    }
    
    func loadUserInformation() {
        APIManager.shared.getUser { (user) in
            self.user = user
            if let user = user {
                DispatchQueue.main.async {
                    self.userImageView.yy_setImage(with: URL(string: user.profile_picture), options: .setImageWithFadeAnimation)
                    self.followsLabel.text = "\(user.followsCount)"
                    self.followedByLabel.text = "\(user.followedByCount)"
                    self.usernameLabel.text = "@" + user.username
                }
            }
        }
    }
    
    func loadPhotos() {
        APIManager.shared.getPhotos { (photos) in
            self.photos = photos
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableCell
        cell.setPhoto(photos[indexPath.row])
        return cell
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func configurationSearch() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
        
        searchedTagsTable = SearchedTagsView(frame: CGRect(x: 0, y: 64.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - 64.0))
        searchedTagsTable.isHidden = true
        searchedTagsTable.delegate = self
        self.view.addSubview(searchedTagsTable)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if (!isLoad && searchController.searchBar.text != nil) {
            isLoad = true
            if (searchController.searchBar.text!.range(of: "#") == nil) {
                searchController.searchBar.text = "#" + searchController.searchBar.text!
            }
            let tagName = searchController.searchBar.text!.replacingOccurrences(of: "#", with: "")
            APIManager.shared.searchTag(tag: tagName, { (tags) in
                DispatchQueue.main.async {
                    if (tags.count > 0) {
                        self.searchedTagsTable.tags = tags
                        self.searchedTagsTable.isHidden = false
                        self.searchedTagsTable.tableView.reloadData()
                    } else {
                        self.searchedTagsTable.isHidden = true
                    }
                    self.isLoad = false
                }
            })
        }
    }
    
}

extension MainViewController: SearchedTagsDelegate {
    
    func selected(tag: Tag) {
        searchController.isActive = false
        searchController.searchBar.text = nil
        let tagPhotosViewController = self.storyboard?.instantiateViewController(withIdentifier: "TagPhotosViewController") as! TagPhotosTableViewController
        tagPhotosViewController.tag = tag
        self.navigationController?.pushViewController(tagPhotosViewController, animated: true)
    }
    
}
