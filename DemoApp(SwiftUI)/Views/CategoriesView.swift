//
//  CategoriesView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI

struct CategoriesView: View {
    
    @ObservedObject var viewModel: CategoryListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                content
                    .navigationTitle("Categories")
                    .accessibilityHint("Swipe Left or Right to navigate between categories")
                
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
        case .loaded(let item):
            return list(of: item).eraseToAnyView()
        }
    }
    
    private func list(of categories: [CategoryListViewModel.ListItem]) -> some View {
        return List(categories) { category in
            ZStack {
                CategoryListItemView(category: category)
                NavigationLink(destination:CategoryDetailView(viewModel: CategoryDetailViewModel(name: category.title))) {
                    EmptyView()
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
}


struct CategoryListItemView: View {
    let category: CategoryListViewModel.ListItem
    
    var body: some View {
        VStack {
            Image(category.poster)
                .resizable()
                .scaledToFit()
                .accessibility(hidden: true)
            title
            Spacer()
        }
        .accessibilityElement(children: .combine)
    }
    
    private var title: some View {
        ZStack {
            Text(category.title)
                .font(.callout)
                .padding(6)
                .foregroundColor(.white)
        }
        .background(Color.black.opacity(0.8))
        .cornerRadius(10.0)
        .padding(6)
    }
}


struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(viewModel: CategoryListViewModel())
    }
}
