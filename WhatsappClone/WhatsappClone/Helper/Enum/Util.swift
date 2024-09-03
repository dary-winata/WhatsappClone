//
//  Util.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 03/09/24.
//

import Foundation

func fileNameFrom(_ url: String) -> String {
    return url.components(separatedBy: "_").last?.components(separatedBy: ".").first ?? ""
}

func fileIsExistAtPath(_ fileName: String) -> Bool {
    return FileManager.default.fileExists(atPath: fileDocumentDirectory(fileName))
}

func fileDocumentDirectory(_ fileName: String) -> String {
    return getDocumentUrl().appendingPathComponent(fileName).path
}

func getDocumentUrl() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
