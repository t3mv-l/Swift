//
//  ContentView.swift
//  TrySwiftUI_Charts
//
//  Created by Артём on 03.09.2025.
//

import SwiftUI
import Charts

struct SalesSummary: Identifiable {
    let weekday: Date
    let sales: Int
    
    var id: Date { weekday }
}

let bostonData: [SalesSummary] = [
    .init(weekday: Date().date(2025, 9, 1), sales: 54),
    .init(weekday: Date().date(2025, 9, 2), sales: 42),
    .init(weekday: Date().date(2025, 9, 3), sales: 88),
    .init(weekday: Date().date(2025, 9, 4), sales: 49),
    .init(weekday: Date().date(2025, 9, 5), sales: 42),
    .init(weekday: Date().date(2025, 9, 6), sales: 125),
    .init(weekday: Date().date(2025, 9, 7), sales: 67)
]

let chicagoData: [SalesSummary] = [
    .init(weekday: Date().date(2025, 9, 1), sales: 73),
    .init(weekday: Date().date(2025, 9, 2), sales: 98),
    .init(weekday: Date().date(2025, 9, 3), sales: 16),
    .init(weekday: Date().date(2025, 9, 4), sales: 50),
    .init(weekday: Date().date(2025, 9, 5), sales: 24),
    .init(weekday: Date().date(2025, 9, 6), sales: 111),
    .init(weekday: Date().date(2025, 9, 7), sales: 177)
]

let houstonData: [SalesSummary] = [
    .init(weekday: Date().date(2025, 9, 1), sales: 104),
    .init(weekday: Date().date(2025, 9, 2), sales: 82),
    .init(weekday: Date().date(2025, 9, 3), sales: 19),
    .init(weekday: Date().date(2025, 9, 4), sales: 78),
    .init(weekday: Date().date(2025, 9, 5), sales: 116),
    .init(weekday: Date().date(2025, 9, 6), sales: 58),
    .init(weekday: Date().date(2025, 9, 7), sales: 133)
]

let laData: [SalesSummary] = [
    .init(weekday: Date().date(2025, 9, 1), sales: 140),
    .init(weekday: Date().date(2025, 9, 2), sales: 130),
    .init(weekday: Date().date(2025, 9, 3), sales: 120),
    .init(weekday: Date().date(2025, 9, 4), sales: 110),
    .init(weekday: Date().date(2025, 9, 5), sales: 100),
    .init(weekday: Date().date(2025, 9, 6), sales: 90),
    .init(weekday: Date().date(2025, 9, 7), sales: 80)
]

let miamiData: [SalesSummary] = [
    .init(weekday: Date().date(2025, 9, 1), sales: 10),
    .init(weekday: Date().date(2025, 9, 2), sales: 20),
    .init(weekday: Date().date(2025, 9, 3), sales: 30),
    .init(weekday: Date().date(2025, 9, 4), sales: 40),
    .init(weekday: Date().date(2025, 9, 5), sales: 50),
    .init(weekday: Date().date(2025, 9, 6), sales: 60),
    .init(weekday: Date().date(2025, 9, 7), sales: 70)
]

let nyData: [SalesSummary] = [
    .init(weekday: Date().date(2025, 9, 1), sales: 52),
    .init(weekday: Date().date(2025, 9, 2), sales: 111),
    .init(weekday: Date().date(2025, 9, 3), sales: 69),
    .init(weekday: Date().date(2025, 9, 4), sales: 124),
    .init(weekday: Date().date(2025, 9, 5), sales: 88),
    .init(weekday: Date().date(2025, 9, 6), sales: 63),
    .init(weekday: Date().date(2025, 9, 7), sales: 75)
]

let sfData: [SalesSummary] = [
    .init(weekday: Date().date(2025, 9, 1), sales: 100),
    .init(weekday: Date().date(2025, 9, 2), sales: 100),
    .init(weekday: Date().date(2025, 9, 3), sales: 100),
    .init(weekday: Date().date(2025, 9, 4), sales: 100),
    .init(weekday: Date().date(2025, 9, 5), sales: 100),
    .init(weekday: Date().date(2025, 9, 6), sales: 100),
    .init(weekday: Date().date(2025, 9, 7), sales: 100)
]

