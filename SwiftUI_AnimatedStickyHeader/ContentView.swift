//
//  ContentView.swift
//  SwiftUI_AnimatedStickyHeader
//
//  Created by パク on 2023/05/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets

            Home(size: size, safeArea: safeArea)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
