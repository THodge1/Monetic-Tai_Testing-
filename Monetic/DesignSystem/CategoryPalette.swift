import SwiftUI
import UIKit

/// The hues a group can be tinted with.
///
/// These are deliberately *not* system colors. They're spread far enough around
/// the wheel to stay legible next to each other in a donut chart, but share one
/// register — vivid, slightly cool, high-chroma — so they read as a family with
/// the logo's blue/violet rather than as nine unrelated crayons.
enum CategoryPalette {

    /// Stable keys stored on `BudgetCategory.color`.
    static let keys = [
        "azure", "magenta", "mint", "amber",
        "violet", "cyan", "rose", "indigo", "coral"
    ]

    private static let hues: [String: (light: UInt32, dark: UInt32)] = [
        "azure":   (0x1F6FEB, 0x2E8CFF),
        "indigo":  (0x4F46E5, 0x6366F1),
        "violet":  (0x7C3AED, 0x9B6BFF),
        "magenta": (0xB021BC, 0xD946C4),
        "rose":    (0xE0446F, 0xFB6F92),
        "coral":   (0xE04A2F, 0xFF6B57),
        "amber":   (0xB97600, 0xF5A524),
        "mint":    (0x0E9E7A, 0x2DD4A7),
        "cyan":    (0x0E8EA8, 0x22D3EE),
    ]

    /// Maps the system color names stored by earlier versions onto the new
    /// palette. Nothing is rewritten on disk — resolution happens at read time,
    /// so existing groups simply start rendering in the new hues.
    private static let legacy: [String: String] = [
        "blue": "azure", "teal": "cyan", "green": "mint", "mint": "mint",
        "orange": "amber", "yellow": "amber", "brown": "amber",
        "purple": "violet", "pink": "rose", "red": "coral",
        "indigo": "indigo", "cyan": "cyan", "gray": "azure", "grey": "azure",
    ]

    /// Resolves a stored color string — new key, legacy system name, or
    /// anything unrecognized — to a brand hue. Never fails.
    static func color(for stored: String) -> Color {
        let key = resolvedKey(for: stored)
        guard let hue = hues[key] else { return Brand.accent }
        return adaptiveHue(hue)
    }

    /// The hue to assign to the nth group created, cycling so that consecutive
    /// groups never land on neighbouring hues.
    static func key(forIndex index: Int) -> String {
        guard !keys.isEmpty else { return "azure" }
        return keys[abs(index) % keys.count]
    }

    private static func resolvedKey(for stored: String) -> String {
        let normalized = stored.lowercased()
        if hues[normalized] != nil { return normalized }
        if let mapped = legacy[normalized] { return mapped }
        // Unknown value (hand-edited data, a future key): hash it so the same
        // group always gets the same hue instead of flickering between launches.
        let bucket = abs(normalized.unicodeScalars.reduce(0) { ($0 &* 31 &+ Int($1.value)) % 100_000 })
        return keys[bucket % keys.count]
    }

    private static func adaptiveHue(_ hue: (light: UInt32, dark: UInt32)) -> Color {
        Color(uiColor: UIColor { traits in
            let hex = traits.userInterfaceStyle == .dark ? hue.dark : hue.light
            return UIColor(
                red:   CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8)  & 0xFF) / 255,
                blue:  CGFloat( hex        & 0xFF) / 255,
                alpha: 1
            )
        })
    }
}
