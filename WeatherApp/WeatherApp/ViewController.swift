//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/8/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchWeatherDelegate {
    
    let viewBusiness = ViewBusiness()
    var histories: [String] = []
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBusiness.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTableView.reloadData()
    }
    
    // MARK : UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isFirstResponder {
            let historiesCount = histories.count > maxHistoryNumber ? maxHistoryNumber : histories.count
            return historiesCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = histories[indexPath.row]
        return cell
    }
    
    // MARK : UISearchBarDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK : UISearchBarDelegate
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        histories = viewBusiness.getSearchHistories()
        historyTableView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            viewBusiness.searchWeather(query: query)
        }
    }
    
    // MARK: - Navigation
    func searchWeatherSuccess(weatherResponse: WeatherResponse) {
        if let query = weatherResponse.data?.request?.first?.query {
            viewBusiness.saveSearchHistory(query: query)
        }
        performSegue(withIdentifier: "ShowDetailView", sender: weatherResponse)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailView",
            let detailView = segue.destination as? DetailViewController,
            let weather = sender as? WeatherResponse {
            detailView.weather = weather
        }
    }
    
}
