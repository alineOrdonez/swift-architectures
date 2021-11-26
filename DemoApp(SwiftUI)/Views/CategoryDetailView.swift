//
//  CategoryDetailView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/05/21.
//

import SwiftUI
import ImageLoader

struct CategoryDetailView: View {
    @ObservedObject var viewModel: CategoryDetailViewModel
    
    var body: some View {
        content
            .onAppear(perform: {
                self.viewModel.send(event: .onAppear)
            })
            .navigationTitle("Drinks")
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return ActivityIndicator(isAnimating: true, style: .large).eraseToAnyView()
        case .error:
            return ErrorView().eraseToAnyView()
        case .loaded(let drinks):
            return self.list(of: drinks).eraseToAnyView()
        }
    }
    
    private func list(of drinks: [CategoryDetailViewModel.ListItem]) -> some View {
        return List {
            ForEach(drinks, id:\.self) { drink in
                HStack {
                    if let url = URL(string: drink.thumb) {
                        RemoteImageView(url: url, placeholder: {
                            ActivityIndicator(isAnimating: true, style: .medium)
                        })
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .accessibility(hidden: true)
                    }
                    NavigationLink(destination:RecipeView(viewModel: RecipeViewModel(id: drink.id))) {
                        Text(drink.title)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .accessibilityElement(children: .combine)
                .contextMenu(ContextMenu(menuItems: {
                    Button {
                        viewModel.addOrRemove(drink)
                    } label: {
                        if viewModel.shouldAddToFavorites(drink) {
                            Text("Remove from Favorites")
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        } else {
                            Text("Add to Favorites")
                            Image(systemName: "heart")
                                .foregroundColor(.red)
                        }
                    }
                }))
            }
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(viewModel: CategoryDetailViewModel(name: "Cocktail"))
    }
}
