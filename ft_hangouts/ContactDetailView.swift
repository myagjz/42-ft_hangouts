//
//  ContactDetailView.swift
//  ft_hangouts
//
//  Created by Mustafa YAĞIZ on 20.06.2025.
//

import SwiftUI
import MessageUI

struct ContactDetailView: View {
    @ObservedObject var contact: Contact
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("First Name: \(contact.firstName ?? "")")
                Text("Last Name: \(contact.lastName ?? "")")
                Text("Telefon: \(contact.phoneNumber ?? "")")
                Text("Email: \(contact.email ?? "")")
                Text("Notes: \(contact.notes ?? "")")
            }
            
            Section(header: Text("İletişim")) {
                NavigationLink(destination: ConversationView(contact: contact)) {
                    Label("Conversation History", systemImage: "message.fill")
                }

                Button(action: {
                    if let url = URL(string: "sms:\(contact.phoneNumber ?? "")") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Label("Send Real SMS", systemImage: "text.bubble.fill")
                }
            }
        }
        .navigationTitle("\(contact.firstName ?? "Detay")")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EditContactView(contact: contact)) {
                    Text("Edit")
                }
            }
        }
    }
    
    private func sendMessage() {
        let sms = "sms:\(contact.phoneNumber ?? "")&body=Merhaba"
        guard let stringURL = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        UIApplication.shared.open(URL(string: stringURL)!, options: [:], completionHandler: nil)
    }
}

