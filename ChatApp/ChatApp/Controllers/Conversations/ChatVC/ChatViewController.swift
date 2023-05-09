//
//  ChatViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 28/03/2023.
//

import MTSDK
import MessageKit
import InputBarAccessoryView
import SDWebImage
import AVFoundation
import AVKit
import CoreLocation

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}

//MARK: Init and Variables
class ChatViewController: MessagesViewController {
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(email: String, id: String?) {
        super.init(nibName: nil, bundle: nil)
        self.otherUserEmail = email
        self.conversationID = id
        
    }
    
    //Variables
    var senderPhotoURL: URL?
    var otherUserPhotoURL: URL?
    var messages = [Message]()
    var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        return Sender(photoURL: "",
                      senderId: safeEmail,
                      displayName: "Me")
        
    }
    
    var isNewConversation: Bool = false
    var otherUserEmail: String!
    var conversationID: String?
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y 'at' h:mm:ss a z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

//MARK: Lifecycle
extension ChatViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationID = conversationID {
            listenForMessages(id: conversationID, shouldScrollToBottom: true)
        }
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension ChatViewController {
    private func setupView() {
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
    }
}


//MARK: Functions
extension ChatViewController {
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.handle { [weak self] in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: {[weak self] _ in
            self?.presentVideoInputActionsheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {[weak self] _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Location", style: .default, handler: {[weak self] _ in
            self?.presentLocationPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentLocationPicker() {
        let vc = LocationPickerViewController(coordinates: nil)
        vc.title = "Pick Location"
        vc.completion = {[weak self] selectedCoordinates in
            
            guard
                let strongSelf = self,
                let messageID = strongSelf.createMessageID(),
                let conversationID = strongSelf.conversationID,
                let name = strongSelf.title,
                let selfSender = strongSelf.selfSender
            else {
                return
            }
            
            let longitude: Double = selectedCoordinates.longitude
            let latitude: Double = selectedCoordinates.latitude
            
            print("⭐️ long = \(longitude) | lat = \(latitude)")
            
            let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
                                 size: .zero)
            let message = Message(sender: selfSender,
                                  messageId: messageID,
                                  sentDate: Date(),
                                  kind: .location(location))
            
            DatabaseManager.shared.sendMessage(to: conversationID,
                                               otherUserEmail: strongSelf.otherUserEmail,
                                               name: name,
                                               newMessage: message,
                                               completion: {success in
                if success {
                    print("⭐️ message location sent")
                } else {
                    print("⭐️ failed to send message location")
                }
            })
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentPhotoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to attach a photo from?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    private func presentVideoInputActionsheet() {
        let actionSheet = UIAlertController(title: "Attach Video",
                                            message: "Where would you like to attach a video from?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: {[weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.mediaTypes = ["public.movie"]
            picker.videoQuality = .typeMedium
            picker.allowsEditing = true
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func createMessageID() -> String? {
        //date, otherEmail, senderEmail, randomInt
        guard
            let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
            let otherUserEmail = otherUserEmail
        else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        
        print("⭐️ Create message id: \(newIdentifier)")
        return newIdentifier
    }
    
    func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: {[weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    print("⭐️ Message are empty")
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToBottom()
                    }
                    
                }
            case .failure(let error):
                print("⭐️ Failed to get messages \(error)")
            }
        })
    }
}

//MARK:  MessageDelegate

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate, InputBarAccessoryViewDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard
            let message = message as? Message
        else {
            return
        }

        switch message.kind {
        case .photo(let media):
            guard
                let imageUrl = media.url
            else {
                return
            }
            imageView.sd_setImage(with: imageUrl)
        default:
            break
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard
            let indexPath = messagesCollectionView.indexPath(for: cell)
        else {
            return
        }

        let message = messages[indexPath.section]
        switch message.kind {
        case .photo(let media):
            guard
                let imageUrl = media.url
            else {
                return
            }
            let vc = PhotoViewerViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        case .video(let media):
            guard
                let videoUrl = media.url
            else {
                return
            }
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
            present(vc, animated: true)
        default:
            break
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard
            let indexPath = messagesCollectionView.indexPath(for: cell)
        else {
            return
        }

        let message = messages[indexPath.section]
        switch message.kind {
        case .location(let locationData):
            let coordinates = locationData.location.coordinate
            let vc = LocationPickerViewController(coordinates: coordinates)
            vc.title = "Location"
            self.navigationController?.pushViewController(vc, animated: true)
       
        default:
            break
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard
            !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageID = createMessageID()
        else {
            return
        }
        
        print("⭐️ Sending text: \(text)")
        
        let message = Message(sender: selfSender,
                              messageId: messageID,
                              sentDate: Date(),
                              kind: .text(text))
        if isNewConversation {
            //create convo in database
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: {[weak self] success in
                if success {
                    print("⭐️ message sent")
                    self?.isNewConversation = false
                    let newConversationID = "conversation_\(message.messageId)"
                    self?.conversationID = newConversationID
                    self?.listenForMessages(id: newConversationID, shouldScrollToBottom: true)
                    self?.messageInputBar.inputTextView.text = nil
                } else {
                    print("⭐️ failed to send")
                }
            })
        } else {
            guard let conversationID = self.conversationID, let name = self.title else {
                return
            }
            //append to existing conversation data
            DatabaseManager.shared.sendMessage(to: conversationID, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: {[weak self] success in
                if success {
                    self?.messageInputBar.inputTextView.text = nil
                    print("⭐️ message sent")
                } else {
                    print("⭐️ failed to send")
                }
            })
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            //our message that we've sent
            return .link
        }
        
        return .secondarySystemBackground
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        
        if sender.senderId == selfSender?.senderId {
            if let currentUserImage = self.senderPhotoURL {
                avatarView.sd_setImage(with: currentUserImage)
            } else {
                guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return}
                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
                let path = "images/\(safeEmail)_profile_picture.png"
                
                StorageManager.shared.downloadURL(for: path, completion: {result in
                    switch result {
                    case .success(let url):
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url)
                        }
                    case .failure(let error):
                        print("⭐️ \(error)")
                    }
                })
            }
        } else {
            if let otherUserPhotoURL = self.otherUserPhotoURL {
                avatarView.sd_setImage(with: otherUserPhotoURL)
            } else {
                guard let email = self.otherUserEmail else {return}
                
                let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
                let path = "images/\(safeEmail)_profile_picture.png"
                
                StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
                    switch result {
                    case .success(let url):
                        self?.otherUserPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url)
                        }
                    case .failure(let error):
                        print("⭐️ \(error)")
                    }
                })
            }
        }
    }
}

