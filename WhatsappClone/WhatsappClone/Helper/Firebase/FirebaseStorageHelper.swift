//
//  FirebaseStorageHelper.swift
//  WhatsappClone
//
//  Created by dary winata nugraha djati on 02/09/24.
//

import FirebaseStorage
import Foundation
import UIKit

class FirebaseStorageHelper {
    static func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ imageLink: String?) -> Void) -> StorageUploadTask? {
        let storageRef = Storage.storage().reference(forURL: keyStorageFirebase).child(directory)
        
        var task: StorageUploadTask?
        
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {return nil}
        
        
        task = storageRef.putData(imageData, metadata: nil) { metadata, err in
            task?.removeAllObservers()
            
            if err != nil {
                print(err?.localizedDescription ?? "")
            }
            
            storageRef.downloadURL { url, err in
                guard let url = url else {
                    completion(nil)
                    return
                }
                
                completion(url.absoluteString)
            }
        }
        
        return task
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        let fileName = fileNameFrom(url)
        
        if fileIsExistAtPath(fileName) {
            // TODO: Show image from file/document
            if let file = UIImage(contentsOfFile: fileDocumentDirectory(fileName)) {
                completion(file)
            }
        } else {
            // TODO: Download from firebase storage
            if url != "" {
                let fileUrl = URL(string: url)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: fileUrl!)
                    
                    if data != nil {
                        FirebaseStorageHelper.saveFileToLocal(file: data!, filename: fileName)
                        
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
        
    }
    
    // Mark: - Save to Local
    static func saveFileToLocal(file: NSData, filename: String) {
        let fileUrl = getDocumentUrl().appendingPathComponent(filename, isDirectory: false)
        file.write(to: fileUrl, atomically: true)
    }
}
