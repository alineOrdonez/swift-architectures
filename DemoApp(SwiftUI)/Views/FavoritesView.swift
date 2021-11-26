//
//  FavoritesView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI
import ImageLoader

struct FavoritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                content
                    .navigationTitle("Favorites")
                    .accentColor(Color(UIColor(red: 34/255, green: 14/255, blue: 36/255, alpha: 1)))
                    .accessibility(label: Text("Favorites Recipes"))
            }
        }
        .onAppear(perform: {
            self.viewModel.send(event: .onAppear)
        })
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
    
    private func list(of drinks: [FavoritesViewModel.ListItem]) -> some View {
        return List {
            ForEach(drinks, id:\.self) { drink in
                HStack {
                    if let url = URL(string: drink.thumb) {
                        RemoteImageView(url: url, placeholder: {
                            ActivityIndicator(isAnimating: true, style: .medium)
                        })
                            .frame(width: 100, height: 100)
                        .cornerRadius(10)                }
                    NavigationLink(destination:RecipeView(viewModel: RecipeViewModel(id: drink.id))) {
                        Text(drink.title)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityHint("Double tap to see the full recipe")
                .accessibilityLabel(Text("\(drink.title)"))
            }
        }
    }
}


struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: FavoritesViewModel(["11008"]))
    }
}
