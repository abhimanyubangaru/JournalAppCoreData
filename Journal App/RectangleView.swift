//
//  RectangleView.swift
//  Journal App
//
//  Created by Abhi B on 6/15/22.
//
import SwiftUI

struct RectangleView: View {
    var geometry : CGSize
    var content : String
    var endColor : Color
    
    var body: some View {
            Text(content)
                .bold()
                .frame(width: geometry.width/3.25, height: geometry.width/3.25)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(UIColor(endColor).inverseColor()), endColor]), startPoint: .top, endPoint: .bottom)
                )
                .foregroundColor(.black)
                .cornerRadius(20)
                .shadow(color: .gray, radius: 4, x: 1, y: 1)
                .opacity(0.95)

    }
}

extension UIColor {
    func inverseColor() -> UIColor {
        var alpha: CGFloat = 1.0

        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: red + 0.4, green: green + 0.4, blue: blue + 0.4, alpha: alpha * 0.6)
        }

        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha * 0.01)
        }

        var white: CGFloat = 0.0
        if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: 1.0 - white, alpha: alpha)
        }

        return self
    }
}

//struct RectangleView_Previews: PreviewProvider {
//    static var previews: some View {
//        RectangleView()
//    }
//}
