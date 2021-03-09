import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:sentient_app/component/loading.dart';
import 'package:sentient_app/config/server.dart';
import 'package:sentient_app/tool/error_entity.dart';

/**
 * http 工具类
 *
 * 手册: https://github.com/flutterchina/dio/blob/master/README-ZH.md
 *
 */
class HttpUtil {
  //单列HttpUtil类，全局共用

  // 工厂模式 : 单例公开访问点
  factory HttpUtil() => _getInstance();
  static HttpUtil get instance => _getInstance();
  // 静态私有成员，没有初始化
  static HttpUtil _instance;
  //静态获取对象
  static HttpUtil _getInstance(){
    if(_instance == null){
      _instance = HttpUtil._internal();
    }
    return _instance;
  }
  // 私有构造函数
  HttpUtil._internal(){
    //初始化

    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      baseUrl: getBaseApiUrl(),
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 50000,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 30000,
      // Http请求头.
      headers: {},

      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    dio = Dio(options);

    // Cookie管理
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    //拦截器在响应过程种做一些事情，目前只打印
    dio.interceptors.add(InterceptorsWrapper(
        onRequest:(RequestOptions options) async {
          print("请求之前");
          print(options.uri);
          Loading.before(options.uri);
          // 在请求被发送之前做一些事情
          return options; //continue
          // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
          // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
          //
          // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
          // 这样请求将被中止并触发异常，上层catchError会被调用。
        },
        onResponse:(Response response) async {
          // 在返回响应数据之前做一些预处理
          print("响应之前");
          Loading.complete(response.request.uri);
          return response; // continue
        },
        onError: (DioError e) async {
          // 当请求失败时做一些预处理
          print("请求失败之前");
          print(e);
          Loading.complete(e.request.uri);
          return e;//continue
        }
    ));
    //添加 LogInterceptor 拦截器来自动打印请求、响应日志
    dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志
  }

  Dio dio;

//  getBaseApiUrl(){
//    return SERVER_API_URL;
//  }


