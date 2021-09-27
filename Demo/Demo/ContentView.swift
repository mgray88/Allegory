//
//  ContentView.swift
//  Demo
//
//  Created by Mike on 8/2/21.
//

import Allegory
import CoreGraphics

struct Sample: View {
    var body: SomeView {
        Ellipse()
        Image("")
            .resizable()
            .scaledToFit()
    }
}

struct ContentView: View {
    let size = CGSize(width: 300, height: 400)

    @State var opacity: Double = 0.5
    var body: SomeView {
        VStack {
            ZStack  {
                Ellipse()
                    .background(.red)
                    .frame(width: size.width, height: size.height)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
