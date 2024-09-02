//
//  EditProfileUserViewModel.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 30/08/24.
//

import Foundation
import YPImagePicker

protocol EditProfileUserViewModelDelegate: AnyObject {
    func setupView()
    func clearNavigationBar()
    func setupImageAvatar(with image: UIImage)
}

protocol EditProfileUserViewModelProtocol: AnyObject {
    var delegate: EditProfileUserViewModelDelegate? {get set}
    func onViewDidLoad()
    func onSaveUserDidTapped(username: String)
    func checkLastUsername() -> String
    func onEditProfileImageButtonDidTapped(_ picker: YPImagePicker)
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
                }
            }
            
            picker.dismiss(animated: true)
        }
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
}
