//
//  ReminderFormView.swift
//  Reminder_SwiftUI
//
//  Created by Артём on 16.05.2025.
//

import SwiftUI

struct ReminderFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var store: ReminderStore
    
    @State private var title: String
    @State private var notes: String
    @State private var dueDate: Date
    @State private var priority: Reminder.Priority
    @State private var category: Reminder.Category
    
    var reminder: Reminder?
    var isEditing: Bool
    
    init(store: ReminderStore, reminder: Reminder? = nil) {
        self.store = store
        self.reminder = reminder
        self.isEditing = reminder != nil
        
        _title = State(initialValue: reminder?.title ?? "")
        _notes = State(initialValue: reminder?.notes ?? "")
        _dueDate = State(initialValue: reminder?.dueDate ?? Date())
        _priority = State(initialValue: reminder?.priority ?? .normal)
        _category = State(initialValue: reminder?.category ?? .personal)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Reminder title", text: $title)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(Reminder.Priority.allCases, id: \.self) { priority in
                            Label(priority.name, systemImage: priority.icon)
                                .foregroundStyle(priority.color)
                                .tag(priority)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $category) {
                        ForEach(Reminder.Category.allCases, id: \.self) { category in
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundStyle(category.color)
                                Text(category.name)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle(isEditing ? "Edit reminder" : "New reminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Update" : "Add") {
                        saveReminder()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveReminder() {
        let newReminder = Reminder(
            id: reminder?.id ?? UUID(),
            title: title,
            notes: notes.isEmpty ? nil : notes,
            dueDate: dueDate,
            isCompleted: reminder?.isCompleted ?? false,
            priority: priority,
            category: category
        )
        
        if isEditing {
            store.updateReminder(newReminder)
        } else {
            store.addReminder(newReminder)
        }
    }
}

#Preview {
    ReminderFormView(store: ReminderStore())
}
