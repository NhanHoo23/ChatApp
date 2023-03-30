//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by NhanHoo23 on 28/03/2023.
//

import MTSDK
import SDWebImage

class ConversationTableViewCell: UITableViewCell {
    
    
    //Variables
    var containerView: UIView!
    private let userImageView = UIImageView()
    private let userNameLb = UILabel()
    private let userMessageLb = UILabel()
     
    private var conversations = [Conversation]()
}


//MARK: Functions
extension ConversationTableViewCell {
    func configsCell(with model: Conversation) {
        if containerView == nil {
            self.setupView()
        }
        self.userMessageLb.text = model.latestMessage.text
        self.userNameLb.text = model.name
        
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
        print("⭐️ path: \(path)")
        StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url)
                }
            case .failure(let error):
                print("⭐️ Failed to get image url \(error)")
            }
        })
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView = UIView()
        containerView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-10)
            }
            $0.backgroundColor = .clear
        }
        
        userImageView >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(Spacing.large)
                $0.width.height.equalTo(60)
            }
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 30
            $0.layer.masksToBounds = true
        }

        userNameLb >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(containerView.snp.centerY).offset(-Spacing.small)
                $0.leading.equalTo(userImageView.snp.trailing).offset(Spacing.large)
            }
            $0.font = UIFont(name: FNames.medium, size: 21)
        }
        
        userMessageLb >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(containerView.snp.centerY).offset(Spacing.small)
                $0.leading.equalTo(userImageView.snp.trailing).offset(Spacing.large)
            }
            $0.font = UIFont(name: FNames.regular, size: 19)
            $0.numberOfLines = 0
        }


    }

}
