//
//  Home.swift
//  SwiftUI_AnimatedStickyHeader
//
//  Created by パク on 2023/05/07.
//

import SwiftUI

struct Home: View {

    var size: CGSize
    var safeArea: EdgeInsets

    @State private var offsetY: CGFloat = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                 HeaderView()
                    .zIndex(1) // HeaderViewを前に移動

                SampleCardsView()
                    .padding()
            }
            .background {
                ScrollDetector { offset in
                    offsetY = -offset
                } onDraggingEnd: { offset, velocity in
                    print("scroll released!!")
                }
            }

        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = (size.height * 0.3) + safeArea.top
        let minimumHeaderHeight = 65 + safeArea.top

        // ヘッダースクロール幅で、progressは 最大 0 ~ 1
        let progress = max(0, min(-offsetY / (headerHeight - minimumHeaderHeight), 1))
        // GeometryReaderで囲まないと headerとcellの間隔が開いてしまう理由はわからない。。
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(Color("Pink").gradient)

                VStack(spacing: 15) {
                    GeometryReader {
                        let rect = $0.frame(in: .global)

                        Image("Pic")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: rect.width, height: rect.height)
                            .clipShape(Circle())

                             // 最大 30%まで縮小 .leadingすることで Image Frameの.leadingへ配置される
                            .scaleEffect(1 - progress *  0.7, anchor: .leading)

                             // ヘッダー左へ アイコンを移動
                             //         + 10は 左padding                  35は iJustine と 同じ高さに調整
                            .offset(x: (-rect.minX + 10) * progress, y: (safeArea.top + 35) * progress)
                    }
                    .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)

                    Text("iJustine")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top, safeArea.top)
                .padding(.bottom, 10)
            }
            // ヘッダーの背景を固定
            .offset(y: -offsetY)
            // スクロール量に応じてヘッダー高さを動的に変更する
            .frame(height: getDynamicHeaderHeight(withScrollOffset: self.offsetY), alignment: .bottom)
        }
    }

    private func getDynamicHeaderHeight(withScrollOffset offsetY: CGFloat) -> CGFloat {
        let headerHeight = (size.height * 0.3) + safeArea.top
        let minimumHeaderHeight = 65 + safeArea.top

        // スクロールした分ヘッダーの背景を縮んだり、伸ばしたりするための height を return する
        if (headerHeight + offsetY) < minimumHeaderHeight {
            return minimumHeaderHeight
        } else {
            return headerHeight + offsetY
        }
    }

    @ViewBuilder
    func SampleCardsView() -> some View {
        VStack(spacing: 15) {
            ForEach(1...25, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black.opacity(0.05))
                    .frame(height: 75)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
