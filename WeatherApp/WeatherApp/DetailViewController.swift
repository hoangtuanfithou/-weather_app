//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Nguyen Hoang Tuan on 2/9/17.
//  Copyright © 2017 NHT. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UITableViewDataSource {

    var weather: WeatherResponse?
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var detailWeatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = weather?.city
        refreshControl.addTarget(self, action: #selector(reloadWeatherData), for: .valueChanged)
        detailWeatherTableView.addSubview(refreshControl)
    }
    
    func reloadWeatherData() {
        guard let query = weather?.city else {
            return
        }
        SearchWeatherBusiness.searchWeather(query: query, callBack: { [weak self] weatherResponse in
            self?.searchWeatherSuccess(weatherResponse: weatherResponse)
        })
    }
    
    func searchWeatherSuccess(weatherResponse: WeatherResponse) {
        self.weather = weatherResponse
        detailWeatherTableView.reloadData()
        refreshControl.endRefreshing()
    }

    // MARK : UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherNormalCell", for: indexPath)
        
        switch indexPath.row {
        case 0: // i) Icon Showing Current Weather and City Name
            cell.textLabel?.text = weather?.city
            
            if let urlString = weather?.weatherIconUrl,
                let url = URL(string: urlString) {
                cell.imageView?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "weather_icon"))
            }
        case 1: // ii) Observation Time
            cell.textLabel?.text = "Observation Time: " + (weather?.observationTime ?? "")
        case 2: // iii) humidity
            cell.textLabel?.text = "Humidity: " + (weather?.humidity ?? "")
        case 3: // iv) weather description
            cell.textLabel?.text = weather?.weatherDescription
        default:
            break
        }
        return cell
    }
    
}
