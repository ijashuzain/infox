import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infox/model/pincode_response_model.dart';

class PinCodeProvider extends ChangeNotifier {
  //
  static String pinCodeUrl = "https://api.postalpincode.in/pincode/";
  var dio = Dio();
  bool isFetching = false;
  List<PostOffice>? postOffices;

  Future<PinCodeResponse?> fetchPinCodeData(String pinCode) async {
    _setFetchingPinCodeData(true);
    try {
      var response = await dio.get(
        "$pinCodeUrl$pinCode",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        PinCodeResponse pinCodeResponse = PinCodeResponse.fromJson(
          response.data[0],
        );
        postOffices = pinCodeResponse.postOffice;
        _setFetchingPinCodeData(false);
        return pinCodeResponse;
      } else {
        _setFetchingPinCodeData(false);
        return null;
      }
    } catch (e) {
      postOffices = null;
      _setFetchingPinCodeData(false);
      print(e);
    }
  }

  _setFetchingPinCodeData(bool value) {
    isFetching = value;
    notifyListeners();
  }
}
