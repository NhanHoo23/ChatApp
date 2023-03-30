//
//  ChatViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 28/03/2023.
//

import MTSDK
import MessageKit
import InputBarAccessoryView

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

//MARK: Init and Variables
class ChatViewController: MessagesViewController {
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(email: String, id: String?) {
        super.init(nibName: nil, bundle: nil)
        self.otherUserEmail = email
        self.conversationID = id
        
    }
    
    //Variables
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
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
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

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension ChatViewController {
    private func setupView() {
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
}


//MARK: Functions
extension ChatViewController {
    func createMessageID() -> String? {
        //date, otherEmail, senderEmail, randomInt
        guard
            let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
            let otherUserEmail = self.otherUserEmail
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

//MARK: Delegate
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
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
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard
            !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = self.selfSender,
            let messageID = createMessageID()
        else {
            return
        }
        
        print("⭐️ Sending text: \(text)")
        
        if isNewConversation {
            //create convo in database
            let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .text(text))
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: { success in
                if success {
                    print("⭐️ message sent")
                } else {
                    print("⭐️ failed to send")
                }
            })
        } else {
            //append to existing conversation data
        }
    }
}
