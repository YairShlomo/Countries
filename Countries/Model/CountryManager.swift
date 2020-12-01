//
//  CountryManager.swift
//  Countries
//
//  Created by Yair Shlomo on 01/12/2020.
//

import Foundation

struct CountryManager {
    let countryURL = "https://restcountries.eu/rest/v2"

    //feth all countries
    func fetchCountries(completionHandler: @escaping ([Country]) -> Void) {
        let urlString = countryURL + "/all"
        performRequest(with: urlString, completionHandler: completionHandler)
    }
    
    //fetch countries by code
    func fetchCountriesByCode(codes: [String], completionHandler: @escaping ([Country]) -> Void) {
        var urlString = "\(countryURL)/alpha?codes="
        for code in codes {
            urlString.append(code)
            urlString.append(";")
        }
        urlString.remove(at: urlString.index(before: urlString.endIndex))
        
        performRequest(with: urlString, completionHandler: completionHandler)
    }
    
    // any request that returns Countries
    func performRequest(with urlString: String, completionHandler: @escaping ([Country]) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let countries = try? JSONDecoder().decode([Country].self, from: safeData) {
                        completionHandler(countries)
                    }
                }
            })
            task.resume()
        }
    }
}
