import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.15, green: 0.68, blue: 0.38)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("ilkin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150.0, height: 150.0)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.white, lineWidth: 5))
                Text("Ilkin Mamedov")
                    .font(.system(size: 40))
                    .bold()
                    .foregroundColor(.white)
                Text("Junior iOS Developer")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                Divider()
                InfoView(text: "+7(977)-854-57-56", imageName: "phone.fill")
                InfoView(text: "13katyukhin@gmail.com", imageName: "envelope.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
