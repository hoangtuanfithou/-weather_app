//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/8/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var histories: [WeatherResponse] = []
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK : UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isFirstResponder {
            return histories.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = histories[indexPath.row].city
        return cell
    }
    
    // MARK : UISearchBarDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailView", sender: histories[indexPath.row])
    }
    
    // MARK : UISearchBarDelegate
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        histories = SaveWeatherBusiness.getSearchHistories()
        historyTableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        SearchWeatherBusiness.searchWeather(query: query, callBack: { [weak self] weatherResponse in
            self?.searchWeatherSuccess(weatherResponse: weatherResponse)
        })
    }
    
    // MARK: - Navigation
    func searchWeatherSuccess(weatherResponse: WeatherResponse) {
        if let _ = weatherResponse.city {
            SaveWeatherBusiness.saveSearchHistory(weatherResponse: weatherResponse)
            performSegue(withIdentifier: "ShowDetailView", sender: weatherResponse)
        } else {
            showAlert(message: "Unable to find any matching weather location to the query submitted!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailView",
            let detailView = segue.destination as? DetailViewController,
            let weather = sender as? WeatherResponse {
            detailView.weather = weather
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
