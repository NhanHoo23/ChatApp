//
//  NewConversationViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK

//MARK: Init and Variables
class NewConversationViewController: UIViewController {

    //Variables
    let searchBar = UISearchBar()
    let tableView = UITableView()
}

//MARK: Lifecycle
extension NewConversationViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension NewConversationViewController {
    private func setupView() {
        view.backgroundColor = Colors.mainBackgroundColor
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search for user"
        searchBar.becomeFirstResponder()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done
                                                            , target: self, action: #selector(dismissSelf))
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.isHidden = true
            $0.registerReusedCell(UserTableViewCell.self)
        }
    }
}


//MARK: Functions
extension NewConversationViewController {
    @objc func dismissSelf() {
        self.dismiss(animated: true)
    }
}

//MARK: Delegate
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         
    }
}
