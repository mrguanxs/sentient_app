const int ServerSuccessCode = 1000;
const int ServerFailCode = 1001;
const int ServerErrorCode = 1002;
const int ServerNotFoundCode = 1404;
const int ServeConflictCode = 1409;
const int ServeTokenCode = 1401;

// 异常处理
class ErrorEntity implements Exception {
  int code;
  String message;
  ErrorEntity({this.code, this.message}){
    code = code;
    message = message;
  }

  String toString() {
    if (message == null) return "Exception: code $code";
    return "$message";
  }
}