enum City {
    case boston
    case chicago
    case houston
    case losAngeles
    case miami
    case newYork
    case sanFransisco
}

struct ContentView: View {
    @State var city: City = .boston
    
    var data: [SalesSummary] {
        switch city {
        case .boston:
            return bostonData
        case .chicago:
            return chicagoData
        case .houston:
            return houstonData
        case .losAngeles:
            return laData
        case .miami:
            return miamiData
        case .newYork:
            return nyData
        case .sanFransisco:
            return sfData
        }
    }
    
    var cityText: String {
        switch city {
        case .boston:
            return "Boston: \(bostonData.reduce(0, {$0 + $1.sales}))"
        case .chicago:
            return "Chicago: \(chicagoData.reduce(0, {$0 + $1.sales}))"
        case .houston:
            return "Houston: \(houstonData.reduce(0, {$0 + $1.sales}))"
        case .losAngeles:
            return "Los Angeles: \(laData.reduce(0, {$0 + $1.sales}))"
        case .miami:
            return "Miami: \(miamiData.reduce(0, {$0 + $1.sales}))"
        case .newYork:
            return "New York: \(nyData.reduce(0, {$0 + $1.sales}))"
        case .sanFransisco:
            return "San Fransisco: \(sfData.reduce(0, {$0 + $1.sales}))"
        }
    }
    
    var cityColor: Color {
        switch city {
        case .boston:
            return .blue
        case .chicago:
            return .green
        case .houston:
            return .yellow
        case .losAngeles:
            return .purple
        case .miami:
            return .gray
        case .newYork:
            return .black
        case .sanFransisco:
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Most Sales Over The Last Week")
                .foregroundStyle(.secondary)
                
            Text(cityText)
                .font(.headline)
                .fontWeight(.bold)
            
            Picker("City", selection: $city.animation(.easeInOut)) {
                Text("B").tag(City.boston)
                Text("C").tag(City.chicago)
                Text("H").tag(City.houston)
                Text("L").tag(City.losAngeles)
                Text("M").tag(City.miami)
                Text("N").tag(City.newYork)
                Text("S").tag(City.sanFransisco)
            }
            .pickerStyle(.segmented)
            .padding(.top)
            
            ScrollView {
                Chart(data) { element in
                    AreaMark(
                        x: .value("Weekday", element.weekday, unit: .day),
                        y: .value("Sales", element.sales)
                    )
                    .foregroundStyle(cityColor)
                }
                .frame(height: 150)
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                Chart(data) { element in
                    BarMark(
                        x: .value("Weekday", element.weekday, unit: .day),
                        y: .value("Sales", element.sales)
                    )
                    .foregroundStyle(cityColor)
                }
                .frame(height: 150)
                .padding(.bottom, 40)
                
                Chart(data) { element in
                    RuleMark(y: .value("Goal", 120))
                        .foregroundStyle(.green)
                        .lineStyle(StrokeStyle(lineWidth: 3, dash: [5]))
                        .annotation(alignment: .leading) {
                            Text("Goal")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    
                    LineMark(
                        x: .value("Weekday", element.weekday, unit: .day),
                        y: .value("Sales", element.sales)
                    )
                    .foregroundStyle(cityColor)
                    
                    PointMark(
                        x: .value("Weekday", element.weekday, unit: .day),
                        y: .value("Sales", element.sales)
                    )
                    .foregroundStyle(cityColor)
                }
                .frame(height: 150)
                //.chartYScale(domain: 40...140)
                .padding(.bottom, 40)
            }
            
            HStack {
                Image(systemName: "line.diagonal")
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundStyle(.green)
                
                Text("Daily Goal")
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
            }
        }
        .padding(.all, 16)
    }
}

extension Date {
    func date(_ y: Int, _ m: Int, _ d: Int) -> Date {
        let c = DateComponents(year: y, month: m, day: d)
        return Calendar(identifier: .gregorian).date(from: c)!
    }
}

#Preview {
    ContentView()
}
