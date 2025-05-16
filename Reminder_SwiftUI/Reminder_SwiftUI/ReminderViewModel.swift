//
//  ReminderViewModel.swift
//  Reminder_SwiftUI
//
//  Created by Артём on 16.05.2025.
//

import SwiftUI

class ReminderStore: ObservableObject {
    @Published var reminders: [Reminder] = []

    init() {
        requestNotificationPermission()
        loadReminders()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied: \(error?.localizedDescription ?? "No error info")")
            }
        }
    }
            
    func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: "SaveReminders")
        }
    }
    
    func loadReminders() {
        if let saveReminders = UserDefaults.standard.data(forKey: "SaveReminders") {
            if let decodeReminders = try? JSONDecoder().decode([Reminder].self, from: saveReminders) {
                reminders = decodeReminders
                return
            }
        }
    }
    
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        saveReminders()
        scheduleNotification(for: reminder)
    }
    
    func updateReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: {$0.id == reminder.id}) {
            reminders[index] = reminder
            saveReminders()
        }
    }
    
    func deleteReminder(at indexSet: IndexSet) {
        let remindersToDelete = indexSet.map { reminders[$0] }
        
        reminders.remove(atOffsets: indexSet)
        saveReminders()
        
        for reminder in remindersToDelete {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
        }
    }
    
    func toggleCompletion(for reminder: Reminder) {
        if let index = reminders.firstIndex(where: {$0.id == reminder.id}) {
            reminders[index].isCompleted.toggle()
            saveReminders()
        }
    }
        
    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.notes ?? ""
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminder.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

