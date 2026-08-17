import SwiftUI
import WebKit

struct RootView: View {
    var body: some View { WebScreen().ignoresSafeArea() }
}

struct WebScreen: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let wv = WKWebView()
        wv.navigationDelegate = context.coordinator
        wv.load(URLRequest(url: URL(string: AppConfig.targetURL)!))
        return wv
    }
    func updateUIView(_ v: WKWebView, context: Context) {}
    func makeCoordinator() -> Coord { Coord() }

    final class Coord: NSObject, WKNavigationDelegate {
        func webView(_ w: WKWebView, decidePolicyFor a: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if a.navigationType == .linkActivated, let u = a.request.url,
               let h = u.host, let home = URL(string: AppConfig.targetURL)?.host,
               !h.hasSuffix(home) {
                UIApplication.shared.open(u)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}