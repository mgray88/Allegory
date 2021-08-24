//
// Created by Mike on 8/21/21.
//

/// A color gradient represented as an array of color stops, each having a
/// parametric location value.
public struct Gradient: Equatable {

    /// One color stop in the gradient.
    public struct Stop: Equatable {

        /// The color for the stop.
        public var color: Color

        /// The parametric location of the stop.
        ///
        /// This value must be in the range `[0, 1]`.
        public var location: CGFloat

        public init(color: Color, location: CGFloat) {
            self.color = color
            self.location = location
        }
    }

    /// The array of color stops.
    public var stops: [Gradient.Stop]

    /// Creates a gradient from an array of color stops.
    public init(stops: [Stop]) {
        self.stops = stops
    }

    /// Creates a gradient from an array of colors.
    ///
    /// The gradient synthesizes its location values to evenly space the colors
    /// along the gradient.
    public init(colors: [Color]) {
        stops = colors.enumerated().map { index, color in
            Stop(
                color: color,
                location: CGFloat(index) / abs(CGFloat(colors.count - 1))
            )
        }
    }
}
