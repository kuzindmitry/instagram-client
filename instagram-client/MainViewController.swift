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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive(searchedTag:)), name: .init("SelectSearchedTag"), object: nil)
    }
    
    func receive(searchedTag notification: Notification) {
        guard let tag = notification.object as? Tag else {
            return
        }
        searchController.isActive = false
        searchController.searchBar.text = nil
        let tagPhotosViewController = self.storyboard?.instantiateViewController(withIdentifier: "TagPhotosViewController") as! TagPhotosTableViewController
        tagPhotosViewController.tag = tag
        self.navigationController?.pushViewController(tagPhotosViewController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .init("SelectSearchedTag"), object: nil)
    }
    
    @IBAction func logoutButtonDidTap(_ sender: UIBarButtonItem) {
        AuthorizationService().logout()
    }
    
    func present(_ user: User?) {
        guard let user = user else {
            return
        }
        userImageView.yy_setImage(with: URL(string: user.profile_picture), options: .setImageWithFadeAnimation)
        followsLabel.text = "\(user.followsCount)"
        followedByLabel.text = "\(user.followedByCount)"
        usernameLabel.text = "@" + user.username
    }
    
    func loadUserInformation() {
        activityIndicator.startAnimating()
        APIManager.shared.getUser { (user) in
            self.user = user
            DispatchQueue.main.async {
                self.present(user)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func loadPhotos() {
        activityIndicator.startAnimating()
        APIManager.shared.getPhotos { (photos) in
            self.photos = photos
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
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
