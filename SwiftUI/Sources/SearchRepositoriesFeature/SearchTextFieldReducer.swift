import ComposableArchitecture
import Foundation

public struct SearchTextFieldReducer: Reducer, Sendable {
  public struct State: Equatable {
    @BindingState var text: String = ""
  }
  
  public enum Action: BindableAction, Equatable, Sendable {
    case binding(BindingAction<State>)
    case searchIconTapped
    case clearTextField
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .searchIconTapped:
        return .none
      case .clearTextField:
        return .none
      }
    }
  }
}
