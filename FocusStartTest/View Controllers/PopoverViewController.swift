//
//  PopoverViewController.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

protocol PopoverViewControllerDelegate: class {
    func valueDidChange(_ value: String?)
    func popoverViewControllerDidDisappear()
}

class PopoverViewController: UIViewController {
    // MARK: ... IBOutlets
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: ... Private proprties
    private let data: [String]
    private var currentValue: String?
    
    // MARK: ... Proprties
    weak var delegate: PopoverViewControllerDelegate?
    
    // MARK: ... Initialization
    init?(coder: NSCoder, data: [String], currentValue: String? = nil) {
        self.data = data
        self.currentValue = currentValue
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ... Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentValue = currentValue,
            let row = data.firstIndex(where: { $0 == currentValue }) {
            pickerView.selectRow(row, inComponent: 0, animated: false)
        } else {
            delegate?.valueDidChange(data.first)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate?.popoverViewControllerDidDisappear()
    }
    
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension PopoverViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.valueDidChange(data[row])
    }
    
}
