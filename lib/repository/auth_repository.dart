import 'package:cage/data/network/baseapiservices.dart';
import 'package:cage/data/network/networkapiservices.dart';
import 'package:cage/res/components/app_url.dart';

class AuthRepository {
  final Baseapiservices _apiServices = Networkapiservices();

  Future<dynamic> loginApi(dynamic data,dynamic header) async {
    try {
      dynamic reponse = await _apiServices.getPostApiResponse(
        AppUrl.loginUrl,
        data,
        header,
      );
      return reponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sginUpApi(dynamic data, Map<String, String> header) async {
    try {
      dynamic reponse = await _apiServices.getPostApiResponse(
        AppUrl.sginupUrl,
        data,
        header,
      );
      return reponse;
    } catch (e) {
      rethrow;
    }
  }
}
