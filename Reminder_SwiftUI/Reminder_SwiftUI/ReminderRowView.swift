//
//  ReminderRowView.swift
//  Reminder_SwiftUI
//
//  Created by Артём on 16.05.2025.
//

import SwiftUI

struct ReminderRow: View {
    @ObservedObject var store: ReminderStore
    let reminder: Reminder
    
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?
    
    var body: some View {
        HStack {
            Image(systemName: reminder.category.icon)
                .foregroundStyle(reminder.category.color)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                    .strikethrough(reminder.isCompleted)
                    .foregroundStyle(reminder.isCompleted ? .gray : .primary)
                
                HStack {
                    Label(reminder.priority.name, systemImage: reminder.priority.icon)
                        .font(.caption)
                        .foregroundStyle(reminder.priority.color)
                    
                    Spacer()
                    
                    Group {
                        if reminder.isCompleted {
                            Text("Completed")
                        } else if timeRemaining == 0 {
                            Text("Still not completed!")
                        } else {
                            Text(reminder.dueDate, style: .relative)
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(reminder.isCompleted ? .green : timeRemaining == 0 ? .red : .secondary)
                    .onAppear(perform: startTimer)
                    .onDisappear { timer?.invalidate() }
                }
            }
            
            Spacer()
            
            Button {
                store.toggleCompletion(for: reminder)
            } label: {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(reminder.isCompleted ? .green : .gray)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func startTimer() {
        updateTimeRemaining()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateTimeRemaining()
        }
    }
    
    private func updateTimeRemaining() {
        let diff = Int(reminder.dueDate.timeIntervalSinceNow)
        timeRemaining = max(diff, 0)
        
        if timeRemaining == 0 {
            timer?.invalidate()
        }
    }
}
