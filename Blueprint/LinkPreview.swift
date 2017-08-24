//
//  LinkPreview.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/22/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import Foundation

struct LinkPreview {
    
    private var _icon: String?
    private var _title: String?
    private var _descrip: String?
    private var _image: String?
    private var _images: [String]?
    private var _canonicalUrl: String?
    private var _finalUrl: URL?
    private var _url: String?
    
    var icon: String? {
        return _icon
    }
    
    var title: String? {
        return _title
    }
    
    var descrip: String? {
        return _descrip
    }
    
    var image: String? {
        return _image
    }
    
    var images: [String]? {
        return _images
    }
    
    var canonicalUrl: String? {
        return _canonicalUrl
    }
    
    var finalUrl: URL? {
        return _finalUrl
    }
    
    var url: String? {
        return _url
    }
    
    init(icon: String?, title: String?, descrip: String?, image: String?, images: [String]?, canonicalUrl: String?, finalUrl: URL?, url: String?) {
        self._icon = icon
        self._title = title
        self._descrip = descrip
        self._image = image
        self._images = images
        self._canonicalUrl = canonicalUrl
        self._finalUrl = finalUrl
        self._url = url
    }
    
}
