//
//  PhotoTableCell.swift
//  instagram-client
//
//  Created by kuzindmitry on 11.07.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

import Foundation
import UIKit
import YYWebImage

class PhotoTableCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var likesLabel:UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setPhoto(_ photo: Photo) {
        
        usernameLabel.text = photo.user.username
        userImageView.yy_setImage(with: URL(string: photo.user.pictureUrl), options: .setImageWithFadeAnimation)
        locationLabel.text = photo.location_name
        photoImageView.yy_setImage(with: URL(string: photo.url), options: .setImageWithFadeAnimation)
        if (photo.captionSender != nil && photo.caption != nil) {
            captionLabel.text = photo.captionSender! + ": " + photo.caption!
        } else {
            captionLabel.text = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        dateLabel.text = photo.created_time.ago
        likesLabel.text = "Лайки: \(photo.likes_count)"
    }
    
}


