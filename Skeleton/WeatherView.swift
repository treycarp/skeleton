//
//  WeatherView.swift
//  Skeleton
//
//  Created by Trey Carpenter on 1/13/25.
//

import SwiftUI

struct WeatherView: View {
    
    @State private var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Image(systemName: viewModel.currentWeatherImageName())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100, maxHeight: 100)
                .foregroundColor(viewModel.currentWeatherImageColor())
                .padding(.bottom, 10)
            
            Text("\(viewModel.temperature())")
                .fontWeight(.thin)
                .font(.custom("HelveticaNeue-Light", size: 50))
                .padding(.bottom, 50)
            
            Toggle(viewModel.toggleTempText(), isOn: $viewModel.celsiusSelected)
                .toggleStyle(.button)
                .padding(.bottom, 100)
            
            Button {
                Task {
                    await viewModel.refreshWeather()
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
        }
        .onAppear {
            Task {
                await viewModel.refreshWeather()
            }
        }
    }
    
    init(viewModel: WeatherViewModel = WeatherViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    WeatherView()
}

/// The view model for the Weather View
@Observable
class WeatherViewModel {
    
    private let weatherService: WeatherServicing
    private var currentWeather: Weather?
    
    var celsiusSelected = false
    
    init(weatherService: WeatherServicing = WeatherService()) {
        self.weatherService = weatherService
    }
    
    /// Retrieves the latest weather from `WeatherService`
    func refreshWeather() async {
        currentWeather = await weatherService.fetchWeather()
    }
    
    /// Returns the temperature based on which temp is currently selected.
    /// - Returns: `String` of the Celsisus/Fahrenheit temp with degree symbol and temp symbol
    func temperature() -> String {
        guard let currentWeather else { return "Unknown" }
        return "\(celsiusSelected ? "\(convertTempToCelsius())° C" : "\(currentWeather.farhrenheitTemperature)° F")"
    }
    
    /// Toggles the change temp button to the appropriate text
    /// - Returns: `String` of the button text
    func toggleTempText() -> String {
        return celsiusSelected ? "Show Fahrenheit" : "Show Celsius"
    }
    
    /// Converts Farenheit temperature to Celsius
    /// - Returns: `Int` representing the temperature in Celsius
    private func convertTempToCelsius() -> Int {
        guard let currentWeather else { return 0 }
        return ((currentWeather.farhrenheitTemperature - 32) * 5) / 9
    }
    
    /// Determines the appropriate image based on the current weather
    /// - Returns: `String` of the  `SFSymbol` system image name
    func currentWeatherImageName() -> String {
        switch currentWeather?.weather {
        case .sunny: return "sun.max"
        case .cloudy: return "cloud"
        case .partlyCloudy: return "sun.min"
        case .rain: return "cloud.rain"
        case .snow: return "cloud.snow"
        default: return "sun.max.trianglebadge.exclamationmark"
        }
    }
    
    /// Determines the appropriate color for the weather image based on the current weather
    /// - Returns: `Color` for the current weather
    func currentWeatherImageColor() -> Color {
        switch currentWeather?.weather {
        case .sunny: return .yellow
        case .cloudy, .partlyCloudy, .rain, .snow: return .gray
        default: return .red
        }
    }
}

// MARK: - Data Models


struct Weather {
    let farhrenheitTemperature: Int
    let weather: WeatherType
}

enum WeatherType: CaseIterable {
    case sunny
    case cloudy
    case partlyCloudy
    case rain
    case snow
    case unknown
}

// MARK: - Service

protocol WeatherServicing {
    func fetchWeather() async -> Weather
}

class WeatherService: WeatherServicing {
    let weathers = WeatherType.allCases.filter { $0 != .unknown }
    
    func fetchWeather() async -> Weather {
        sleep(1) // this mimics async server stuff happening
        let temp = Int.random(in: -10...112)
        return Weather(farhrenheitTemperature: temp, weather: temp < 32 ? weathers.filter  { $0 != .rain }.randomElement()! : weathers.filter  { $0 != .snow }.randomElement()!)
    }
}



