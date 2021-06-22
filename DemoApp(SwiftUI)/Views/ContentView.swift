//
//  ContentView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI

struct ContentView: View {
    
    //@SceneStorage("selectedTab") var selected: Int = 2
    @AppStorage("favorites") var favorites: [String] = []
    
    var body: some View {
        //TabView(selection: $selected) {
        TabView {
            SearchView(viewModel: SearchListViewModel())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search Drink")
                }
                .tag(0)
            CategoriesView(viewModel: CategoryListViewModel())
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Categories")
                }
                .tag(1)
            FavoritesView(viewModel: FavoritesViewModel(favorites))
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
