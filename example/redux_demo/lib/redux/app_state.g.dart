// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final bool loggedIn;
  @override
  final BuiltList<Book> books;
  @override
  final String? selectedBookId;
  @override
  final BuiltList<String> dialogs;

  factory _$AppState([void Function(AppStateBuilder)? updates]) =>
      (new AppStateBuilder()..update(updates))._build();

  _$AppState._(
      {required this.loggedIn,
      required this.books,
      this.selectedBookId,
      required this.dialogs})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(loggedIn, r'AppState', 'loggedIn');
    BuiltValueNullFieldError.checkNotNull(books, r'AppState', 'books');
    BuiltValueNullFieldError.checkNotNull(dialogs, r'AppState', 'dialogs');
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        loggedIn == other.loggedIn &&
        books == other.books &&
        selectedBookId == other.selectedBookId &&
        dialogs == other.dialogs;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, loggedIn.hashCode), books.hashCode),
            selectedBookId.hashCode),
        dialogs.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppState')
          ..add('loggedIn', loggedIn)
          ..add('books', books)
          ..add('selectedBookId', selectedBookId)
          ..add('dialogs', dialogs))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState? _$v;

  bool? _loggedIn;
  bool? get loggedIn => _$this._loggedIn;
  set loggedIn(bool? loggedIn) => _$this._loggedIn = loggedIn;

  ListBuilder<Book>? _books;
  ListBuilder<Book> get books => _$this._books ??= new ListBuilder<Book>();
  set books(ListBuilder<Book>? books) => _$this._books = books;

  String? _selectedBookId;
  String? get selectedBookId => _$this._selectedBookId;
  set selectedBookId(String? selectedBookId) =>
      _$this._selectedBookId = selectedBookId;

  ListBuilder<String>? _dialogs;
  ListBuilder<String> get dialogs =>
      _$this._dialogs ??= new ListBuilder<String>();
  set dialogs(ListBuilder<String>? dialogs) => _$this._dialogs = dialogs;

  AppStateBuilder();

  AppStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loggedIn = $v.loggedIn;
      _books = $v.books.toBuilder();
      _selectedBookId = $v.selectedBookId;
      _dialogs = $v.dialogs.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppState build() => _build();

  _$AppState _build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              loggedIn: BuiltValueNullFieldError.checkNotNull(
                  loggedIn, r'AppState', 'loggedIn'),
              books: books.build(),
              selectedBookId: selectedBookId,
              dialogs: dialogs.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'books';
        books.build();

        _$failedField = 'dialogs';
        dialogs.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
