//
//  PickerField.swift
//  neggu
//
//  Created by 유지호 on 1/21/25.
//

import SwiftUI

public struct PickerField: UIViewRepresentable {
    // MARK: - Public properties
    @Binding var selectionIndex: Int

    // MARK: - Initializers
    public init<S>(_ title: S, data: [String], selectionIndex: Binding<Int>) where S: StringProtocol {
        self.placeholder = String(title)
        self.data = data
        self._selectionIndex = selectionIndex

        textField = PickerTextField(data: data, selectionIndex: selectionIndex)
    }

    // MARK: - Public methods
    public func makeUIView(context: UIViewRepresentableContext<PickerField>) -> UITextField {
        textField.placeholder = placeholder
        textField.textAlignment = .center
        textField.textColor = .init(.labelNormal)
        textField.font = .init(name: "Pretendard-Bold", size: 20)
        return textField
    }

    public func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<PickerField>) {
        uiView.text = data[selectionIndex]
    }

    // MARK: - Private properties
    private var placeholder: String
    private var data: [String]
    private let textField: PickerTextField
}

final class PickerTextField: UITextField {
    // MARK: - Public properties
    var data: [String]
    @Binding var selectionIndex: Int

    // MARK: - Initializers
    init(data: [String], selectionIndex: Binding<Int>) {
        self.data = data
        self._selectionIndex = selectionIndex
        super.init(frame: .zero)

        self.inputView = pickerView
        self.inputAccessoryView = toolbar
        self.tintColor = .clear
        self.pickerView.selectRow(selectionIndex.wrappedValue, inComponent: 0, animated: true)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(donePressed)
        )

        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.tintColor = .init(.negguSecondary)
        toolbar.sizeToFit()
        return toolbar
    }()

    // MARK: - Private methods
    @objc
    private func donePressed() {
        self.selectionIndex = self.pickerView.selectedRow(inComponent: 0)
        self.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate extension
extension PickerTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectionIndex = row
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        return .init(string: self.data[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray90])
//    }
    
}
