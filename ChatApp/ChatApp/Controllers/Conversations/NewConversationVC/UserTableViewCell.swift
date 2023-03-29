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
}


//MARK: Functions
extension UserTableViewCell {
    func configsCell() {
        if containerView == nil {
            self.setupView()
        }
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
    }

}
