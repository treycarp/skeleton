//
//  WeatherViewModelTests.swift
//  SkeletonTests
//
//  Created by Trey Carpenter Iii on 1/13/25.
//

import Testing
@testable import Skeleton

struct WeatherViewModelTests {
    
    let weatherService: MockWeatherService
    
    init() {
        weatherService = MockWeatherService(weather: Weather(farhrenheitTemperature: 32, weather: .sunny))
    }
    
    @Test("Celsius Temperature")
    func when_celsius_is_toggled_show_celsius() async throws {
        let viewModel = WeatherViewModel(weatherService: weatherService)
        viewModel.celsiusSelected = true
    
        await viewModel.refreshWeather()
        
        #expect(viewModel.temperature() == "0° C")
    }
    
    @Test("Fahrenheit Temperature")
    func default_fahrenheit() async throws {
        let viewModel = WeatherViewModel(weatherService: weatherService)
        
        await viewModel.refreshWeather()
        
        #expect(viewModel.celsiusSelected == false)
        #expect(viewModel.temperature() == "32° F")
    }
    
    @Test("Sunny Weather Image")
    func sunny_weather_image() async throws {
        let viewModel = WeatherViewModel(weatherService: weatherService)
        weatherService.weather = Weather(farhrenheitTemperature: 0, weather: .sunny)
        await viewModel.refreshWeather()
        
        #expect(viewModel.currentWeatherImageName() == "sun.max")
    }
    
    @Test("Cloudy Weather Image")
    func cloudy_weather_image() async throws {
        let viewModel = WeatherViewModel(weatherService: weatherService)
        weatherService.weather = Weather(farhrenheitTemperature: 0, weather: .cloudy)
        await viewModel.refreshWeather()
        
        #expect(viewModel.currentWeatherImageName() == "cloud")
    }
    
    @Test("Partly Cloudy Weather Image")
    func partly_cloudy_weather_image() async throws {
        let viewModel = WeatherViewModel(weatherService: weatherService)
        weatherService.weather = Weather(farhrenheitTemperature: 0, weather: .partlyCloudy)
        await viewModel.refreshWeather()
        
        #expect(viewModel.currentWeatherImageName() == "cloud.sun")
    }
    
}

class MockWeatherService: WeatherServicing {
    
    var weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    func fetchWeather() async -> Weather {
        return weather
    }
}
