//
//  ContentView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI

struct RootView: View {
    @SceneStorage("skipView") private var skip: Bool = false
    
    var body: some View {
        if skip {
            ContentView()
        } else {
            WelcomeView(skip: $skip)
        }
    }
}

struct ContentView: View {
    @SceneStorage("skipView") private var skip: Bool = false
    @AppStorage("favorites") var favorites: [String] = []
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.lightBlue)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.darkPurple)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.darkPurple)]
    }
    
    var body: some View {
        
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
        .accentColor(Color(UIColor(red: 34/255, green: 14/255, blue: 36/255, alpha: 1)))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
