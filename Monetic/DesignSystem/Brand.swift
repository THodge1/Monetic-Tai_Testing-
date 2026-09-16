import SwiftUI
import UIKit

// MARK: - Hex Colors

extension Color {
    /// 0xRRGGBB literal, e.g. `Color(hex: 0x1B6EF3)`.
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8)  & 0xFF) / 255,
            blue:  Double( hex        & 0xFF) / 255,
            opacity: opacity
        )
    }
}

/// Resolves to a different hex per interface style, so every surface in the app
/// can be declared once and still be correct in both modes.
private func adaptive(light: UInt32, dark: UInt32, opacity: Double = 1) -> Color {
    Color(uiColor: UIColor { traits in
        let hex = traits.userInterfaceStyle == .dark ? dark : light
        return UIColor(
            red:   CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8)  & 0xFF) / 255,
            blue:  CGFloat( hex        & 0xFF) / 255,
            alpha: CGFloat(opacity)
        )
    })
}

// MARK: - Brand

/// The single source of truth for Monetic's visual language.
///
/// The palette is lifted from the logo: an electric blue that runs through
/// violet into magenta, sitting on near-black. Dark is the mode the brand is
/// tuned for; light is fully supported but reads as the quieter of the two.
enum Brand {

    // MARK: Logo hues

    static let cyan    = Color(hex: 0x22A7F5)
    static let blue    = Color(hex: 0x1B6EF3)
    static let violet  = Color(hex: 0x7B2FF7)
    static let magenta = Color(hex: 0xC026D3)

    /// The accent used for interactive elements that aren't gradient-filled.
    /// Lifted slightly in dark mode so it holds up against a near-black field.
    static let accent = adaptive(light: 0x1B6EF3, dark: 0x3D8BFF)

    // MARK: Signature gradient

    /// Left-to-right, mirroring the logo's own sweep.
    static let gradient = LinearGradient(
        colors: [cyan, blue, violet, magenta],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// For fills that need the sweep to read across a box rather than a bar.
    static let gradientDiagonal = LinearGradient(
        colors: [blue, violet, magenta],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Rotated so the sweep starts at 12 o'clock, where a progress ring begins.
    static let ringGradient = AngularGradient(
        gradient: Gradient(colors: [cyan, blue, violet, magenta]),
        center: .center,
        startAngle: .degrees(-90),
        endAngle: .degrees(270)
    )

    // MARK: Surfaces

    static let background    = adaptive(light: 0xF3F4F8, dark: 0x07070C)
    static let surface       = adaptive(light: 0xFFFFFF, dark: 0x13131D)
    static let surfaceRaised = adaptive(light: 0xFFFFFF, dark: 0x1C1C29)
    static let surfaceSunken = adaptive(light: 0xEBECF2, dark: 0x0E0E16)

    /// Card borders. Carries most of the separation in dark mode, where
    /// shadows are nearly invisible against black.
    static let hairline = adaptive(light: 0x000000, dark: 0xFFFFFF, opacity: 0.09)

    /// Empty track behind any progress bar or ring.
    static let track = adaptive(light: 0x000000, dark: 0xFFFFFF, opacity: 0.08)

    // MARK: Text

    static let textPrimary   = adaptive(light: 0x0B0B14, dark: 0xF5F5FA)
    static let textSecondary = adaptive(light: 0x6C6C7E, dark: 0x9292A8)
    static let textTertiary  = adaptive(light: 0x9E9EB0, dark: 0x60607A)

    // MARK: Status
    // Tuned toward the brand rather than stock system green/orange/red, so a
    // budget warning still looks like it belongs to this app.

    static let positive = adaptive(light: 0x0E9E7A, dark: 0x2DD4A7)
    static let warning  = adaptive(light: 0xC17A00, dark: 0xF5A524)
    static let danger   = adaptive(light: 0xD32B52, dark: 0xFF4D6D)

    // MARK: Metrics

    enum Radius {
        static let card: CGFloat    = 22
        static let row: CGFloat     = 18
        static let control: CGFloat = 14
        static let chip: CGFloat    = 8
    }

    enum Space {
        static let gutter: CGFloat = 18
        static let card: CGFloat   = 18
        static let tight: CGFloat  = 8
        static let stack: CGFloat  = 14
    }

    // MARK: Type
    // Rounded for anything numeric or headline-weight — it's the strongest
    // non-color signal that separates this from a default SwiftUI app.
    // Body copy stays in system SF so long text remains comfortable.

    static func number(_ size: CGFloat, _ weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func display(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    /// Small all-caps labels ("MONTHLY BUDGET", "SPENT"). Tracking is applied
    /// at the call site via `.brandEyebrow()`.
    static let eyebrow: Font = .system(size: 11, weight: .semibold, design: .rounded)
}
