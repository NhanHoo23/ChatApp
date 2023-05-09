//
//  PhotoViewerViewController.swift
//  ChatApp
//
//  Created by NhanHoo23 on 24/03/2023.
//

import MTSDK
import SDWebImage

//MARK: Init and Variables
class PhotoViewerViewController: UIViewController {
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    init(with url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }

    //Variables
    let imageView = UIImageView()
    
    var url: URL!
    
}

//MARK: Lifecycle
extension PhotoViewerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

//MARK: SetupView
extension PhotoViewerViewController {
    private func setupView() {
        imageView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.contentMode = .scaleAspectFit
            guard let url = self.url else {
                return
            }

            $0.sd_setImage(with: url)
        }

    }
}


//MARK: Functions
extension PhotoViewerViewController {

}
