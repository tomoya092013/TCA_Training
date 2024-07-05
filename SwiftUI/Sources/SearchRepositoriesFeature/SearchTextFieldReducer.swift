import ComposableArchitecture
import Foundation

struct SearchTextFieldReducer: Reducer {
  struct State: Equatable {
    @BindingState var text: String = ""
  }
  
  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case searchIconTapped
    case clearTextField
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .searchIconTapped:
        return .none
      case .clearTextField:
        print("あ")
        state.text = ""
        return .none
      }
    }
  }
}
