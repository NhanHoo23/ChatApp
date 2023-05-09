//
//  TextFieldViewView.swift
//  ChatApp
//
//  Created by NhanHoo23 on 28/03/2023.
//

import MTSDK

class TextFieldView: UIView {
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    //Variables
    let textField = UITextField()
}


//MARK: SetupView
extension TextFieldView {
    private func setupView() {
        textField >>> self >>> {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(Spacing.large)
                $0.trailing.equalToSuperview().offset(-Spacing.large)
            }
            $0.autocorrectionType = .no
            $0.autocapitalizationType = .none
            $0.clearButtonMode = .whileEditing
        }
    }

}


//MARK: Functions
extension TextFieldView {
    func configTextField(backgroundColor: UIColor = Colors.textFieldColor, placeholder: String, placeholderTextColor: UIColor = Colors.placeHolderColor, returnKeyType: UIReturnKeyType = .default, isSecurity: Bool = false) {
        self.backgroundColor = backgroundColor
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor, NSAttributedString.Key.font: UIFont(name: FNames.bold, size: 16)!])
        textField.returnKeyType = returnKeyType
        textField.isSecureTextEntry = isSecurity
    }
    
    func getText() -> String {
        if let text = textField.text, !text.isEmpty {
            return text
        }
        return ""
    }
    
    func resetText() {
        textField.text = ""
    }
    
    func addTarget(_ target: Any?, action: Selector, type: UIControl.Event) {
        textField.addTarget(target, action: action, for: type)
    }
    
    func hideKeyboard() {
        textField.resignFirstResponder()
    }
    
    func showKeyboard() {
        textField.becomeFirstResponder()
    }
}
