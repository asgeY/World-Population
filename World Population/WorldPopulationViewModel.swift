//
//  WorldPopulationViewModel.swift
//  World Population
//
//  Created by AsgeY on 5/17/23.
//

import SwiftUI
import Combine
import Alamofire

struct Config {
    static let apiKey = "YOURAPIKEY"
}


class WorldPopulationViewModel: ObservableObject {
    @Published var populationCount: String = ""
    @Published var apiStatus: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var request: DataRequest?
    
    init() {
        startPolling()
    }
    
    func startPolling() {
        fetchWorldPopulation() // Fetch immediately upon starting
        
        // Schedule periodic fetches
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchWorldPopulation()
            }
            .store(in: &cancellables)
    }
    
    func fetchWorldPopulation() {
        establishConnection()
        
        request?.responseDecodable(of: PopulationResponse.self) { [weak self] response in
            switch response.result {
            case .success(let populationResponse):
                let readableFormat = populationResponse.readableFormat
                DispatchQueue.main.async {
                    self?.populationCount = readableFormat
                
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.apiStatus = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func establishConnection() {
        let url = URL(string: "https://get-population.p.rapidapi.com/population")!
        
        let headers: HTTPHeaders = [
            "X-RapidAPI-Key": Config.apiKey,
            "X-RapidAPI-Host": "get-population.p.rapidapi.com"
        ]
        
        request = AF.request(url, headers: headers)
    }
}
struct PopulationResponse: Codable {
    let count: Int
    let readableFormat: String

    enum CodingKeys: String, CodingKey {
        case count
        case readableFormat = "readable_format"
    }
}
