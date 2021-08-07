//
//  ContentView.swift
//  Demo
//
//  Created by Mike on 8/2/21.
//

import Allegory
import CoreGraphics
import SwiftUI

struct Sample: Allegory.View {
    var body: SomeView {
        Allegory.Ellipse()
        Allegory.Image("")
            .resizable()
            .scaledToFit()
    }
}

let sample = SwiftUIView(rootView: Sample())

struct ContentView: SwiftUI.View {
    let size = CGSize(width: 300, height: 400)

    @State var opacity: Double = 0.5
    var body: some SwiftUI.View {
        VStack {
            ZStack  {
                SwiftUI.Ellipse()
                    .frame(width: size.width, height: size.height)
                    .opacity(1-opacity)
                sample
                    .frame(width: size.width, height: size.height)
                    .opacity(opacity)
            }
            Slider(value: $opacity, in: 0...1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        ContentView()
    }
}
