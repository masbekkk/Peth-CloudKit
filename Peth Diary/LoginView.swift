//
//  LoginView.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 11/08/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var fullName: String = ""
    @State private var userEmail: String = ""
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State var userID = ""
    @AppStorage("authID") var authID: String = ""
    @AppStorage("username") var username: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //    var onCreateUser : ((String) -> Void)?
    //
    //    init(onCreateUser: @escaping (String) -> Void) {
    //        self.onCreateUser = onCreateUser
    //    }
    
    var body: some View {
        VStack {
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("Authorisation successful")
                    if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                        // Handle successful login here
                        print(appleIDCredential)
                        // User ID
                        let userID = appleIDCredential.user
                        print("User ID: \(userID)")
                        self.userID = userID
                        
                        // User's full name
                        if let fullName = appleIDCredential.fullName {
                            let firstName = fullName.givenName ?? ""
                            let lastName = fullName.familyName ?? ""
                            self.fullName = "\(firstName) \(lastName)"
                            
                            print(fullName)
                        }
                        
                        authID = userID
                        
                        let isUserExist = PersistenceController.shared.isUserExists(context: viewContext, authID: authID, fullName: self.fullName, username: username)
                        if isUserExist == false {
                            username = "username"
                            let user = Pengguna(context: viewContext)
//                            user.id = userID
                            user.name = self.fullName
                            user.username = username
                            
                            do {
                                try viewContext.save()
                                print("BERHASIL NAMBAH DATA BARU")
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                            
                        }
                        
                        // User's email
                        let userEmail = appleIDCredential.email ?? ""
                        self.userEmail = userEmail
                        print(userEmail)
                        
                        isLoggedIn = true
                        ContentView()
                        
                    }
                case .failure(let error):
                    print("Authorisation failed: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(.whiteOutline)
            .frame(width: 200, height: 50)
            //            }
            Text(userID)
        }
        .padding()
    }
    
    
    // Function to clear user data on logout
    func clearUserData() {
        // Clear user-related data from UserDefaults or any other storage
        UserDefaults.standard.removeObject(forKey: "userFullName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
        // Perform any other necessary actions for logout, e.g., invalidating tokens, notifying the server, etc.
    }
}


//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
////        LoginView()
//    }
//}
