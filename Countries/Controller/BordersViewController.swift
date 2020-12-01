//
//  BordersViewController.swift
//  Countries
//
//  Created by Yair Shlomo on 01/12/2020.
//  Copyright © 2020 Yair Shlomo. All rights reserved.
//

import UIKit

class BordersViewController: UITableViewController {
    var countryManager = CountryManager()
    var parentCountry : String = ""
    var codes = [String]()
    var borders = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        self.navigationItem.title = "Borders of \(parentCountry)"
        self.navigationController?.navigationBar.topItem?.title = ""

        countryManager.fetchCountriesByCode(codes: codes) { [weak self] (countries) in
            self?.borders = countries
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return borders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BorderCell", for: indexPath) as! BorderTableViewCell
        cell.name.text = borders[indexPath.row].name
        cell.nativeName.text = borders[indexPath.row].nativeName
        return cell
    }
    
    //MARK - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


