//
//  CustomInputView.swift
//  TestMessageList
//
//  Created by Ihor Andriushchenko on 27.01.2024.
//

import UIKit

class CustomInputView: UIView {
    @IBOutlet var textField: UITextField!
    @IBOutlet var submitButton: UIButton!

    var onSubmit: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        guard let view = Bundle.main.loadNibNamed("CustomInputView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        addSubview(view)
    }

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if let text = textField.text, !text.isEmpty {
            onSubmit?(text)
            textField.text = ""
        }
    }
}
