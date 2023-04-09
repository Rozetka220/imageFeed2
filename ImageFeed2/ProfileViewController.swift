//
//  ProfileViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 27.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    let leadingConstraintForLeftElements = 16.0
    
    var imageViewAvatar = UIImageView()
    var nameLabel = UILabel()
    var nicNameLabel = UILabel()
    var textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createProfileImage()
        createLabelName()
        createNicNameLabel()
        createTextLabel()
        createExitButton()
    }
    
    private func createProfileImage(){
        let image = UIImage(named: "userPhoto")
        imageViewAvatar = UIImageView(image: image)
        
        imageViewAvatar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageViewAvatar)
        
        NSLayoutConstraint.activate([
            imageViewAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageViewAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraintForLeftElements),
            imageViewAvatar.heightAnchor.constraint(equalToConstant: 70),
            imageViewAvatar.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func createLabelName(){
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont(name: "System", size: 40)
        //nameLabel.font = UIFont.systemFont(ofSize: 40)
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageViewAvatar.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func createNicNameLabel() {
        nicNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nicNameLabel.text = "@ekaterina_nov"
        nicNameLabel.textColor = UIColor(named: "YP Gray")
        nicNameLabel.font = UIFont(name: "System", size: 13)
        
        view.addSubview(nicNameLabel)
        
        NSLayoutConstraint.activate([
            nicNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraintForLeftElements)
        ])
    }
    
    private func createTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.text = "Hello, world!"
        textLabel.font = UIFont(name: "System", size: 13)
        textLabel.textColor = .white
        
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: nicNameLabel.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraintForLeftElements)
        ])
    }
    
    private func createExitButton() {
        let image = UIImage(systemName: "ipad.and.arrow.forward")
        let exitButton = UIButton.systemButton(with: image!, target: self, action: #selector(clickedExitButton(_:)))
        
        exitButton.tintColor = UIColor(named: "YP Red")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55.7)
        ])
    }
    
    @IBAction func clickedExitButton(_ sender: UIButton){
        
    }
}
