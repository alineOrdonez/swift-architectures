//
//  SearchView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI
import ImageLoader

struct SearchView: View {
    @ObservedObject var viewModel: SearchListViewModel
    
    var body: some View {
        return NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText,
                          isEditing: $viewModel.isSearching,
                          searchingChanged: viewModel.searchStatusChanged)
                content
                Spacer()
            }.navigationBarTitle(Text("Search recipes"))
            .edgesIgnoringSafeArea([.bottom])
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return StartSearchView().eraseToAnyView()
        case .searched:
            return ActivityIndicator(isAnimating: true, style: .large).eraseToAnyView()
        case .error:
            return ErrorView().eraseToAnyView()
        case .searching:
            return Color.clear.eraseToAnyView()
        case .loaded(let items):
            return list(of: items).eraseToAnyView()
        }
    }
    
    private func list(of drinks: [SearchListViewModel.ListItem]) -> some View {
        return ScrollView {
            LazyVStack {
                ForEach(drinks, id:\.self) { drink in
                    HStack {
                        if let url = URL(string: drink.thumb) {
                            RemoteImageView(url: url, placeholder: {
                                ActivityIndicator(isAnimating: true, style: .medium)
                            })
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .padding(5)
                        }
                        NavigationLink(destination:RecipeView(viewModel: RecipeViewModel(id: drink.id))) {
                            Text(drink.title)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }.padding(10)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchListViewModel())
    }
}
