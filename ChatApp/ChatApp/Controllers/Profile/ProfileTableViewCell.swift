//
//  ProfileTableViewCell.swift
//  ChatApp
//
//  Created by NhanHoo23 on 28/03/2023.
//

import MTSDK

class ProfileTableViewCell: UITableViewCell {
    
    
    //Variables
    var containerView: UIView!
}


//MARK: Functions
extension ProfileTableViewCell {
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
    
    func setup(with viewModel: ProfileViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            self.textLabel?.textColor = .label
            self.textLabel?.textAlignment = .left
            self.selectionStyle = .none
        case .logOut:
            self.textLabel?.textColor = .red
            self.textLabel?.textAlignment = .center
        }
    }

}
