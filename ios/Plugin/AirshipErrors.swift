import Foundation

// AirshipCore's AirshipErrors is @_spi(AirshipInternal); this is a local stand-in with the same call shape.
enum AirshipErrors {
    static func error(_ message: String) -> Error {
        NSError(domain: "com.airship.capacitor", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
