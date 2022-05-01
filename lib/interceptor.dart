import 'package:http_interceptor/http_interceptor.dart';
import 'package:expensenoted/secure_storage.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.headers['authorization'] = (await SecureStorage.readToken())!;

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
