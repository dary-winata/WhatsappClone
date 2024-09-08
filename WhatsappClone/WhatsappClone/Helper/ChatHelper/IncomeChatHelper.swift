//
//  IncomeChatHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 08/09/24.
//

import Foundation
import MessageKit

class IncomeChatHelper {
    static func createMessage(localMessage: LocalMessage) -> MKMessage? {
        return MKMessage(message: localMessage)
    }
}
