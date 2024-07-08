import SwiftUI
extension View {
    func loading(_ state: LoadingViewState) -> some View {
        modifier(LoadingViewModifier(loadingState: state))
    }
}

struct LoadingViewModifier: ViewModifier {
    @ObservedObject var loadingState: LoadingViewState

    func body(content: Content) -> some View {
        content.fullScreenCover(isPresented: $loadingState.isPresented) {
            loadingView()
                .ignoresSafeArea(.all)
                .background(SheetBackgroundClearView())
        }
    }

    private func loadingView() -> some View {
        ZStack {
            Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75))
            VStack(alignment: .center, spacing: 40) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(x: 1.8, y: 1.8, anchor: .center)
                    .frame(width: 1.8 * 20, height: 1.8 * 20)
                    .padding(.top, 100)

                Text(loadingState.message)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: 300)

                Spacer()
            }
        }
        .opacity(loadingState.isLoading ? 1.0 : 0)
    }
}

@MainActor final class LoadingViewState: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var isLoading: Bool = false
    @Published var message: String = ""
    private let easeInDuration = 0.5
    private var animationStartDate: Date?
    private var task: Task<Void, Error>?

    /// LoadingViewを表示
    func show(_ messageType: MessageType = .loading, after: Double = 0.0) {
        if !isPresented {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                self.isPresented = true
            }
        }
        task?.cancel()
        animationStartDate = nil

        task = Task.detached { @MainActor in
            try await Task.sleep(nanoseconds: after.toNanoseconds())
            self.message = messageType.message
            withAnimation(.easeIn(duration: self.easeInDuration)) {
                self.isLoading = true
            }
            self.animationStartDate = Date()
        }
    }

    /// LoadingViewを閉じる
    func hide(secondsToBlock: Double = 0.1) async {
        task?.cancel()

        // 表示アニメーションが完了していなかったら終わるまで待機させる
        if didStartAnimation {
            await waitForShowAnimationFinishIfNeeded()
        } else {
            await closeSheet(secondsToBlock)
            return
        }

        // 非表示アニメーションが完了してから、シートを閉じる
        withAnimation(.easeIn(duration: 0.4)) {
            self.isLoading = false
        }
        try? await Task.sleep(nanoseconds: 0.6.toNanoseconds())
        await closeSheet(secondsToBlock)
    }

    func showAndHide(_ messageType: MessageType = .loading, hideAfter: Double = 3.0) async {
        show(messageType, after: 0.1)
        try? await Task.sleep(nanoseconds: hideAfter.toNanoseconds())
        await hide()
    }

    func showErrorAndHide(_ error: Error, hideAfter: Double = 3.0) async {
        await showAndHide(.anyError(error), hideAfter: hideAfter)
    }
}

extension LoadingViewState {
    // シートをアニメーションなしで閉じる
    private func closeSheet(_ secondsToBlock: Double) async {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            self.isPresented = false
        }
        message = ""
        animationStartDate = nil
        // ローディングViewを閉じた直後に遷移を行うと処理がブロックされて、
        // 動かないので遅延を入れる
        try? await Task.sleep(nanoseconds: secondsToBlock.toNanoseconds())
    }

    // 表示アニメーションが完了していなかったら終わるまで待機させる
    private func waitForShowAnimationFinishIfNeeded() async {
        guard let elapsed = showAnimationElapsedTime else {
            return
        }
        let waitTime = easeInDuration - elapsed
        if waitTime > 0 {
            try? await Task.sleep(nanoseconds: waitTime.toNanoseconds())
        }
    }

    /// 表示アニメーションが開始されたか
    private var didStartAnimation: Bool {
        return animationStartDate != nil
    }

    /// 表示アニメーション開始からの経過時間
    private var showAnimationElapsedTime: Double? {
        guard let animationStartDate else {
            return nil
        }
        let start = animationStartDate.timeIntervalSince1970
        let current = Date().timeIntervalSince1970
        let elapse = current - start
        return elapse
    }
}

extension LoadingViewState {
    enum MessageType {
        /// 表示データの取得、同期時
        case loading
        // 省略

        var message: String {
            return "Loading"
        }
    }
}


struct SheetBackgroundClearView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        let view = SuperviewRecolourView()
        return view
    }

    func updateUIView(_: UIView, context _: Context) {}
}

class SuperviewRecolourView: UIView {
    override func layoutSubviews() {
        guard let parentView = superview?.superview else {
            return
        }
        parentView.backgroundColor = .clear
    }
}
