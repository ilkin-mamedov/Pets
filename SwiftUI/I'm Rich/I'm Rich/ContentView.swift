import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color("AccentColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("I'm Rich")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(20.0)
                Image("Diamond")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250, alignment: .center)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
