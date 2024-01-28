//
//  ViewController.swift
//  TestMessageList
//
//  Created by Igor Andryushenko on 27.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var listView: CustomListView!
    var inputMsgView: InputMsgView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInputView()
        setupListView()
        setupLeyboard()
    }
    
    func setupLeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let inputViewHeight = inputMsgView.frame.height
            UIView.animate(withDuration: 0.3) { [self] in
                inputMsgView.frame.origin.y = view.frame.height - keyboardHeight - inputViewHeight
                listView.frame.size.height = view.frame.height - keyboardHeight - inputViewHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) { [self] in
            inputMsgView.frame.origin.y = view.frame.height - inputMsgView.frame.height
            listView.frame.size.height = view.frame.height - inputMsgView.frame.height
        }
    }
    
    func setupListView() {
        listView = Bundle.main.loadNibNamed("ListView", owner: self, options: nil)?.first as? CustomListView
        listView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - inputMsgView.frame.height)
        self.view.addSubview(listView)
        
        listView.viewController = self
    }
    
    func setupInputView() {
        inputMsgView = Bundle.main.loadNibNamed("InputMsgView", owner: self, options: nil)?.first as? InputMsgView
        let inputViewHeight: CGFloat = 160 
        inputMsgView.frame = CGRect(x: 0, y: view.frame.height - inputViewHeight, width: view.frame.width, height: inputViewHeight)
        self.view.addSubview(inputMsgView)
        
        inputMsgView.textView.delegate = self
        
        inputMsgView.onSubmit = { [weak self] text in
            self?.listView.items.append(Message(id: Int.random(in: 0...9999), text: text, timestamp: Int(NSDate().timeIntervalSince1970)))
            self?.listView.tableView.reloadData()
            self?.listView.scrollToBottom()

        }
    }
}


extension ViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.inputAccessoryView = nil
        textView.reloadInputViews()
        return true
    }
}

