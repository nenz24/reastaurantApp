sealed class ApiState<T> {
  const ApiState();
}

class Loading<T> extends ApiState<T> {
  const Loading();
}

// Success state dengan data
class Success<T> extends ApiState<T> {
  final T data;
  const Success(this.data);
}

// Error state dengan message
class Error<T> extends ApiState<T> {
  final String message;
  const Error(this.message);
}
