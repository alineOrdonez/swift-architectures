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
                          isSearching: $viewModel.isSearching,
                          searchingChanged: viewModel.searchStatusChanged)
                content
                Spacer()
            }
            .navigationBarTitle(Text("Search recipes"))
            .edgesIgnoringSafeArea([.bottom])
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .start:
            return StartSearchView().eraseToAnyView()
        case .loading:
            return ActivityIndicator(isAnimating: true, style: .large).eraseToAnyView()
        case .error:
            return ErrorView().eraseToAnyView()
        case .searching:
            return Color.clear.eraseToAnyView()
        case .searchResults(let items):
            return list(of: items).eraseToAnyView()
        }
    }
    
    private func list(of drinks: [SearchListViewModel.ListItem]) -> some View {
        return List {
            ForEach(drinks, id:\.self) { drink in
                ResultListItemView(item: drink)
                    .contextMenu(ContextMenu(menuItems: {
                        Button {
                            viewModel.addOrRemove(drink)
                        } label: {
                            if viewModel.shouldAddToFavorites(drink) {
                                Label("Remove from Favorites", systemImage: "heart.fill")
                            } else {
                                Label("Add to Favorites", systemImage: "heart")
                            }
                        }
                    }))
            }
        }
    }
    
    struct ResultListItemView: View {
        let item: SearchListViewModel.ListItem
        
        var body: some View {
            HStack {
                if let url = URL(string: item.thumb) {
                    displayImage(from: url)
                }
                NavigationLink(destination:RecipeView(viewModel: RecipeViewModel(id: item.id))) {
                    addDetail()
                }
            }
        }
        
        private func displayImage(from url: URL) -> some View {
            return RemoteImageView(url: url, placeholder: {
                ActivityIndicator(isAnimating: true, style: .medium)
            })
            .frame(width: 100, height: 100)
            .cornerRadius(10)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        }
        
        private func addDetail() -> some View {
            return VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.category)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
                if let tags = item.tags {
                    addTags(tags)
                }
            }
        }
        
        private func addTags(_ tags: [String]) -> some View {
            return HStack {
                ForEach(tags, id: \.self) { tag in
                    ZStack {
                        Text(tag)
                            .font(.subheadline)
                            .padding(6)
                            .foregroundColor(.white)
                    }.background(Color.gray)
                    .opacity(0.8)
                    .cornerRadius(10.0)
                    .padding(6)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchListViewModel())
    }
}
