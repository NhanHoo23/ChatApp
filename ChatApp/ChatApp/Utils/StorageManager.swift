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
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {[weak self] metadata, error in
            guard error == nil else {
                //failed
                print("⭐️ failed to upload data to firebase for picture")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self?.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
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
    
    /// Uploads image that will be sent in a conversation
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: {[weak self] metadata, error in
            guard error == nil else {
                //failed
                print("⭐️ failed to upload data to firebase for picture")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: {url, error in
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
    
    /// Uploads video that will be sent in a conversation
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_videos/\(fileName)").putFile(from: fileUrl, metadata: nil, completion: {[weak self] metadata, error in
            guard error == nil else {
                //failed
                print("⭐️ failed to upload video file to firebase for picture")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self?.storage.child("message_videos/\(fileName)").downloadURL(completion: {url, error in
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
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageError.failedToGetDownloadUrl))
                return
            }
            
            completion(.success(url))
        })
    }
}
