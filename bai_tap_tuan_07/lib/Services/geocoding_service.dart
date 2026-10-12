import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GeocodingService {

  //đưa địa chỉ để trả về tọa độ
  Future<LatLng?> getCoordinates(
      String address) async {

    final url = Uri.parse(
      //Nominatim là dịch vụ của OpenStreetMap
      "https://nominatim.openstreetmap.org/search"
      "?q=$address"
      "&format=jsonv2",
    );

    //gửi request trả về kết quả là tọa độ
    final response = await http.get(
      url,
      headers: {
        "User-Agent": "FlutterApp",
      },
    );

    final data =
        jsonDecode(response.body);

    if (data.isEmpty) {
      return null;
    }

    // trả từ "1009220" -> 1009220
    return LatLng(
      double.parse(
        data[0]["lat"],
      ),
      double.parse(
        data[0]["lon"],
      ),
    );
  }
}