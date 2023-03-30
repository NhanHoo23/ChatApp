//
//  LoadingViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK
import FirebaseAuth

//MARK: Init and Variables
class ConversationsViewController: UIViewController {

    //Variables
    let titleLb = UILabel()
    let composeBt = UIButton()
    let tableView = UITableView()
    let noConversationsLb = UILabel()
    
}

//MARK: Lifecycle
extension ConversationsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension ConversationsViewController {
    private func setupView() {
        view.backgroundColor = Colors.mainBackgroundColor
        
        let headerView = UIView()
        headerView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(topSafe)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
        }
        
        titleLb >>> headerView >>> {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            $0.text = "Chats"
            $0.textColor = Colors.textColor
            $0.font = UIFont(name: FNames.medium, size: 18)
        }
        
        composeBt >>> headerView >>> {
            $0.snp.makeConstraints {
                $0.trailing.top.bottom.equalToSuperview()
                $0.width.equalTo(composeBt.snp.height).multipliedBy(1)
            }
            $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            $0.tintColor = .link
            $0.contentEdgeInsets = UIEdgeInsets(top: Spacing.large, left: Spacing.large, bottom: Spacing.large, right: Spacing.large)
            $0.handle {
                self.didTapComposeButton()
            }
        }
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            $0.isHidden = true
            $0.delegate = self
            $0.dataSource = self
            $0.registerReusedCell(ConversationTableViewCell.self)
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
        }
        
        noConversationsLb >>> view >>> {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            $0.font = UIFont(name: FNames.medium, size: 22)
            $0.text = "No Conversations"
            $0.textColor = .gray
            $0.isHidden = true
        }
    }
}


//MARK: Functions
extension ConversationsViewController {
    func fetchConversations() {
        self.tableView.isHidden = false
    }
    
    @objc func didTapComposeButton() {
        let vc = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        
        present(navVC, animated: true)
        
        vc.completion = {[weak self] result in
            print("⭐️ result: \(result)")
            self?.createNewConversation(result: result)
        }
    }
    
    func createNewConversation(result: [String: String]) {
        guard let name = result["name"], let email = result["email"] else {
            return
        }

        let vc = ChatViewController(email: email)
        vc.isNewConversation = true
        vc.title = name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Delegate
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: ConversationTableViewCell.self, indexPath: indexPath)
        cell.configsCell()
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController(email: "asdfasdf")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
