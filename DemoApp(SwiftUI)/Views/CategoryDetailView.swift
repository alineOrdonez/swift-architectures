//
//  CategoryDetailView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/06/21.
//

import SwiftUI

struct CategoryDetailView: View {
    @ObservedObject var viewModel: CategoryDetailViewModel
    
    var body: some View {
        content
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
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded(let drinks):
            return self.list(of: drinks).eraseToAnyView()
        }
    }
    
    private func list(of drinks: [CategoryDetailViewModel.ListItem]) -> some View {
        return List(drinks) { drink in
            Text(drink.title)
        }
    }
}
