//
//  ScrollDetector.swift
//  SwiftUI_AnimatedStickyHeader
//
//  Created by パク on 2023/05/07.
//

import SwiftUI

struct ScrollDetector: UIViewRepresentable {

    var onScroll: (CGFloat) -> Void
    var onDraggingEnd: (_ offset: CGFloat, _ velocity: CGFloat) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

        /*
         ここで DispatchQueue.main.asyncを使う理由は
         'updateUIView'メソッドが、Viewのレイアウトや階層が完全に設定される「前」に呼び出させることがあるため

         DispatchQueueを使うことで、 'updateUIView'メソッド内で、実行されるクロージャが メインスレッドの次の実行ループにスケジュールされる。
         これにより、Viewの階層やレイアウトが完全に設定された「後」に実行されるようになり、UIScrollViewに正しくアクセスできるようになる。
         */
        DispatchQueue.main.async {
            //  scrollView = backgraound/.background{}/VStack{}/scrollView{}

            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                // 毎回呼び出させるので delegate設定は一回のみとするため : context.coordinator.isDelegateAdded
                context.coordinator.isDelegateAdded = true
            }
        }
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector
        var isDelegateAdded: Bool = false

        init(parent: ScrollDetector) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }

        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onDraggingEnd(targetContentOffset.pointee.y, velocity.y)
        }
    }
}
