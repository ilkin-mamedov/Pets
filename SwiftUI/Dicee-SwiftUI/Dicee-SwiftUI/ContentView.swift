import SwiftUI

struct ContentView: View {
    
    @State var rightDiceNumber = 1
    @State var leftDiceNumber = 1
    
    var body: some View {
        ZStack {
            Color("AccentColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 150.0, height: 150.0, alignment: .center)
                Spacer()
                HStack {
                    DiceView(imageName: getImageName(n: rightDiceNumber))
                    DiceView(imageName: getImageName(n: leftDiceNumber))
                }
                .padding(.horizontal)
                Spacer()
                Button(action: {
                    self.rightDiceNumber = Int.random(in: 1...6)
                    self.leftDiceNumber = Int.random(in: 1...6)
                }, label: {
                    Image("roll")
                        .frame(alignment: .bottom)
                })
            }
        }
    }
    
    func getImageName(n: Int) -> String {
        switch n {
            case 1:
                return "one"
            case 2:
                return "two"
            case 3:
                return "three"
            case 4:
                return "four"
            case 5:
                return "five"
            case 6:
                return "six"
            default:
                return "one"
        }
    }
}

struct DiceView: View {
    
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 150.0, height: 150.0, alignment: .center)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
