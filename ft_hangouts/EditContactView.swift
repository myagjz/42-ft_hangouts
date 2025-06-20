//
//  EditContactView.swift
//  ft_hangouts
//
//  Created by Mustafa YAĞIZ on 20.06.2025.
//

import SwiftUI

struct EditContactView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var contact: Contact

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var email: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Contact Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    TextField("Notes", text: $notes)
                }

                Button("Save Changes") {
                    updateContact()
                }
            }
            .navigationTitle("Edit Contact")
            .onAppear {
                self.firstName = contact.firstName ?? ""
                self.lastName = contact.lastName ?? ""
                self.phoneNumber = contact.phoneNumber ?? ""
                self.email = contact.email ?? ""
                self.notes = contact.notes ?? ""
            }
        }
    }
    
    private func updateContact() {
        withAnimation {
            contact.firstName = firstName
            contact.lastName = lastName
            contact.phoneNumber = phoneNumber
            contact.email = email
            contact.notes = notes

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
