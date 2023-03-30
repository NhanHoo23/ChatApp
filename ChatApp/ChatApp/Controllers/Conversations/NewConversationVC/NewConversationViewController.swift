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
    let noRestulLb = UILabel()
    
    var users = [[String: String]]()
    var hasFetched = false
    var results = [[String: String]]()
    var completion: (([String: String]) -> Void)?
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
        
        noRestulLb >>> view >>> {
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            $0.text = "No Results"
            $0.isHidden = true
        }
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.isHidden = true
            $0.registerReusedCell(UserTableViewCell.self)
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
        }
    }
}


//MARK: Functions
extension NewConversationViewController {
    @objc func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    func searchUser(query: String) {
        if hasFetched {
            filterUsers(with: query)
        } else {
            DatabaseManager.shared.getAllUsers(completion: {[weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("⭐️ Failed to get users: \(error)")
                }
            })
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
        
        self.hideLoading()
        
        let results: [[String: String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            
            return name.hasPrefix(term.lowercased())
        })
        
        self.results = results
        
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.noRestulLb.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noRestulLb.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

//MARK:  TableView
extension NewConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: UserTableViewCell.self, indexPath: indexPath)
        cell.configsCell(user: results[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: {[weak self] in
            self?.completion?(targetUserData)
        })
    }
}


//MARK: Delegate
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        results.removeAll()
        self.showLoading()
        self.searchUser(query: text)
    }
}
