//
//  FlickrService.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 21/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import Foundation

class FlickrService{
    
    static var shared = FlickrService()
    private var apiKey = "d2fcb3a13bedd9360d977457afc75021"
    private var secret = "48199509e4251a03"
    
    private init() {
    }
    
    func fetchImagesFor(text:String,pageCount:Int,completion:@escaping(_ response:FlickrResponse?,_ error:Error?)->()){
        let stringText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlRequest = URLRequest(url: URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(stringText)&per_page=50&page=\(pageCount)&format=json&nojsoncallback=1")!)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            if err == nil{
                // parse response
                if let jsonData = data{
                    let imgResponse = try! JSONDecoder().decode(FlickrResponse.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(imgResponse,nil)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil,err)
                }
            }
        }.resume()
    }
    
}
