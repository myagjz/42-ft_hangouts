//
//  ConversationView.swift
//  ft_hangouts
//
//  Created by Mustafa YAĞIZ on 20.06.2025.
//

import SwiftUI
import CoreData

struct ChatBubble: Shape {
    var isFromUser: Bool
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [
                                    .topLeft,
                                    .topRight,
                                    isFromUser ? .bottomLeft : .bottomRight
                                ],
                                cornerRadii: CGSize(width: 16, height: 16))
        return Path(path.cgPath)
    }
}

struct ConversationView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var contact: Contact

    private var messages: [Message] {
        let sortDescriptor = NSSortDescriptor(keyPath: \Message.timestamp, ascending: true)
        return (contact.messages?.sortedArray(using: [sortDescriptor]) as? [Message]) ?? []
    }

    @State private var newMessageText: String = ""

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(messages, id: \.id) { message in
                        HStack {
                            if !message.isFromUser {
                                Spacer()
                            }
                            
                            Text(message.text ?? "")
                                .padding()
                                .background(message.isFromUser ? Color.blue : Color.gray.opacity(0.4))
                                .foregroundColor(message.isFromUser ? .white : .black)
                                .clipShape(ChatBubble(isFromUser: message.isFromUser))
                                .frame(maxWidth: 300, alignment: message.isFromUser ? .leading : .trailing)

                            if message.isFromUser {
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .scaleEffect(x: 1, y: -1, anchor: .center)
                    }
                }
            }
            .scaleEffect(x: 1, y: -1, anchor: .center)

            HStack {
                TextField("Type your message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.largeTitle)
                }
                .padding(.trailing)
                .disabled(newMessageText.isEmpty)
            }
        }
        .navigationTitle("\(contact.firstName ?? "Mesaj")")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendMessage() {

        let userMessage = Message(context: viewContext)
        userMessage.id = UUID()
        userMessage.text = newMessageText
        userMessage.timestamp = Date()
        userMessage.isFromUser = true
        userMessage.contact = contact

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let replyMessage = Message(context: viewContext)
            replyMessage.id = UUID()
            replyMessage.text = "Merhaba! 🤙"
            replyMessage.timestamp = Date()
            replyMessage.isFromUser = false
            replyMessage.contact = contact
            saveContext()
        }

        newMessageText = ""
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
