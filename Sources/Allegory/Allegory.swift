
@_exported import CoreGraphics
@_exported import QuartzCore

#if canImport(Identifiable)
    @_exported import Identifiable
    public typealias Identifiable = Identifiable.Identifiable
#elseif canImport(AllegoryIdentifiable)
    @_exported import AllegoryIdentifiable
    public typealias Identifiable = AllegoryIdentifiable.Identifiable
#endif
