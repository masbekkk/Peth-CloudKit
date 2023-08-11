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
    @State var isShowingProfileModal : Bool = false
    @State var isShowingFriendsModal : Bool = false
    
    @State private var refreshView: Bool = false
    @State private var judul:String = "Peth Timeline"
    
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
            .navigationTitle(judul)
            .sheet(isPresented: $isShowingEditorModal) {
                EditorView()
            }
            .sheet(isPresented: $isShowingProfileModal) {
                ProfileView()
            }
            .sheet(isPresented: $isShowingFriendsModal) {
                FriendsView()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .padding()
                            .onTapGesture {
                                isShowingProfileModal = true
                            }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Image(systemName: "person.3.sequence.fill")
                            .padding()
                            .onTapGesture {
                                isShowingFriendsModal = true
                            }
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .padding()
                        .animation(.linear(duration: 1))
                        .onTapGesture {
//                            judul = "HAHAHA"
                            refreshView = true
                            let cloudKitSync = PersistenceController.shared // Your CloudKit synchronization manager
                            cloudKitSync.fetchAndSyncData { success in
                                if success {
                                    print("Data fetched and synced successfully")
                                } else {
                                    print("Error fetching and syncing data")
                                }
                            }
//                            isShowingProfileModal = true
                            
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
            .refreshable {
                let cloudKitSync = PersistenceController.shared // Your CloudKit synchronization manager
                cloudKitSync.fetchAndSyncData { success in
                    if success {
                        print("Data fetched and synced successfully")
                    } else {
                        print("Error fetching and syncing data")
                    }
                }
            }
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
