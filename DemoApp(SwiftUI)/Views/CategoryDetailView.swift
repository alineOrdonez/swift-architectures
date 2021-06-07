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
                NavigationLink(destination:RecipeView(viewModel: RecipeViewModel(id: drink.id))) {
                    EmptyView()
                }
            }
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(viewModel: CategoryDetailViewModel(name: "Cocktail"))
    }
}
