//
//  SpinnerView.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 22/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import UIKit

class SpinnerView{
    static let shared = SpinnerView()
    let activityIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    let transparentView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.alpha = 0.8
        return view
    }()
    
    private init() {
        
    }
    
    func showSpinnerOn(view:UIView){
        view.addSubview(transparentView)
        
        transparentView.centerXAnchor.constraint(equalTo: view.superview?.centerXAnchor ?? view.centerXAnchor).isActive = true
        transparentView.centerYAnchor.constraint(equalTo: view.superview?.centerYAnchor ?? view.centerYAnchor).isActive = true
        transparentView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        transparentView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        transparentView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: transparentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: transparentView.centerYAnchor).isActive = true
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        activityIndicator.startAnimating()
    }
    
    func removeSpinnerFrom(view:UIView){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        transparentView.removeFromSuperview()
    }
}

