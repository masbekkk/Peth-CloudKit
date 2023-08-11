//
//  FriendsView.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 11/08/23.
//

import SwiftUI

struct FriendsView: View {
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var users: FetchedResults<Pengguna>
    
    var body: some View {
        NavigationStack{
            List(users){ user in
                VStack{
                    Text(user.username ?? "")
                        .font(.body)
                }
            }
            .navigationBarTitle("Friends", displayMode: .inline)
            .toolbarBackground(Color(UIColor.systemGray6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }

    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
