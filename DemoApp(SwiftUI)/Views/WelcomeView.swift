//
//  WelcomeView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Ordoñez Garcia on 20/07/21.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var skip: Bool
    @State var username: String = ""
    
    var body: some View {
        VStack {
            Text("Welcome to TheCocktailDB!")
                .font(.largeTitle).foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 40)
                .frame(maxWidth: .infinity, alignment: .center)
                .shadow(radius: 10.0, x: 20, y: 10)
            Image("coconut")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(.bottom, 40)
//            TextField("What's your name?", text: self.$username)
//                .padding()
//                .background(Color.themeTextField)
//                .cornerRadius(20.0)
//                .padding([.leading, .trailing], 15.0)
            Button(action: {skip.toggle()} ) {
                Text("Enter")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(buttonColor)
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }
            .padding(.top, 30)
            .disabled(self.username.isEmpty)
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.lightPurple, Color.lightBlue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all))
    }
    
    var buttonColor: Color {
        return self.username.isEmpty ? .accentColor : Color.darkPurple
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(skip: .constant(false))
    }
}
