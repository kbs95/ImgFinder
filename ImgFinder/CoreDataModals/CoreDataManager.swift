//
//  CoreDataManager.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 22/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager{
    static let shared = CoreDataManager()
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {
        
    }
    
    func createNewEntityForSearch(text:String){
        if text.isEmpty{
            return
        }
        let fetchRequest:NSFetchRequest<OfflineSearch> = OfflineSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchText = %@", text)
        do{
            let results = try context.fetch(fetchRequest)
            for result in results{
                context.delete(result)
            }
            let offlineSearchEntity = OfflineSearch(context: context)
            offlineSearchEntity.searchText = text
            try context.save()
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    func saveImageDataForSearch(text:String,imageData:String){
        if text.isEmpty{
            return
        }
        let fetchRequest:NSFetchRequest<OfflineSearch> = OfflineSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchText = %@", text)
        do {
            if let result = try context.fetch(fetchRequest).first{
                if result.searchResuts.contains(imageData){
                   return
                }
                result.searchResuts.append(imageData)
            }
            try context.save()
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
    func fetchSavedImageDataForSearch(text:String)->[FlickrImageResponse]{
        if text.isEmpty{
            return []
        }
        let fetchRequest:NSFetchRequest<OfflineSearch> = OfflineSearch.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchText = %@", text)
        var flickrResponse:[FlickrImageResponse] = []
        do{
            let results = try context.fetch(fetchRequest)
            for url in results.first?.searchResuts ?? []{
                let flickrObj = FlickrImageResponse()
                flickrObj.imageUrl = url
                flickrResponse.append(flickrObj)
            }
            return flickrResponse
        }catch let err{
            print(err.localizedDescription)
        }
        return flickrResponse
    }
}
