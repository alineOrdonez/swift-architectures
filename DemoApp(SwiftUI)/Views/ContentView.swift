//
//  ContentView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            SearchView(viewModel: SearchListViewModel())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search Drink")
                }
            CategoriesView(viewModel: CategoryListViewModel())
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Categories")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