//MARK:  PhotoDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard
            let messageID = createMessageID(),
            let conversationID = conversationID,
            let name = self.title,
            let selfSender = selfSender
        else {
            return
        }
        
        if let image = info[.editedImage] as? UIImage, let imageData = image.pngData() {
            let fileName = "photo_message_" + messageID.replacingOccurrences(of: " ", with: "-") + ".png"
            
            //upload image
            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: {[weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let urlString):
                    //ready to send message
                    print("⭐️ uploaded message photo: \(urlString)")
                    
                    guard
                        let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus")
                    else {
                        return
                    }

                    
                    let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
                    let message = Message(sender: selfSender,
                                          messageId: messageID,
                                          sentDate: Date(),
                                          kind: .photo(media))
                    
                    DatabaseManager.shared.sendMessage(to: conversationID,
                                                       otherUserEmail: strongSelf.otherUserEmail,
                                                       name: name,
                                                       newMessage: message,
                                                       completion: {success in
                        if success {
                            print("⭐️ message photo sent")
                        } else {
                            print("⭐️ failed to send message photo")
                        }
                    })
                case .failure(let error):
                    print("⭐️ message photo upload error: \(error)")
                }
            })
        } else if let videoUrl = info[.mediaURL] as? URL {
            let fileName = "video_message_" + messageID.replacingOccurrences(of: " ", with: "-") + ".mov"
            
            //upload video
            StorageManager.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: {[weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let urlString):
                    //ready to send message
                    print("⭐️ uploaded message video: \(urlString)")
                    
                    guard
                        let url = URL(string: urlString),
                        let placeholder = UIImage(systemName: "plus")
                    else {
                        return
                    }

                    
                    let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
                    let message = Message(sender: selfSender,
                                          messageId: messageID,
                                          sentDate: Date(),
                                          kind: .video(media))
                    
                    DatabaseManager.shared.sendMessage(to: conversationID,
                                                       otherUserEmail: strongSelf.otherUserEmail,
                                                       name: name,
                                                       newMessage: message,
                                                       completion: {success in
                        if success {
                            print("⭐️ message video sent")
                        } else {
                            print("⭐️ failed to send message video")
                        }
                    })
                case .failure(let error):
                    print("⭐️ message video upload error: \(error)")
                }
            })
        }
    }
}
