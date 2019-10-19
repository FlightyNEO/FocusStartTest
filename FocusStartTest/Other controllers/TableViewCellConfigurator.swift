//
//  TableViewCellConfigurator.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

class TableViewCellConfigurator {
    func configure(_ cell: CarCell, with car: Car) {
        cell.manufacturerLabel.text = car.manufacturer
        cell.modelLabel.text = "Model: \(car.model)"
        cell.descriptionLabel.text = car.description
        cell.bodyTypeLabel.text = "Body type: \(car.bodyType.rawValue)"
        cell.yearOfIssueLabel.text = "Year of issue: \(car.yearOfIssue)"
    }
}
