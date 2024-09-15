//
//  ChatsViewController+DataSource.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 07/09/24.
//

import Foundation
import MessageKit

extension ChatsViewController: MessagesDataSource {
    func currentSender() -> any MessageKit.SenderType {
        return self.viewModel.getCurrentUser()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> any MessageKit.MessageType {
        return self.viewModel.getMKMessage()[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return self.viewModel.getMKMessage().count
    }
    
    //custom view cell
    func textCell(for message: any MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell? {
        guard let cell = messagesCollectionView.dequeueReusableCell(CustomTextViewCell.self, for: indexPath) as? CustomTextViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        return cell
    }
}
