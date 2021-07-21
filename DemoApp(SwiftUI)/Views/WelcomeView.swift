//
//  WelcomeView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Ordoñez Garcia on 20/07/21.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var skip: Bool
    
    var body: some View {
        VStack {
            Image("coconut")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(.bottom, 50)
            Text("Welcome to TheCocktailDB!")
                .font(.largeTitle).foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 40)
                .frame(maxWidth: .infinity, alignment: .center)
                .shadow(radius: 10.0, x: 20, y: 10)
            Button(action: {skip.toggle()} ) {
                Text("Enter")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(UIColor(red: 52/255, green: 32/255, blue: 82/255, alpha: 1)))
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }
            .padding(.top, 50)
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(UIColor(red: 84/255, green: 84/255, blue: 197/255, alpha: 1)), Color(UIColor(red: 99/255, green: 156/255, blue: 217/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(skip: .constant(false))
    }
}
