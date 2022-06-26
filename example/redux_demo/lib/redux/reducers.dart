import 'package:example/redux/actions.dart';
import 'package:example/redux/app_state.dart';
import 'package:redux/redux.dart';

Reducer<AppState> appReducers() => combineReducers<AppState>([
      TypedReducer(_onSetLoggedInAction),
      TypedReducer(_onSetBooksAction),
      TypedReducer(_onSetSelectedBookIdAction),
      TypedReducer(_onShowDialogAction),
      TypedReducer(_onHideDialogAction),
    ]);

AppState _onSetLoggedInAction(
  AppState state,
  SetLoggedInAction action,
) =>
    state.rebuild((s) => s.loggedIn = action.loggedIn);

AppState _onSetBooksAction(
  AppState state,
  SetBooksAction action,
) =>
    state.rebuild((s) => s.books.replace(action.books));

AppState _onSetSelectedBookIdAction(
  AppState state,
  SetSelectedBookIdAction action,
) =>
    state.rebuild((s) => s.selectedBookId = action.id);

AppState _onShowDialogAction(
  AppState state,
  ShowDialogAction action,
) =>
    state.rebuild((s) => s.dialogs.add(action.text));

AppState _onHideDialogAction(
  AppState state,
  HideDialogAction action,
) =>
    state.dialogs.isEmpty ? state : state.rebuild((s) => s.dialogs.removeAt(0));
