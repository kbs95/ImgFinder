//
//  FlickrImageResponse.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 22/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import Foundation

class FlickrResponse:Codable{
    var photos:FlickrPhotosResponse?
    var stat:String?
}

class FlickrPhotosResponse:Codable{
    var page:Int?
    var pages:Int?
    var perpage:Int?
    var total:String?
    var photo:[FlickrImageResponse]?
}

class FlickrImageResponse:Codable{
    var id:String?
    var owner:String?
    var secret:String?
    var server:String?
    var farm:Int?
    lazy var imageUrl:String = {
        return "https://farm\(farm ?? 0).staticflickr.com/\(server ?? "")/\(id ?? "")_\(secret ?? "")_q.jpg"
    }()
}
