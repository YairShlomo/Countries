//
//  CountriesViewController.swift
//  Countries
//
//  Created by Yair Shlomo on 01/12/2020.
//  Copyright © 2020 Yair Shlomo. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    let myPickerData : [String] = ["By Name - Asc", "By Name - Des", "By Area Size - Asc", "By Area Size - Des"]
    
    var countryManager = CountryManager()
    var countries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Countries"
        countryManager.fetchCountries { [weak self] (countries) in
            self?.countries = countries
        }
        initPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Countries"
    }
    
    //init picker view and set toolbar
    func initPickerView() {
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: tableView.frame.width, height: 250))
        picker.backgroundColor = UIColor.white
        textField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
    
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputView = picker
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePicker() {
        textField.resignFirstResponder()
        switch textField.text {
        case myPickerData[0]:
            countries.sort(by: { $0.name < $1.name })
        case myPickerData[1]:
            countries.sort(by: { $0.name > $1.name })
        case myPickerData[2]:
            countries.sort(by: { $0.area ?? 0 < $1.area ?? 0 })
        case myPickerData[3]:
            countries.sort(by: { $0.area ?? 0 > $1.area ?? 0 })
        default:
            print("No Choice has been made")
        }
    }
    
    @objc func cancelPicker() {
        textField.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryTableViewCell
        cell.name.text = countries[indexPath.row].name
        cell.nativeName.text = countries[indexPath.row].nativeName
        return cell
    }
    
    //MARK - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let bordersViewController = storyBoard.instantiateViewController(withIdentifier: "BordersViewController") as! BordersViewController
        let borders = countries[indexPath.row].borders
        bordersViewController.codes = borders
        bordersViewController.parentCountry = countries[indexPath.row].name
        
        self.navigationController?.pushViewController(bordersViewController, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK - UIPicker view Delegate && DataSource methods

extension CountryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = myPickerData[row]
    }
        
}
