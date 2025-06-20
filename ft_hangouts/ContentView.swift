//
//  ContentView.swift
//  ft_hangouts
//
//  Created by Mustafa YAĞIZ on 20.06.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Contact.firstName, ascending: true)],
        animation: .default)
    private var contacts: FetchedResults<Contact>

    @AppStorage("headerColorName") private var headerColorName: String = "blue"

    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    private var selectedColor: Color {
        switch headerColorName {
        case "blue":
            return .blue
        case "green":
            return .green
        case "red":
            return .red
        case "black":
            return .black
        default:
            return .blue
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            NavigationStack {
                List {
                    ForEach(contacts) { contact in
                        NavigationLink(destination: ContactDetailView(contact: contact)) {
                            VStack(alignment: .leading) {
                                Text("\(contact.firstName ?? "Unnamed") \(contact.lastName ?? "")")
                                    .font(.headline)
                                Text(contact.phoneNumber ?? "No Number")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteContact)
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddContactView()) {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            Button("Blue") { headerColorName = "blue" }
                            Button("Green") { headerColorName = "green" }
                            Button("Red") { headerColorName = "red" }
                            Button("Black") { headerColorName = "black" }
                        } label: {
                            Image(systemName: "paintbrush.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
                .toolbarBackground(selectedColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
            
            if showToast {
                Text(toastMessage)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("showBackgroundTimeToast"))) { notification in
            if let date = notification.object as? Date {
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .medium
                toastMessage = "Last seen format: \(formatter.string(from: date))"
                withAnimation {
                    showToast = true
                }
            }
        }
    }

    private func deleteContact(offsets: IndexSet) {
        withAnimation {
            offsets.map { contacts[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Hata: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
