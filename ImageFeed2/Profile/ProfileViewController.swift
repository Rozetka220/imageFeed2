//
//  ProfileViewController.swift
//  ImageFeed2
//
//  Created by Аделия Исхакова on 27.03.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let leadingConstraintForLeftElements = 16.0
    
    private var imageViewAvatar = UIImageView()
    private var nameLabel = UILabel()
    private var nicNameLabel = UILabel()
    private var textLabel = UILabel()
    
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    let getBearerToken = OAuth2TokenStorage().token!
    
    private var alertDelegate: AlertPresenterDelegate?
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //при попытке открытия в таббаре профиля, в случае отсуствия данных профиля выкидывает алерт
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        if profileService.profile == nil {
            showAlert()
        } else {
            if let profile = profileService.profile {
                updateProfileDetails(profile: profile)
                //updateAvatar()
            } else {
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertDelegate = AlertPresenter()
        alertDelegate?.delegate = self
        
        let profile = profileService.profile
        print("profile = ", profile)
        createProfile(name: profile?.name, loginName: profile?.loginName, bio: profile?.bio)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.DidChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            print("observer")
            guard let self = self else { return }
            let profile = self.profileService.profile
            print("updateAVa = ", profile)
            self.updateAvatar()
        })
        updateAvatar()
       
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        imageViewAvatar.kf.setImage(with: url, placeholder: UIImage(named: "placeholderAvatarSmall"), options: [.processor(processor)])
        print("updateAvatar")
    }
    
    private func createProfileImage(){
        imageViewAvatar.backgroundColor = .clear
        if ProfileImageService.shared.avatarURL != nil {
            updateAvatar()
        } else {
            imageViewAvatar.image = UIImage(named: "placeholderAvatarSmall")
        }
        
        imageViewAvatar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageViewAvatar)
        
        NSLayoutConstraint.activate([
            imageViewAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageViewAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraintForLeftElements),
            imageViewAvatar.heightAnchor.constraint(equalToConstant: 70),
            imageViewAvatar.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func createLabelName(_ name: String){
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = name //"Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageViewAvatar.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraintForLeftElements)
        ])
    }
    
    private func createNicNameLabel(_ nickname: String) {
        nicNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nicNameLabel.text = nickname //"@ekaterina_nov"
        nicNameLabel.textColor = UIColor(named: "YP Gray")
        nicNameLabel.font = UIFont.systemFont(ofSize: 13)
        
        view.addSubview(nicNameLabel)
        
        NSLayoutConstraint.activate([
            nicNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstraintForLeftElements)
        ])
    }
    
    private func createTextLabel(_ bio: String) {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.text = bio //"Hello, world!"
        textLabel.font = UIFont.systemFont(ofSize: 13)
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
    
    func createProfile(name: String?, loginName: String?, bio: String?) {
        guard let name = name, let loginName = loginName, let bio = bio else {
            showAlert()
            return
        }

        createProfileImage()
        createLabelName(name)
        createNicNameLabel(loginName)
        createTextLabel(bio)
        createExitButton()
    }
    
    private func updateProfileDetails(profile: Profile) {
        createProfile(name: profile.name, loginName: profile.loginName, bio: profile.bio)
    }
    
    private func createAlertText(title: String, message: String, buttonText: String) -> AlertModel {
        let alerModel = AlertModel(title: title, //"Ошибка!",
                                   message: message, // "Не удалось загрузить профиль \n повторите попытку позже",
                                   buttonText: buttonText) { [weak self] _ in
                        //перемещаемся на imageList
            self?.tabBarController?.selectedIndex = 0
        }
        return alerModel
    }
    
    private func showAlert() {
        alertDelegate?.presentAlert(model: createAlertText(title: "Ошибка!", message: "Не удалось получить данные профиля, повторите попытку позже", buttonText: "Отмена"))
    }
    
    @IBAction private func clickedExitButton(_ sender: UIButton){
        
    }
}
