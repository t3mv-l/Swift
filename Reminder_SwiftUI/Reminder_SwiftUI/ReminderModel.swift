//
//  ReminderModel.swift
//  Reminder_SwiftUI
//
//  Created by Артём on 16.05.2025.
//

import SwiftUI

struct Reminder: Identifiable, Codable {
    var id = UUID()
    var title: String
    var notes: String?
    var dueDate: Date
    var isCompleted: Bool = false
    var priority: Priority = .normal
    var category: Category
    
    enum Priority: Int, Codable, CaseIterable {
        case low = 0
        case normal = 1
        case high = 2
        
        var name: String {
            switch self {
            case .low: return "Low"
            case .normal: return "Normal"
            case .high: return "High"
            }
        }
        
        var color: Color {
            switch self {
            case .low: return .blue
            case .normal: return .orange
            case .high: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .low: return "arrow.down.circle.fill"
            case .normal: return "equal.circle.fill"
            case .high: return "exclamationmark.circle.fill"
            }
        }
    }
    
    enum Category: String, Codable, CaseIterable {
        case personal
        case work
        case shopping
        case health
        case other
        
        var name: String {
            return self.rawValue.capitalized
        }
        
        var color: Color {
            switch self {
            case .personal: return .purple
            case .work: return .blue
            case .shopping: return .green
            case .health: return .red
            case .other: return .gray
            }
        }
        
        var icon: String {
            switch self {
            case .personal: return "person.fill"
            case .work: return "briefcase.fill"
            case .shopping: return "cart.fill"
            case .health: return "heart.fill"
            case .other: return "square.grid.2x2.fill"
            }
        }
    }
}
