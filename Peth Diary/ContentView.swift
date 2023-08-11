//
//  ContentView.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 10/08/23.
//

import SwiftUI
import CoreData
import CloudKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var isShowingEditorModal: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Posts.timestamp, ascending: false)],
        animation: .default)
    private var posts: FetchedResults<Posts>
    
    var body: some View {
        NavigationView {
            ScrollView{
                ForEach(posts,  id: \.id) { post in
                    LazyVStack(alignment: .leading) {
                        HStack{
                            Text("username")
                                .font(.headline)
                            Text("·")
                            Text("2h")
                                .font(.caption2)
                        }
                        Text(post.post ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        Divider()
                    }
                    .padding()
                }
            }
            .navigationTitle("Peth's Timeline")
            .sheet(isPresented: $isShowingEditorModal) {
                EditorView()
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Image(systemName: "arrow.clockwise")
                        .padding()
                        .onTapGesture {
                            
                            let cloudKitSync = PersistenceController.shared // Your CloudKit synchronization manager
                            cloudKitSync.fetchAndSyncData { success in
                                if success {
                                    print("Data fetched and synced successfully")
                                } else {
                                    print("Error fetching and syncing data")
                                }
                            }
                            
                            //                            TimelineView()
                        }
                    
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Image(systemName: "square.and.pencil")
                        .padding()
                        .onTapGesture {
                            isShowingEditorModal = true
                        }
                    
                }
                
            }
            Text("Select an item")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Posts(context: viewContext)
            newItem.id = UUID()
            newItem.post = "coba post"
            newItem.user_id = "coba"
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { posts[$0] }.forEach(viewContext.delete)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
