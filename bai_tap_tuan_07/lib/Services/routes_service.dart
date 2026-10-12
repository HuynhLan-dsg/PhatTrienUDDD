import 'dart:convert';
import 'package:http/http.dart' as http;


class RoutesService {

  //Tiềm đường đi từ 2 điểm

  //* lấy API miễn phí

  static const String apiKey =
      "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjA5OTZiZTJlMjAwOTQ4NTU4MjM1NjYxMWU5ZTBhZjQyIiwiaCI6Im11cm11cjY0In0=";

  //hàm đưa vào đầu và cuối
  Future<Map<String, dynamic>> getRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required String mode,
  }) async {

    final response = await http.post(

      //loại phương tiện di chuyển: đi bộ hay đi oto
      Uri.parse(
        "https://api.openrouteservice.org/v2/directions/$mode/geojson",
      ),

      headers: {
        "Authorization": apiKey,
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        //Gửi dữ liệu
        "coordinates": [
          [startLng, startLat],
          [endLng, endLat]
        ]
      }),
    );

    print(response.body);

    return jsonDecode(
      response.body,
    );
  }
}