  /*
   * error统一处理
   */
  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    print("createErrorEntity ");
    print(error.message);
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return ErrorEntity(code: ServerErrorCode, message: "Request Cancelled"); //请求取消
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return ErrorEntity(code: ServerErrorCode, message: "Connection Timeout");//连接超时
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return ErrorEntity(code: ServerErrorCode, message: "Request Timeout");//请求超时
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return ErrorEntity(code: ServerErrorCode, message: "Response Timeout");//响应超时
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                {
                  return ErrorEntity(code: errCode, message: "Request Syntax Error");//请求语法错误
                }
                break;
              case 401:
                {
                  return ErrorEntity(code: errCode, message: "No Permission");//没有权限
                }
                break;
              case 403:
                {
                  return ErrorEntity(code: errCode, message: "Server Rejected Executing");//服务器拒绝执行
                }
                break;
              case 404:
                {
                  return ErrorEntity(code: errCode, message: "Unable to Connect to Server");//无法连接服务器
                }
                break;
              case 405:
                {
                  return ErrorEntity(code: errCode, message: "Request Method was Baned");//请求方法被禁止
                }
                break;
              case 500:
                {
                  return ErrorEntity(code: errCode, message: "Server Internal Error");//服务器内部错误
                }
                break;
              case 502:
                {
                  return ErrorEntity(code: errCode, message: "Invalid Request");//无效的请求
                }
                break;
              case 503:
                {
                  return ErrorEntity(code: errCode, message: "Server is Down");//服务器挂了
                }
                break;
              case 505:
                {
                  return ErrorEntity(code: errCode, message: "Unsupported HTTP Protocol Request");//不支持HTTP协议请求
                }
                break;
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  return ErrorEntity(
                      code: errCode, message: error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "Unknown Error");//未知错误
          }
        }
        break;
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// 读取本地配置
  Future<Options> getLocalOptions() async{
    String token = "PageService().token";
    print("网络层传输的token：$token");

    Options options;
    options = Options(headers: {
//      'Accept-Language': AppLanguage.curLanguageCode == 'zh' ? 'zh-cn' : 'en',
      'token': token == null ? "" : '$token',
//      "ClientUniqueID": PageService().deviceId,
    });

    return options;
  }
  ///返回值统一处理
  dynamic _adapterResponseData(dynamic data){

    Map<String, dynamic> orgData = data;
    dynamic _data = orgData["data"];

    int stateCode = num.parse('${orgData["code"]}');
    String message = orgData["message"];
    print("_adapterResponseData Success $stateCode with message $message");

    if (stateCode == ServerSuccessCode){

      if (_data != null && !(_data is List<dynamic>)){
        print("[A] D A T A return data-Data");

        print('E N D   O F   R E Q U E S T');

        return data["data"];
      }
      else if (_data == null){
        data["data"] = [];
         }else{
        print("[C] N O T List<dynamic> return data");
      }

      print('E N D   O F   R E Q U E S T');

      return data;
    } else if (stateCode == ServerNotFoundCode){

    } else if (stateCode == ServerFailCode){

    } else if (stateCode == ServerErrorCode){

    } else if (stateCode == ServeConflictCode){

    } else if (stateCode == ServeTokenCode){
//      print("token error $context");
//      if(context!=null){
////        EasyLoading.showToast(message);
//        Future.delayed(Duration(milliseconds:1500),(){
//          PageService().token=null;
//          Navigator.of(context).pushNamedAndRemoveUntil("login_page",(route)=>false);
//        });
//      }
    }
    print("_adapterResponseData Error $stateCode with $message");
    ErrorEntity e = ErrorEntity(code: stateCode, message: message);
    throw e;
  }

  /// restful get 操作
  Future get(String path,
      {dynamic params, Options options, CancelToken cancelToken}) async {
    try {
      print('\n\n\nSTART GET\n\n\n');
      DateTime startTime = DateTime.now();

      print("options is:");
      print(options.toString());
      var tokenOptions = await getLocalOptions();
      var response = await dio.get(path,
          queryParameters: params,
          options: tokenOptions,
          cancelToken: cancelToken);
      DateTime endTime = DateTime.now();
      print('\n\n\n[B] E M P T Y ${endTime.difference(startTime).inMilliseconds} Milliseconds\n\n\n');
      return _adapterResponseData(response.data);
    } on DioError catch (e) {
      print(e);
      throw createErrorEntity(e);
    }
  }

  /// restful post 操作
  Future post(String path,
      {dynamic params, Options options, CancelToken cancelToken}) async {
    try {
      print('S T A R T   O F   R E Q U E S T');
      print('\n\n\nSTART POST\n\n\n');
      DateTime startTime = DateTime.now();

      var tokenOptions = await getLocalOptions();
      var response = await dio.post(path,
          data: params, options: tokenOptions, cancelToken: cancelToken);
      DateTime endTime = DateTime.now();
      print('\n\n\n[B] E M P T Y ${endTime.difference(startTime).inMilliseconds} Milliseconds\n\n\n');
      return _adapterResponseData(response.data);
    } on DioError catch (e) {
      throw createErrorEntity(e);
    }
  }

  /// restful put 操作
  Future put(String path,
      {dynamic params, Options options, CancelToken cancelToken}) async {
    try {
      print('S T A R T   O F   R E Q U E S T');
      print('\n\n\nSTART PUT\n\n\n');
      DateTime startTime = DateTime.now();

      var tokenOptions = options ?? await getLocalOptions();
      var response = await dio.put(path,
          data: params, options: tokenOptions, cancelToken: cancelToken);
      DateTime endTime = DateTime.now();
      print('\n\n\n[B] E M P T Y ${endTime.difference(startTime).inMilliseconds} Milliseconds\n\n\n');
      return _adapterResponseData(response.data);
    } on DioError catch (e) {
      throw createErrorEntity(e);
    }
  }

  /// restful delete 操作
  Future delete(String path,
      {dynamic params, Options options, CancelToken cancelToken}) async {
    try {
      print('S T A R T   O F   R E Q U E S T');
      print('\n\n\nSTART DELETE\n\n\n');
      DateTime startTime = DateTime.now();

      var tokenOptions = options ?? await getLocalOptions();
      var response = await dio.delete(path,
          data: params, options: tokenOptions, cancelToken: cancelToken);
      DateTime endTime = DateTime.now();
      print('\n\n\n[B] E M P T Y ${endTime.difference(startTime).inMilliseconds} Milliseconds\n\n\n');
      return _adapterResponseData(response.data);
    } on DioError catch (e) {
      throw createErrorEntity(e);
    }
  }

  /// restful post form 表单提交操作
  Future postForm(String path,
      {dynamic params, Options options, CancelToken cancelToken}) async {
    try {
      print('S T A R T   O F   R E Q U E S T');
      print('\n\n\nSTART POST FORM\n\n\n');
      DateTime startTime = DateTime.now();

      var tokenOptions = options ?? await getLocalOptions();
      var response = await dio.post(path,
          data: FormData.fromMap(params),
          options: tokenOptions,
          cancelToken: cancelToken);
      DateTime endTime = DateTime.now();
      print('\n\n\n[B] E M P T Y ${endTime.difference(startTime).inMilliseconds} Milliseconds\n\n\n');
      return _adapterResponseData(response.data);
    } on DioError catch (e) {
      throw createErrorEntity(e);
    }
  }
  

}

