sealed class ApiResult<T> {}
class Success<T> extends ApiResult<T>{
  T response;
  Success(this.response);
}
class Error<T> extends ApiResult<T>{
  String message;
  Error(this.message);
}