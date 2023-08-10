//
//  Peth_DiaryApp.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 10/08/23.
//

import SwiftUI

@main
struct Peth_DiaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
