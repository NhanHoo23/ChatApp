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
    let nameLb = UILabel()
}


//MARK: Functions
extension UserTableViewCell {
    func configsCell(user: [String: String]) {
        if containerView == nil {
            self.setupView()
        }
        self.nameLb.text = user["name"]
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
        
        nameLb >>> containerView >>> {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }

    }

}
