//
//  CarDetailViewController.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

protocol CarDetailViewControllerDelegate: class {
    func didUpdateCar(_ car: Car)
}

class CarDetailViewController: UITableViewController {
    
    // MARK: ... IBOutlets
    @IBOutlet weak var saveAndCancelButton: UIBarButtonItem!
    @IBOutlet weak var cancelAndBackButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var manufacturerField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var yearOfIssueLabel: UILabel!
    @IBOutlet weak var bodyTypeLabel: UILabel!
    
    @IBOutlet weak var yearOfIssueCell: UITableViewCell!
    @IBOutlet weak var bodyOfTypeCell: UITableViewCell!
    
    
    // MARK: ... Private proprties
    private enum MaxLength: Int {
        case model = 20
        case description = 150
    }
    
    private enum Mode {
        case review
        case edit(readyToSave: Bool)
    }
    
    private var mode: Mode = .review {
        didSet {
            switch mode {
            case .review:
                editButton?.title = "Edit"
                editButton.style = .plain
                editButton?.isEnabled = true
            case .edit(readyToSave: let isReady):
                editButton?.title = "Save"
                editButton?.style = isReady ? .done : .plain
                editButton?.isEnabled = isReady ? true : false
            }
        }
    }
    
    private var textFields: [UITextField] {
        guard
            manufacturerField != nil,
            modelField != nil,
            descriptionField != nil else { return [] }
        
        return [manufacturerField, modelField, descriptionField]
    }
    
    private func areFieldsReady(_ textFields: [UITextField]? = nil) -> Bool {
        for textField in textFields ?? self.textFields {
            if textField.isEmpty { return false }
        }
        return true
    }
    
    private lazy var cancelButton: UIBarButtonItem? = {
        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(actionCancel))
    }()
    
    private var yearSheetIsActive = false
    private var bodyTypeSheetIsActive = false
    
    // MARK: ... Proprties
    var car: Car!
    weak var delegate: CarDetailViewControllerDelegate?
    
    var isEditable = false {
        didSet {
            mode = isEditable ? .edit(readyToSave: true) : .review
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        if car == nil {
            car = Car()
        }
        
        setupUI()
    }
    
    // MARK: ... Private methods
    private func saveCar() {
        car.manufacturer = manufacturerField.text ?? ""
        car.model = modelField.text ?? ""
        car.description = descriptionField.text ?? ""
        car.yearOfIssue = Int(yearOfIssueLabel.text!) ?? 2000
        car.bodyType = Car.BodyType(rawValue: bodyTypeLabel.text!)!
        
        delegate?.didUpdateCar(car)
    }
    
    private func setupUI() {
        
        navigationItem.rightBarButtonItems?.removeAll { $0 == (isEditable ? editButton : saveAndCancelButton) }
        
        if isEditable {
            editButton = nil
        } else {
            cancelAndBackButton = nil
            saveAndCancelButton = nil
        }
        
        updateUI()
    }
    
    private func updateUI() {
        
        navigationItem.leftBarButtonItem = isEditable ? (cancelAndBackButton ?? cancelButton) : nil
        
        manufacturerField?.text = car.manufacturer
        modelField?.text = car.model
        descriptionField?.text = car.description
        yearOfIssueLabel?.text = String(car.yearOfIssue)
        bodyTypeLabel?.text = car.bodyType.rawValue
        
        saveAndCancelButton?.isEnabled = areFieldsReady()
        textFields.forEach { $0.isEnabled = isEditable }
        yearOfIssueCell?.isUserInteractionEnabled = isEditable
        yearOfIssueCell?.accessoryType = isEditable ? .disclosureIndicator : .none
        bodyOfTypeCell?.isUserInteractionEnabled = isEditable
        bodyOfTypeCell?.accessoryType = isEditable ? .disclosureIndicator : .none
    }
    
}

// MARK: - Navigation
extension CarDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSegue" {
            saveCar()
        }
    }
    
    @IBSegueAction func actionChangeBodyType(_ coder: NSCoder) -> PopoverViewController? {
        
        bodyTypeSheetIsActive = true
        
        let data = Car.BodyType.allCases.map { $0.rawValue }
        let popoverViewController = PopoverViewController(coder: coder, data: data, currentValue: car.bodyType.rawValue)
        popoverViewController?.delegate = self
        
        return popoverViewController
    }
    
    @IBSegueAction func actionChangeYearOfIssue(_ coder: NSCoder) -> PopoverViewController? {
        
        yearSheetIsActive = true
        
        let calendar = Calendar(identifier: .gregorian)
        let currentYear = calendar.component(.year, from: Date())
        let years = Array(1850...currentYear).map { String($0) }
        let popoverViewController = PopoverViewController(coder: coder, data: years, currentValue: String(car.yearOfIssue))
        popoverViewController?.delegate = self
        
        return popoverViewController
    }
    
}

// MARK: - Actions
extension CarDetailViewController {
    
    @objc private func actionCancel() {
        isEditable.toggle()
    }
    
    @IBAction func actionEdit(_ sender: UIBarButtonItem) {
        
        switch mode {
        case .review:
            isEditable.toggle()
            manufacturerField.becomeFirstResponder()
        case .edit:
            saveCar()
            title = manufacturerField.text
            isEditable.toggle()
        }
        
    }
    
}

// MARK: - Text field delegate
extension CarDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        switch textField {
        case manufacturerField, modelField:
            guard newString.count <= MaxLength.model.rawValue else { return false }
        case descriptionField:
            guard newString.count <= MaxLength.description.rawValue else { return false }
        default:
            break
        }
        
        // check areFieldsReady
        let textFields = self.textFields.filter { $0 != textField }
        saveAndCancelButton?.isEnabled = !newString.isEmpty && areFieldsReady(textFields)
        mode = .edit(readyToSave: !newString.isEmpty && areFieldsReady(textFields))
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let index = textFields.firstIndex(of: textField) else { return false }
            
        let nextIndex = index + 1
            
        guard nextIndex < textFields.count else {
            
            textField.resignFirstResponder()
            return true
        }
        
        textFields[nextIndex].becomeFirstResponder()
        return true
        
    }
    
}

extension CarDetailViewController: PopoverViewControllerDelegate {
    
    func valueDidChange(_ value: String?) {
        
        if yearSheetIsActive {
            yearOfIssueLabel.text = value
        } else if bodyTypeSheetIsActive {
            bodyTypeLabel.text = value
        }
        
    }
    
    func popoverViewControllerDidDisappear() {
        yearSheetIsActive = false
        bodyTypeSheetIsActive = false
    }
    
}
