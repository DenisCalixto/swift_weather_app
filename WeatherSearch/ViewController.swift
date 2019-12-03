//
//  ViewController.swift
//  WeatherSearch
//
//  Created by Colin Masters on 2019-12-02.
//  Copyright © 2019 Langara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var weatherSearchService: WeatherSearchService?
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private var isSearching = false
    private var forecast: Forecast?
    private var overview = [Overview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.isHidden = true
        weatherSearchService = WeatherSearchService(delegate: self)
        activityIndicator.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2)
        view.addSubview(activityIndicator)
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isEditing = strongSelf.isSearching
            //strongSelf.activityIndicator.isHidden = !strongSelf.isSearching
            strongSelf.isSearching ? self?.activityIndicator.startAnimating() : strongSelf.activityIndicator.stopAnimating()
            strongSelf.tableView.reloadData()
        }
        isSearching = !isSearching
    }
}

extension ViewController: WeatherSearchDelegate {
    func requestFailed(with error: APIError) {
        updateView()
    }
    
    func searchCompleted(with forecast: Forecast) {
        self.forecast = forecast
        if let overview = forecast.list {
            self.overview = overview
        }
        updateView()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        let item = overview[indexPath.row]
        cell.textLabel?.text = "\(item.main?.temp ?? 0)"
        cell.detailTextLabel?.text = item.weather?.first?.description
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            DispatchQueue.main.async {
                //self.tableView.isHidden = true
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        updateView()
        weatherSearchService?.dailyForecast(searchCity: query, searchCountry: "CA")
    }
}

