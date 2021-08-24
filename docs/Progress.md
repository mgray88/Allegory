## Progress



### Legend

| Symbol | Description |
| --- | --- |
| ✅ | Done |
| ❌ | Open |
| 🚧 | Incomplete |

### Views and Controls

#### Essentials

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `protocol View` |
| 🚧 | `protocol App` |
| 🚧 | `protocol Scene` |

#### Text

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Text` | |
| ❌ | `struct TextField` | |
| ❌ | `struct SecureField` | |
| ✅ | `struct Font` | |

#### Images

| Status | Name | Notes |
| --- | --- | --- |
| 🚧 | `struct Image` | CGImage not supported |

#### Buttons

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Button` | |
| ❌ | `struct NavigationLink` | |
| ❌ | `struct MenuButton` | |
| ❌ | `struct EditButton` | |
| ❌ | `struct PasteButton` | |

#### Value Selectors

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Toggle` | |
| ❌ | `struct Picker` | |
| ❌ | `struct DatePicker` | |
| ✅ | `struct Slider` | |
| 🚧 | `struct Stepper` | |

#### Supporting Types

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct ViewBuilder` | |
| ✅ | `protocol ViewModifier` | |


### View Layout and Presentation

#### Stacks

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct HStack` | |
| ✅ | `struct VStack` | |
| ✅ | `struct ZStack` | |

#### Lists and Scroll Views

| Status | Name | Notes |
| --- | --- | --- |
| ❌ | `struct List` | |
| ❌ | `protocol DynamicViewContent` | |
| ✅ | `protocol Identifiable` | AllegoryIdentifiable |
| 🚧 | `struct ForEach` | |
| 🚧 | `struct ScrollView` | |
| ✅ | `enum Axis` | |

#### Container Views

| Status | Name | Notes |
| --- | --- | --- |
| ❌ | `struct Form` | |
| 🚧 | `struct Group` | |
| ❌ | `struct GroupBox` | |
| ❌ | `struct Section` | |

#### Spacer and Dividers

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Spacer` | |
| ❌ | `struct Divider` | |

#### Architectural Views

| Status | Name | Notes |
| --- | --- | --- |
| 🚧 | `struct NavigationView` | |
| 🚧 | `struct TabView` | |
| ❌ | `struct HSplitView` | |
| ❌ | `struct VSplitView` | |

#### Presentations

| Status | Name | Notes |
| --- | --- | --- |
| ❌ | `struct Alert` | |
| ❌ | `struct ActionSheet` | |

#### Conditionally Visible Items

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct EmptyView` | |
| ❌ | `struct EquatableView` | |

#### Infrequently Used Views

| Status | Name | Notes |
| --- | --- | --- |
| 🚧 | `struct AnyView` | `init?(_fromValue value: Any)` missing. |
| ✅ | `struct TupleView` | |

### Drawing and Animation

##### Essentials

| Status | Name | Notes |
| --- | --- | --- |
| 🚧 | `protocol Shape` | |

#### Animation

| Status | Name | Notes |
| --- | --- | --- |
| 🚧 | `struct Animation` | |
| 🚧 | `protocol Animatable` | |
| 🚧 | `protocol AnimatableModifier` | |
| 🚧 | `func withAnimation<Result>(Animation?, () -> Result) -> Result` | |
| ✅ | `struct AnimationPair` | |
| ✅ | `struct EmptyAnimationData` | |
| ✅ | `struct AnyTransition` | |

#### Shapes

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Rectangle` | |
| ✅ | `enum Edge` | |
| ✅ | `struct RoundedRectangle` | |
| ✅ | `struct Circle` | |
| ✅ | `struct Ellipse` | |
| ✅ | `struct Capsule` | |
| ✅ | `struct Path` | |

#### Transformed Shapes

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `protocol InsettableShape` | |
| 🚧 | `struct ScaledShape` | |
| 🚧 | `struct RotatedShape` | |
| 🚧 | `struct OffsetShape` | |
| 🚧 | `struct TransformedShape` | |

#### Paints, Styles, and Gradients

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Color` | |
| ❌ | `struct ImagePaint` | |
| 🚧 | `struct Gradient` | |
| 🚧 | `struct LinearGradient` | |
| 🚧 | `struct AngularGradient` | |
| 🚧 | `struct RadialGradient` | |
| 🚧 | `struct ForegroundStyle` | |
| ✅ | `struct FillStyle` | |
| 🚧 | `protocol ShapeStyle` | |
| ✅ | `enum RoundedCornerStyle` | |
| ❌ | `struct SelectionShapeStyle` | |
| ❌ | `struct SeparatorShapeStyle` | |
| ✅ | `struct StrokeStyle` | |

#### Geometry

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct GeometryProxy` | |
| ✅ | `struct GeometryReader` | |
| 🚧 | `protocol GeometryEffect` | |
| ✅ | `struct Angle` | |
| ❌ | `struct Anchor` | |
| ✅ | `struct UnitPoint` | |
| ❌ | `enum CoordinateSpace` | |
| ✅ | `struct ProjectionTransform` | |
| ✅ | `protocol VectorArithmetic` | |

### State and Data Flow

#### Bindings

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Binding` | |

#### Data-Dependent Views

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct State` | |
| ✅ | `struct ObservedObject` | |
| ✅ | `struct EnvironmentObject` | |
| ❌ | `struct FetchRequest` | |
| ❌ | `struct FetchedResults` | |
| 🚧 | `protocol DynamicProperty` | `func update()` missing. |

#### Environment Values

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Environment` | |
| ✅ | `struct EnvironmentValues` | |

#### Preferences

| Status | Name | Notes |
| --- | --- | --- |
| ❌ | `protocol PreferenceKey` | |
| ❌ | `struct LocalizedStringKey` | |

#### Transactions

| Status | Name | Notes |
| --- | --- | --- |
| ✅ | `struct Transaction` | |

### Gestures

#### Basic Gestures

| Status | Name | Notes |
| --- | --- | --- |
| 🚧 | `struct TapGesture` | |
| ❌ | `struct LongPressGesture` | |
| ❌ | `struct DragGesture` | |
| ❌ | `struct MagnificationGesture` | |
| ❌ | `struct RotationGesture` | |

#### Combined Gestures

| Status | Name | Notes |
| --- | --- | --- |
| ❌ | `struct SequenceGesture` | |
| ❌ | `struct SimultaneousGesture` | |
| ❌ | `struct ExclusiveGesture` | |

#### Custom Gesture

| Status | Name | Notes |
| --- | --- | --- |
| 🚧 | `protocol Gesture` | |
| 🚧 | `struct AnyGesture` | |

#### Dynamic View Properties

| Status | Name | Notes |
| --- | --- | --- |
| ❌ | `struct GestureState` | |
| ❌ | `struct GestureStateGesture` | |

#### Gesture Support

| Status | Name | Notes |
| --- | --- | --- |
| ❌ | `struct GestureMask` | |
| ❌ | `struct EventModifiers` | |

