import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  Api();
  final String _url = 'http://192.168.0.121:8000/api/';

  Future getData(apiUrl)async{
    var fullUrl = _url + apiUrl;
    var url = Uri.parse(fullUrl);
    var token = await _getToken();
    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }

  Future postData(apiUrl,data)async{

    var fullUrl = _url + apiUrl;
    var url = Uri.parse(fullUrl);
    var token = await _getToken();
    var response = await http.post(
      url,
      body:json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }



  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    // print(token.toString());
    return token;
  }
}
