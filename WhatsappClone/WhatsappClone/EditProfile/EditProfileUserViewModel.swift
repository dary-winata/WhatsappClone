//
//  EditProfileUserViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 30/08/24.
//

import FirebaseStorage
import Foundation
import YPImagePicker

protocol EditProfileUserViewModelDelegate: AnyObject {
    func setupView()
    func clearNavigationBar()
    func setupImageAvatar(with image: UIImage?)
    func showProgressStatus(with value: CGFloat)
    func setupUsername(with text: String)
}

protocol EditProfileUserViewModelProtocol: AnyObject {
    var delegate: EditProfileUserViewModelDelegate? {get set}
    func onViewDidLoad()
    func onSaveUserDidTapped(username: String)
    func checkLastUsername() -> String
    func onEditProfileImageButtonDidTapped(_ picker: YPImagePicker)
    func getProfiledataForAvatarUsername()
}

class EditProfileUserViewModel: EditProfileUserViewModelProtocol {
    
    weak var delegate: EditProfileUserViewModelDelegate?
    
    func onViewDidLoad() {
        delegate?.setupView()
    }
    
    func onSaveUserDidTapped(username: String) {
        editUsernameUser(with: username)
    }
    
    func checkLastUsername() -> String {
        if let username = FirebaseHelper.getCurrentUser?.username {
            return username
        }
        return ""
    }
    
    func onEditProfileImageButtonDidTapped(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled in
            
            
            if let photo = items.singlePhoto {
                DispatchQueue.main.async {
                    self.delegate?.setupImageAvatar(with: photo.image)
                    self.uploadAvatarToFireStore(with: photo.image)
                }
            }
            
            picker.dismiss(animated: true)
        }
    }
    
    func getProfiledataForAvatarUsername()  {
        guard let user = FirebaseHelper.getCurrentUser else {return}
        
        if user.avatar == "" {
            delegate?.setupImageAvatar(with: nil)
        } else {
            FirebaseStorageHelper.downloadImage(url: user.avatar) { image in
                self.delegate?.setupImageAvatar(with: image)
            }
        }
        delegate?.setupUsername(with: user.username)
    }
}

private extension EditProfileUserViewModel {
    func editUsernameUser(with username: String) {
        delegate?.clearNavigationBar()
        guard var currentUser = FirebaseHelper.getCurrentUser else {return}
        currentUser.username = username
        FirebaseHelper.saveUserToLocal(currentUser)
        FirebaseUserListener.shared.saveUserToFirestore(currentUser)
    }
    
    func uploadAvatarToFireStore(with image: UIImage) {
        guard let user = FirebaseHelper.getCurrentUser else {return}
        
        let dict: String = "Avatar/" + "_\(user.id)" + ".jpg"
        
        var task = FirebaseStorageHelper.uploadImage(image, directory: dict) { imageLink in
            if var user = FirebaseHelper.getCurrentUser {
                user.avatar = imageLink ?? ""
                FirebaseHelper.saveUserToLocal(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
        }
        
        task?.observe(StorageTaskStatus.progress) { snapshot in
            let progress = (snapshot.progress?.completedUnitCount ?? 0) / (snapshot.progress?.totalUnitCount ?? 0)
            self.delegate?.showProgressStatus(with: CGFloat(progress))
        }
        
        // TODO: Download image to local
        guard let imageJpg = image.jpegData(compressionQuality: 1.0) as? NSData else {return}
        FirebaseStorageHelper.saveFileToLocal(file: imageJpg as NSData, filename: user.id)
    }
}
