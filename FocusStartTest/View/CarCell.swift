//
//  CarCell.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {
    
    static let reusableIdentifier = "CarCell"
    
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bodyTypeLabel: UILabel!
    @IBOutlet weak var yearOfIssueLabel: UILabel!
    
}
