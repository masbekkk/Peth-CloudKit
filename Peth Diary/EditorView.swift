//
//  EditorView.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 11/08/23.
//

import SwiftUI
import RichTextKit

struct EditorView: View {
    @Environment(\.dismiss) var dismiss
    @State var diary: String = ""
    @StateObject
    var context = RichTextContext()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("authID") var authID: String = ""
    @AppStorage("username") var username: String = ""
    
    @State private var isShowingLogin: Bool = false
    
    var body: some View {
        if isLoggedIn {
            NavigationView{
                NavigationStack {
                    TextField("Ada apa hari inii?!?!", text: $diary)
                    //                    RichTextEditor(text: $diary, context: context) {
                    //                        $0.textContentInset = CGSize(width: 10, height: 20)
                    //                    }
                    //                    .background(Material.regular)
                    //                    .cornerRadius(5)
                    //                    .focusedValue(\.richTextContext, context)
                    //                    .padding()
                    //
                    //                    RichTextKeyboardToolbar(
                    //                        context: context,
                    //                        leadingButtons: {},
                    //                        trailingButtons: {}
                    //                    )
                }
                .background(Color.primary.opacity(0.15))
                .navigationBarTitle("Peth It", displayMode: .inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action:{
                            dismiss()
                        }){
                            Text("Cancel")
                                .foregroundColor(Color.accentColor)
                                .padding(.horizontal)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action:{
                            let post = Posts(context: viewContext)
                            post.id = UUID()
                            post.post = diary
                            post.timestamp = Date()
                            do {
                                try viewContext.save()
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                            dismiss()
                        }){
                            Text("Post")
                                .foregroundColor(Color.accentColor)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            
        } else {
            LoginView()
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
