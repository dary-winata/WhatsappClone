//
//  MKSender.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 07/09/24.
//

import Foundation
import MessageKit

struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
