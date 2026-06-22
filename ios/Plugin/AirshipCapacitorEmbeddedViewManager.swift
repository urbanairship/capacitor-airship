import Foundation
import SwiftUI

#if canImport(AirshipKit)
import AirshipKit
#elseif canImport(AirshipCore)
import AirshipCore
#endif

import AirshipFrameworkProxy

/**
 * Manages native embedded views that overlay the Capacitor web view. Views are
 * positioned by the JS layer to match a placeholder element's bounding rect,
 * so frames are in the web view's coordinate space (CSS pixels == points).
 *
 * Each embedded view is hosted inside a clipping container sized to a clip
 * rect (typically the placeholder's scroll container). The hosted view is
 * offset within the container so that, as the placeholder scrolls beyond the
 * clip bounds, the view is clipped and appears to scroll under the surrounding
 * web content.
 */
@MainActor
final class AirshipCapacitorEmbeddedViewManager {

    private var containers: [String: AirshipCapacitorEmbeddedViewContainer] = [:]

    nonisolated init() {}

    func create(
        viewId: String,
        embeddedId: String,
        frame: CGRect,
        clip: CGRect,
        webView: UIView
    ) {
        dispose(viewId: viewId)

        let container = AirshipCapacitorEmbeddedViewContainer(
            embeddedID: embeddedId,
            frame: frame,
            clip: clip
        )

        webView.addSubview(container)
        containers[viewId] = container
    }

    func updateFrame(viewId: String, frame: CGRect, clip: CGRect) throws {
        try requireContainer(viewId: viewId).apply(frame: frame, clip: clip)
    }

    func setVisible(viewId: String, visible: Bool) throws {
        let container = try requireContainer(viewId: viewId)
        container.isHidden = !visible
    }

    func dispose(viewId: String) {
        containers.removeValue(forKey: viewId)?.removeFromSuperview()
    }

    private func requireContainer(viewId: String) throws -> AirshipCapacitorEmbeddedViewContainer {
        guard let container = containers[viewId] else {
            throw AirshipErrors.error("No embedded view for viewId \(viewId)")
        }
        return container
    }
}

/**
 * Clipping container. Its frame is the clip rect; the hosted wrapper is
 * positioned relative to the clip origin and clipped to the container bounds.
 */
final class AirshipCapacitorEmbeddedViewContainer: UIView {
    private let wrapper: AirshipCapacitorEmbeddedViewWrapper

    init(embeddedID: String, frame: CGRect, clip: CGRect) {
        self.wrapper = AirshipCapacitorEmbeddedViewWrapper(
            embeddedID: embeddedID,
            frame: CGRect(origin: .zero, size: frame.size)
        )

        super.init(frame: clip)
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(self.wrapper)
        self.apply(frame: frame, clip: clip)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(frame: CGRect, clip: CGRect) {
        self.frame = clip
        self.wrapper.frame = CGRect(
            x: frame.minX - clip.minX,
            y: frame.minY - clip.minY,
            width: frame.width,
            height: frame.height
        )
    }

    // The container spans the whole clip region but should only capture touches
    // where the embedded view actually is. Returning nil for hits on the
    // container itself lets scrolling and taps fall through to the web view.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        return hit === self ? nil : hit
    }
}

final class AirshipCapacitorEmbeddedViewWrapper: UIView {
    private let viewModel = EmbeddedViewModel()
    private let viewController: UIViewController
    private var isAdded: Bool = false

    init(embeddedID: String, frame: CGRect) {
        self.viewController = UIHostingController(
            rootView: CapacitorEmbeddedView(viewModel: self.viewModel)
        )
        self.viewController.view.backgroundColor = UIColor.clear

        super.init(frame: frame)

        self.addSubview(self.viewController.view)
        self.viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.viewController.view.frame = self.bounds

        self.viewModel.embeddedID = embeddedID
        self.viewModel.size = frame.size
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        if self.window == nil {
            if self.isAdded {
                self.viewController.willMove(toParent: nil)
                self.viewController.removeFromParent()
                self.isAdded = false
            }
            return
        }

        guard !self.isAdded, let parentVC = self.parentViewController() else { return }
        self.viewController.willMove(toParent: parentVC)
        parentVC.addChild(self.viewController)
        self.viewController.didMove(toParent: parentVC)
        self.viewController.view.isUserInteractionEnabled = true
        self.isAdded = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewModel.size = bounds.size
    }

    private func parentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let current = responder {
            if let viewController = current as? UIViewController {
                return viewController
            }
            responder = current.next
        }
        return nil
    }
}

private struct CapacitorEmbeddedView: View {
    @ObservedObject var viewModel: EmbeddedViewModel

    var body: some View {
        if let embeddedID = viewModel.embeddedID {
            AirshipEmbeddedView(
                embeddedID: embeddedID,
                embeddedSize: .init(
                    parentWidth: viewModel.width,
                    parentHeight: viewModel.height
                )
            )
        }
    }
}

@MainActor
private final class EmbeddedViewModel: ObservableObject {
    @Published var embeddedID: String?
    @Published var size: CGSize?

    var height: CGFloat {
        guard let height = self.size?.height, height > 0 else {
            return (try? AirshipUtils.mainWindow()?.screen.bounds.height) ?? 500
        }
        return height
    }

    var width: CGFloat {
        guard let width = self.size?.width, width > 0 else {
            return (try? AirshipUtils.mainWindow()?.screen.bounds.width) ?? 500
        }
        return width
    }
}
