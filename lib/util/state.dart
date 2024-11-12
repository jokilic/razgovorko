sealed class RazgovorkoState<T> {}

class Initial<T> extends RazgovorkoState<T> {}

class Loading<T> extends RazgovorkoState<T> {}

class Empty<T> extends RazgovorkoState<T> {}

class Error<T> extends RazgovorkoState<T> {
  final String? error;

  Error({
    required this.error,
  });
}

class Success<T> extends RazgovorkoState<T> {
  final T data;

  Success({
    required this.data,
  });
}
