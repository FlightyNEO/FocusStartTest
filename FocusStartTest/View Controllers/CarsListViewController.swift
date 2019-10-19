//
//  CarsListViewController.swift
//  FocusStartTest
//
//  Created by Arkadiy Grigoryanc on 18.10.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit

class CarsListViewController: UITableViewController {
    
    // MARK: ... IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: ... Private properties
    private let configurator = TableViewCellConfigurator()
    private var cars = Cars()
    private var searchedCars = Cars()
    
    private var editingIndexPath: IndexPath?
    private var mode: Mode?
    
    private enum Mode {
        case edit, add, show
        
        var identifier: String {
            switch self {
            case .edit: return "EditCarIdentifier"
            case .add: return "AddCarIdentifier"
            case .show: return "ShowCarIdentifier"
            }
        }
    }
    
    private var isSearchResult: Bool {
        guard let text = searchBar.text else { return false }
        return !text.isEmpty
    }
    
    // MARK: ... Life cicle
    override func viewDidLoad() {
        navigationItem.title = cars.title
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        fetchCars()
        
    }
    
    // MARK: ... Private methods
    private func fetchCars() {
        guard let cars = try? DataManager.fetchCars() else { return }
        self.cars = cars
    }
    
    private func fillDetailController(_ controller: CarDetailViewController, car: Car?, title: String?, isEditable: Bool) {
        controller.car = car
        controller.title = title ?? car?.manufacturer
        controller.isEditable = isEditable
    }
    
    private func changeVisualizationSearchBar() {
        searchBar.showsScopeBar.toggle()
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(searchBar.showsScopeBar, animated: true)
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func search(_ searchText: String?, selectedScope: Int) {
        guard let searchText = searchText else { return }
        
        var searched = Cars()
        
        switch selectedScope {
        
        case 0: // SEARCH OF MANUFACTURER
            
            searched = cars.filter { $0.manufacturer.lowercased().contains(searchText.lowercased()) }
            
        case 1: // SEARCH OF ALL FIELDS
            
            searched = cars.filter {
                let text = searchText.lowercased()
                return
                    $0.manufacturer.lowercased().contains(text) ||
                    $0.model.lowercased().contains(text) ||
                    $0.description.lowercased().contains(text) ||
                    String($0.yearOfIssue).contains(text)
                
            }
            
        default: break
            
        }
        
        searchedCars = searched
        tableView.reloadData()
        
    }
    
}

// MARK: - Tble view data source & delegate
extension CarsListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearchResult ? searchedCars.count : cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let car = isSearchResult ? searchedCars[indexPath.row] : cars[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CarCell.reusableIdentifier) as! CarCell
        
        configurator.configure(cell, with: car)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            
            self.editingIndexPath = indexPath
            self.performSegue(withIdentifier: Mode.edit.identifier, sender: indexPath.row)
            
        }
        editAction.backgroundColor = .systemOrange
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            if self.isSearchResult {
                let deletedCar = self.searchedCars[indexPath.row]
                guard let index = self.cars.firstIndex(of: deletedCar) else { return }
                self.searchedCars.remove(at: indexPath.row)   // remove "car" from searched array
                self.cars.remove(at: index)   // remove "car" from head array
            } else {
                self.cars.remove(at: indexPath.row)   // remove "car" from head array
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            try? DataManager.reWriteCars(self.cars)
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.editingIndexPath = indexPath
        searchBar.resignFirstResponder()
    }
}

// MARK: - Navigation
extension CarsListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let carDetailViewController = segue.destination as? CarDetailViewController {
            
            searchBar.resignFirstResponder()
            
            carDetailViewController.delegate = self
            
            switch segue.identifier {
            case Mode.edit.identifier:
                guard let row = sender as? Int else { return }
                let car = isSearchResult ? searchedCars[row] : cars[row]
                fillDetailController(carDetailViewController, car: car, title: "Edit", isEditable: true)
                mode = .edit
            case Mode.add.identifier:
                fillDetailController(carDetailViewController, car: nil, title: "Add new car", isEditable: true)
                mode = .add
            case Mode.show.identifier:
                guard let row = tableView.indexPathForSelectedRow?.row else { return }
                let car = isSearchResult ? searchedCars[row] : cars[row]
                fillDetailController(carDetailViewController, car: car, title: nil, isEditable: false)
                mode = .show
            default: break
            }
            
        }
        
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        self.editingIndexPath = nil
        self.mode = nil
    }
    
}

// MARK: - Car detail view controller delegate
extension CarsListViewController: CarDetailViewControllerDelegate {
    
    func didUpdateCar(_ car: Car) {
        
        guard let mode = mode else { return }
        
        switch mode {
        case .add:
            
            let indexOfCars = cars.insert(car, by: <)
            
            if isSearchResult {
                searchBar.text = nil
                tableView.reloadData()
            } else {
                let indexPath = IndexPath(row: indexOfCars, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        case .edit, .show:
            
            guard let editingIndexPath = editingIndexPath else { return }
            
            if isSearchResult {
                let modifiedCar = searchedCars[editingIndexPath.row]
                guard let index = cars.firstIndex(of: modifiedCar) else { return }
                
                if cars[index].manufacturer == car.manufacturer {
                    cars[index] = car
                } else {
                    cars.remove(at: index)
                    _ = cars.insert(car, by: <)
                }
                
                searchBar.text = nil
                tableView.reloadData()
            } else {
                if cars[editingIndexPath.row].manufacturer == car.manufacturer {
                    cars[editingIndexPath.row] = car
                    tableView.reloadRows(at: [editingIndexPath], with: .automatic)
                } else {
                    cars.remove(at: editingIndexPath.row)
                    let indexOfCars = cars.insert(car, by: <)
                    let indexPath = IndexPath(row: indexOfCars, section: 0)
                    tableView.reloadRows(at: [editingIndexPath, indexPath], with: .automatic)
                }
            }
            
        }
        
        try? DataManager.reWriteCars(cars)
        
    }
    
}

// MARK: - Search bar delegate
extension CarsListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        changeVisualizationSearchBar()
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        changeVisualizationSearchBar()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText, selectedScope: searchBar.selectedScopeButtonIndex)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        search(searchBar.searchTextField.text, selectedScope: selectedScope)
    }
    
}
