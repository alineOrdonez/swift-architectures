//
//  StartSearchView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 06/06/21.
//

import SwiftUI

struct StartSearchView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            Text("Search for cocktail recipes").font(.headline)
            Spacer().frame(height: 10)
            Text("Type in the search field above, and hit the search button to find recipes").font(.body)
        }.padding()
    }
}

struct StartSearchView_Previews: PreviewProvider {
    static var previews: some View {
        StartSearchView().previewLayout(.sizeThatFits)
    }
}
