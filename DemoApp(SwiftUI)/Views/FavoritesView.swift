//
//  FavoritesView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            Text("This is just a test")
        }
        .navigationBarTitle("Favorites")
        .navigationBarItems(trailing: EditButton())
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
