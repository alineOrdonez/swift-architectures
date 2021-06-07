//
//  ErrorView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 06/06/21.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Error!")
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(Color.orange)
            }.font(.headline)
            Text("Something went wrong. Please try again.")
                .font(.body)
        }.padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView().previewLayout(.sizeThatFits)
    }
}
