//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UITableViewDataSource, SearchWeatherDelegate {

    var weather: WeatherResponse?
    let viewBusiness = ViewBusiness()
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var detailWeatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBusiness.delegate = self
        
        refreshControl.addTarget(self, action: #selector(reloadWeatherData), for: .valueChanged)
        detailWeatherTableView.addSubview(refreshControl)
    }
    
    func reloadWeatherData() {
        if let query = weather?.data?.request?.first?.query {
            viewBusiness.searchWeather(query: query)
        }
    }
    
    func searchWeatherSuccess(weatherResponse: WeatherResponse) {
        weather = weatherResponse
        detailWeatherTableView.reloadData()
        refreshControl.endRefreshing()
    }

    // MARK : UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherNormalCell", for: indexPath)
        let currentCondition = weather?.data?.currentCondition?.first
        
        switch indexPath.row {
        case 0: // i) Icon Showing Current Weather and City Name
            cell.textLabel?.text = weather?.data?.request?.first?.query
            
            if let urlString = currentCondition?.weatherIconUrl?.first?.value,
                let url = URL(string: urlString) {
                cell.imageView?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "weather_icon"))
            }
        case 1: // ii) Observation Time
            cell.textLabel?.text = "Observation Time: " + (currentCondition?.observationTime ?? "")
        case 2: // iii) humidity
            cell.textLabel?.text = "Humidity: " + (currentCondition?.humidity ?? "")
        case 3: // iv) weather description
            cell.textLabel?.text = currentCondition?.weatherDesc?.first?.value
        default:
            break
        }
        return cell
    }
    
}
