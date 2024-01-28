//
//  InputMsgView.swift
//  TestMessageList
//
//  Created by Ihor Andriushchenko on 27.01.2024.
//

import UIKit

class InputMsgView: UIView {
    @IBOutlet var textView: UITextView!
    @IBOutlet var submitButton: UIButton!
    
    var onSubmit: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
    
    private func setupTextView() {
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        textView.resignFirstResponder()

        if let text = textView.text, !text.isEmpty {
            onSubmit?(text)
            textView.text = ""
        }
    }
}
