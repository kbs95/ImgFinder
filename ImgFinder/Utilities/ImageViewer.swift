//
//  ImageViewer.swift
//  ImgFinder
//
//  Created by Karanbir Singh on 22/09/18.
//  Copyright © 2018 Abcplusd. All rights reserved.
//

import UIKit

class ImageViewer{
    static let shared = ImageViewer()
    let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    let blurView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    let frameView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    lazy var closeButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle(" Close", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    let seperatorView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    var fromViewFrame:CGRect!
    
    private init(){
        
    }
    func showImageViewFrom(frame:CGRect,image:String){
        let window = UIApplication.shared.keyWindow!
        fromViewFrame = frame
        blurView.frame = window.frame
        blurView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.blurView.alpha = 1
        }
        window.addSubview(blurView)
        blurView.contentView.addSubview(frameView)
        frameView.addSubview(imageView)
        frameView.addSubview(closeButton)
        frameView.addSubview(seperatorView)
        
        frameView.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        frameView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        frameView.leadingAnchor.constraint(equalTo: window.leadingAnchor,constant:30).isActive = true
        frameView.trailingAnchor.constraint(equalTo: window.trailingAnchor,constant:-30).isActive = true
        frameView.heightAnchor.constraint(equalToConstant: 270).isActive = true
        
        imageView.topAnchor.constraint(equalTo: frameView.topAnchor,constant:25).isActive = true
        imageView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        
        closeButton.topAnchor.constraint(equalTo: frameView.topAnchor,constant:0).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        
        seperatorView.bottomAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        seperatorView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor).isActive = true
        seperatorView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor).isActive = true
        
        imageView.sd_setImage(with: URL(string: image)!, completed: nil)
        imageView.contentMode = .scaleAspectFill
    }
    
    @objc func closeAction(){
        UIView.animate(withDuration: 0.2, animations: {
            self.blurView.alpha = 0
        }) { (_) in
            self.blurView.removeFromSuperview()
        }
    }
}
