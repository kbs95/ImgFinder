//
//  HomeSearchViewController.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 21/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import UIKit
import SDWebImage

class HomeSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var columnCount:CGFloat = 2.0
    var photosResponse:[FlickrImageResponse] = []
    var currentPageCount:Int = 1
    var totalPages:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupSearchBar()
        setupCollectionView()
    }

    func setupNavigation(){
        title = "Home"
        view.backgroundColor = UIColor(displayP3Red: 0.83, green: 0.83, blue: 0.83, alpha: 1.0)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0.83, green: 0.83, blue: 0.83, alpha: 1.0)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsAction))
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func setupSearchBar(){
        searchBar.barTintColor = UIColor(displayP3Red: 0.83, green: 0.83, blue: 0.83, alpha: 1.0)
        searchBar.delegate = self
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
    }
    @objc func optionsAction(){
        // option button pressed
        let actionSheet = UIAlertController(title: "Display Option", message: "Select column count", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Two", style: .default, handler: { (_) in
            self.columnCount = 2
            self.collectionView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "Three", style: .default, handler: { (_) in
            self.columnCount = 3
            self.collectionView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "Four", style: .default, handler: { (_) in
            self.columnCount = 4
            self.collectionView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HomeSearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // do searching here
        print("Searching--\(searchBar.text ?? "")")
        searchBar.resignFirstResponder()
        // checking network
        if !ReachabilityManager.isConnectedToNetwork(){
            self.photosResponse = CoreDataManager.shared.fetchSavedImageDataForSearch(text: searchBar.text ?? "")
            self.collectionView.reloadData()
            return
        }
        fetchImages(text: searchBar.text ?? "")
    }
    
    func fetchImages(text:String){
        SpinnerView.shared.showSpinnerOn(view: collectionView)
        currentPageCount = 1
        FlickrService.shared.fetchImagesFor(text: text,pageCount: currentPageCount) { (response,error) in
            if let data = response,error == nil{
                self.photosResponse = data.photos?.photo ?? []
                self.totalPages = data.photos?.pages ?? 0
                CoreDataManager.shared.createNewEntityForSearch(text: text)
                self.collectionView.reloadData()
            }else{
                print(error?.localizedDescription ?? "")
            }
            SpinnerView.shared.removeSpinnerFrom(view: self.collectionView)
        }
    }
}

extension HomeSearchViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        // set image
        cell.imageView.sd_addActivityIndicator()
        cell.imageView.sd_setImage(with: URL(string: photosResponse[indexPath.row].imageUrl)!) { (img, err, cache, url) in
            if err == nil{
                CoreDataManager.shared.saveImageDataForSearch(text: self.searchBar.text ?? "", imageData: url?.absoluteString ?? "")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calculatedWidth = (collectionView.frame.width/columnCount - 15)
        return CGSize(width:calculatedWidth , height: calculatedWidth)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (photosResponse.count - 1), currentPageCount < totalPages{
            currentPageCount += 1
            FlickrService.shared.fetchImagesFor(text: self.searchBar.text ?? "", pageCount: currentPageCount) { (response, error) in
                if let data = response,error == nil{
                    self.photosResponse.append(contentsOf: data.photos?.photo ?? [])
                    self.collectionView.reloadData()
                }else{
                    print(error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ImageViewer.shared.showImageViewFrom(frame: collectionView.convert((collectionView.layoutAttributesForItem(at: indexPath)?.frame)!, to: nil), image: photosResponse[indexPath.row].imageUrl)
    }
}

extension HomeSearchViewController:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
