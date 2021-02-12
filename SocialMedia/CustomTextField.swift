//
//  CustomTextField.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 08/02/2021.
//

import Foundation
import SwiftUI

struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        @State var placeHolder: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>, placeHolder: String) {
            _text = text
            self.placeHolder = placeHolder
        }

//        func textFieldDidChangeSelection(_ textField: UITextField) {
//            text = textField.text ?? "chuje muje"
//        }

    }

    @Binding var text: String
    @State var placeHolder: String
    var isFirstResponder: Bool = false

    func makeUIView(context: Context) -> UITextView {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.autocapitalizationType = .sentences
            textView.isSelectable = true
            textView.isUserInteractionEnabled = true
            textView.backgroundColor = UIColor.clear
     
            return textView
        }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, placeHolder: placeHolder)
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
