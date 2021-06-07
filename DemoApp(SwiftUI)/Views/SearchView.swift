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
        return List(drinks) { drink in
            HStack {
                if let url = URL(string: drink.thumb) {
                    RemoteImageView(url: url, placeholder: {
                        ActivityIndicator(isAnimating: true, style: .medium)
                    })
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(drink.title)
                        .font(.title3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchListViewModel())
    }
}
