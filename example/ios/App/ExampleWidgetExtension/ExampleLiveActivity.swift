import ActivityKit
import WidgetKit
import SwiftUI

struct ExampleLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ExampleAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ExampleAttributes {
    fileprivate static var preview: ExampleAttributes {
        ExampleAttributes(name: "World")
    }
}

extension ExampleAttributes.ContentState {
    fileprivate static var smiley: ExampleAttributes.ContentState {
        ExampleAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ExampleAttributes.ContentState {
         ExampleAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ExampleAttributes.preview) {
    ExampleLiveActivity()
} contentStates: {
    ExampleAttributes.ContentState.smiley
    ExampleAttributes.ContentState.starEyes
}
