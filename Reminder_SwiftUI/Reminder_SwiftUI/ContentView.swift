//
//  ContentView.swift
//  Reminder_SwiftUI
//
//  Created by Артём on 15.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = ReminderStore()
    @State private var showingAddReminder = false
    @State private var selectedReminder: Reminder?
    @State private var showingFilterOptions = false
    @State private var filterCategory: Reminder.Category?
    @State private var filterCompleted = false
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    if showingFilterOptions {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Filter by:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Button {
                                    filterCategory = nil
                                    filterCompleted = false
                                } label: {
                                    Text("Clear all")
                                        .font(.subheadline)
                                        .foregroundStyle(.blue)
                                }
                            }
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(Reminder.Category.allCases, id: \.self) { category in
                                        Button {
                                            if filterCategory == category {
                                                filterCategory = nil
                                            } else {
                                                filterCategory = category
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: category.icon)
                                                Text(category.name)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(filterCategory == category ? category.color.opacity(0.3) : Color.gray.opacity(0.1))
                                            )
                                            .foregroundStyle(filterCategory == category ? category.color : .primary)
                                        }
                                    }
                                    
                                    Button {
                                        filterCompleted.toggle()
                                    } label: {
                                        HStack {
                                            Image(systemName: filterCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                                            Text("Completed")
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(filterCompleted ? Color.green.opacity(0.3) : Color.gray.opacity(0.1))
                                        )
                                        .foregroundStyle(filterCompleted ? .green : .primary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .background(Color.white.opacity(0.7))
                    }
                    
                    List {
                        ForEach(filteredReminders) { reminder in
                            ReminderRow(store: store, reminder: reminder)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedReminder = reminder
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        if let index = store.reminders.firstIndex(where: {$0.id == reminder.id}) {
                                            store.deleteReminder(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    Button {
                                        store.toggleCompletion(for: reminder)
                                    } label: {
                                        Label(reminder.isCompleted ? "Mark incomplete" : "Mark complete", systemImage: reminder.isCompleted ? "circle" : "checkmark.circle")
                                    }
                                    .tint(reminder.isCompleted ? .orange : .green)
                                }
                        }
                        .listRowBackground(Color.white.opacity(0.7))
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingFilterOptions.toggle()
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle\(showingFilterOptions ? ".fill" : "")")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddReminder = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                ReminderFormView(store: store)
            }
            .sheet(item: $selectedReminder) { reminder in
                ReminderFormView(store: store, reminder: reminder)
            }
        }
    }
    
    var filteredReminders: [Reminder] {
        store.reminders.filter { reminder in
            let categoryMatch = filterCategory == nil || reminder.category == filterCategory
            let completionMatch = !filterCompleted || reminder.isCompleted
            return categoryMatch && completionMatch
        }
        .sorted(by: {$0.dueDate < $1.dueDate})
    }
}
