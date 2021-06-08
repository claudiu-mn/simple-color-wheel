//
//  ContentView.swift
//  iOS Example
//
//  Created by shout@claudiu.mn on 2021.06.08.
//

import SwiftUI
import SimpleColorWheel

struct SwiftUISimpleColorWheel: UIViewRepresentable {
    @State private var backgroundColor = UIColor.white
    
    func makeCoordinator() -> Coordinator {
        Coordinator(color: $backgroundColor)
    }
    
    func makeUIView(context: Context) -> UIView {
        let wheel = ColorWheelView()
        wheel.delegate = context.coordinator
        return wheel
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.backgroundColor = backgroundColor
    }
}

extension SwiftUISimpleColorWheel {
    class Coordinator: ColorWheelViewDelegate {
        @Binding private var color: UIColor
        
        init(color: Binding<UIColor>) {
            _color = color
        }
        
        func didStartSelection(in colorWheel: ColorWheelView,
                               with color: UIColor) {
            self.color = color
        }
        
        func didChangeSelection(in colorWheel: ColorWheelView,
                                with color: UIColor) {
            self.color = color
        }
        
        func didEndSelection(in colorWheel: ColorWheelView,
                             with color: UIColor) {
            self.color = color
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center) {
            SwiftUISimpleColorWheel()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
