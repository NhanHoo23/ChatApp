//
//  UserTableViewCell.swift
//  ChatApp
//
//  Created by NhanHoo23 on 29/03/2023.
//

import MTSDK

class UserTableViewCell: UITableViewCell {
    
    
    //Variables
    var containerView: UIView!
    private let userImageView = UIImageView()
    private let userNameLb = UILabel()
}


//MARK: Functions
extension UserTableViewCell {
    func configsCell(user: SearchResult) {
        if containerView == nil {
            self.setupView()
        }
        self.userNameLb.text = user.name
        let path = "images/\(user.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url)
                }
            case .failure(let error):
                print("⭐️ Failed to get image \(error)")
            }
        })
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        containerView = UIView()
        containerView >>> contentView >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
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
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(userImageView.snp.trailing).offset(Spacing.large)
            }
            $0.font = UIFont(name: FNames.medium, size: 21)
        }

    }

}
