//
//  AddContactView.swift
//  ft_hangouts
//
//  Created by Mustafa YAĞIZ on 20.06.2025.
//

import SwiftUI

struct AddContactView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Notes", text: $notes)
                }

                Button("Save") {
                    addContact()
                }
            }
            .navigationTitle("New Contact")
        }
    }
    
    private func addContact() {
        withAnimation {
            let newContact = Contact(context: viewContext)
            newContact.firstName = firstName
            newContact.lastName = lastName
            newContact.phoneNumber = phoneNumber
            newContact.email = email
            newContact.notes = notes
            newContact.createdAt = Date()

            do {
                try viewContext.save()
                // Kaydettikten sonra bir önceki ekrana dön
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
