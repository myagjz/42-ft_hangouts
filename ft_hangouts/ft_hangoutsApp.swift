//
//  ft_hangoutsApp.swift
//  ft_hangouts
//
//  Created by Mustafa YAĞIZ on 20.06.2025.
//

import SwiftUI

@main
struct ft_hangoutsApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background {
                UserDefaults.standard.set(Date(), forKey: "backgroundTime")
            }

            if newValue == .active {
                // Kayıtlı zamanı al
                if let backgroundDate = UserDefaults.standard.object(forKey: "backgroundTime") as? Date {

                    NotificationCenter.default.post(
                        name: NSNotification.Name("showBackgroundTimeToast"),
                        object: backgroundDate
                    )
                    UserDefaults.standard.removeObject(forKey: "backgroundTime")
                }
            }
        }
    }
}
