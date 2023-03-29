//
//  StorageManager.swift
//  ChatApp
//
//  Created by NhanHoo23 on 29/03/2023.
//

import MTSDK
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("image/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                //failed
                print("⭐️ failed to upload data to firebase for picture")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            let reference = self.storage.child("image/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("⭐️ failed to get download Url")
                    completion(.failure(StorageError.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("⭐️ download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}
