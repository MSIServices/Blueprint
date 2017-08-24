//
//  PreviewTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import Alamofire

class PreviewTVC: UITableViewCell {

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        loadingSpinner.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previewImageView.addViewBackedBorder(side: .south, thickness: 1.0, color: UIColor.darkGray)
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    func configureCell(linkPreview: LinkPreview?) {
            
        if let urlString = linkPreview?.image {
            getPreviewImage(urlString: urlString)
        } else {
            previewImageView.image = UIImage(named: "no-preview")
        }
        if let title = linkPreview?.title {
            titleLbl.text = title
        }
        if let url = linkPreview?.canonicalUrl {
            urlLbl.text = url
        }
    }
    
    func getPreviewImage(urlString: String) {
        
        MediaManager.shared.getImage(urlString: urlString, Success: { data in
            
            if data.count == 0 {
                self.previewImageView.image = UIImage(named: "no-preview")
            } else {
                self.previewImageView.image = UIImage(data: data)
            }
            
        }, Failure: { error in
            
            print(error)
            self.previewImageView.image = UIImage(named: "no-preview")
        })
    }
    
}
