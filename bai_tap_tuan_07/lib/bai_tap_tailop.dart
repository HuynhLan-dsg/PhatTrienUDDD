//thêm thư viện
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const String apiKey = "AIzaSyAUkvDsrrncA6Gr9OxGp5iLe4KvOfjnx-w";

  GoogleMapController?
  mapController; // biến google map dùng dể điều khiển bản đồ

  LatLng? currentLocation; // dùng để lưu vị trí hiện tại
  LatLng? destination; // dùng để lưu vị trí đích

  double distance = 0; // tính khoản cách đường chim bay: ví dụ 8.76km

  String distanceText = "";
  String durationText = "";
  //Tính khoản cách và thời gian từ Route API

  String placeType = "hospital"; //Loại địa điểm, mặc định là bệnh viện

  Set<Marker> placeMarkers =
      {}; // lưu danh sách các địa điểm như trường học, bệnh viên, ...

  final TextEditingController destinationController =
      TextEditingController(); // ô nhập liệu điểm đích

  //Todo: Hàm lấy vị trí hiện tại
  Future<void> getCurrentLocation() async {
    //? xin quyền GPS
    LocationPermission permission = await Geolocator.requestPermission();

    //! nếu quyền bị từ chối thì trả về
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    //* Lấy GPS
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      //*Tạo Latlng
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    //* cho phép di chuyển camera
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentLocation!, 16),
    );
  }

  //todo: lấy vị trí hiện tại làm điểm đích
  Future<void> setCurrentLocationAsDestination() async {
    //*Lấy gps
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      //*Lấy gps thành điểm đích
      destination = LatLng(position.latitude, position.longitude);

      //*Hiển thị textfield
      destinationController.text =
          "${position.latitude}, ${position.longitude}";
    });

    //*Tính khoản cách
    calculateDistance();

    //*cho phép di chuyển camera
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(destination!, 16));
  }

  //todo: Hàm tính khoản cách
  void calculateDistance() {
    if (currentLocation == null || destination == null) {
      return;
    }

    final meter =
        //*Google tính khoản cách giữa currentLocation và destination
        Geolocator.distanceBetween(
          currentLocation!.latitude,
          currentLocation!.longitude,
          destination!.latitude,
          destination!.longitude,
        );

    setState(() {
      //*Đổi qua km
      distance = meter / 1000;
    });
  }

  //todo: Route API: mục đích là tính khoản cách thực tế và thời gian thực tế
  Future<void> getRouteInfo() async {
    if (currentLocation == null || destination == null) {
      return;
    }

    final response = await http.post(
      //*Gửi request lên google
      Uri.parse(
        //* API tìm đường của google
        "https://routes.googleapis.com/directions/v2:computeRoutes",
      ),
      headers: {
        //* Nói với Google: Tôi gửi dữ liệu dạng JSON
        "Content-Type": "application/json",
        //* API key: giống như giấy phép
        //? Google dựa vào key này để biết:Ai đang gọi API
        "X-Goog-Api-Key": apiKey,
        //* Chỉ lấy dữ liệu cần thiết:
        //? trả về distanceMeters và duration
        "X-Goog-FieldMask": "routes.distanceMeters,routes.duration",
      },
      //*Gửi dữ liệu đi
      body: jsonEncode({
        //* Điểm ban đầu
        "origin": {
          "location": {
            "latLng": {
              "latitude": currentLocation!.latitude,
              "longitude": currentLocation!.longitude,
            },
          },
        },

        //* điểm cuối
        "destination": {
          "location": {
            "latLng": {
              "latitude": destination!.latitude,
              "longitude": destination!.longitude,
            },
          },
        },

        //* Loại phương tiện
        "travelMode": "DRIVE",
      }),

      //* trả về khoản cách giữa 2 điểm
    );

    //đọc kết quả trả về
    final data = jsonDecode(response.body);

    if (data["routes"] == null) {
      return;
    }

    //* khi gg trả về: distanceMeter: 8500, duration: 1200s
    final route = data["routes"][0]; //* Lấy route đầu tiên

    setState(() {
      //* hiển thị khoản cách
      distanceText =
          "${(route["distanceMeters"] / 1000).toStringAsFixed(2)} km";

      //* hiển tị thời gian
      durationText = route["duration"];
    });
  }

  //todo: mục đích tìm quán ăn, thư viện và bệnh viên
  Future<void> searchNearbyPlaces() async {
    if (currentLocation == null) {
      return;
    }

    placeMarkers.clear();

    final response = await http.post(
      Uri.parse("https://places.googleapis.com/v1/places:searchNearby"),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask": "places.displayName,places.location",
      },
      body: jsonEncode({
        "includedTypes": [placeType],

        "maxResultCount": 20,

        "locationRestriction": {
          "circle": {
            "center": {
              "latitude": currentLocation!.latitude,
              "longitude": currentLocation!.longitude,
            },
            "radius": 5000.0,
          },
        },
      }),
    );

    print(response.body);

    final data = jsonDecode(response.body);

    if (data["places"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["error"]?["message"] ?? "Không lấy được dữ liệu"),
        ),
      );

      return;
    }

    Set<Marker> markers = {};

    for (var place in data["places"]) {
      markers.add(
        Marker(
          markerId: MarkerId(place["displayName"]["text"]),

          position: LatLng(
            place["location"]["latitude"],
            place["location"]["longitude"],
          ),

          infoWindow: InfoWindow(title: place["displayName"]["text"]),
        ),
      );
    }

    setState(() {
      placeMarkers = markers;
    });
  }

  //todo:  tạo danh sách marker
  Set<Marker> buildMarkers() {
    Set<Marker> markers = {};

    //kiểm tra Marker hiện tại
    if (currentLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("current"),
          position: currentLocation!,
          infoWindow: const InfoWindow(title: "Vị trí hiện tại"),
        ),
      );
    }

    //điểm đích
    if (destination != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: destination!,
          infoWindow: const InfoWindow(title: "Điểm đích"),
        ),
      );
    }

    //trả về để google map hiển thị
    return markers;
  }

  //* Hàm tìm kiếm dựa trên loại địa điểm:
  void searchByType(String type) {
    setState(() {
      placeType = type;
    });

    searchNearbyPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bài tập bản đồ")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: destinationController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Điểm đích",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField(
                  value: placeType,
                  items: const [
                    DropdownMenuItem(
                      value: "hospital",
                      child: Text("Bệnh viện"),
                    ),
                    DropdownMenuItem(
                      value: "restaurant",
                      child: Text("Quán ăn"),
                    ),
                    DropdownMenuItem(
                      value: "school",
                      child: Text("Trường học"),
                    ),
                    DropdownMenuItem(
                      value: "lodging",
                      child: Text("Khách sạn"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      placeType = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: getCurrentLocation,
                        child: const Text("Vị trí hiện tại"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: setCurrentLocationAsDestination,
                        child: const Text("Làm điểm đích"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: getRouteInfo,
                        child: const Text("Tính đường đi"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: searchNearbyPlaces,
                        child: const Text("Tìm địa điểm"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  "Khoảng cách thẳng: "
                  "${distance.toStringAsFixed(2)} km",
                ),

                Text(
                  "Khoảng cách thực tế: "
                  "$distanceText",
                ),

                Text(
                  "Thời gian: "
                  "$durationText",
                ),
              ],
            ),
          ),

          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(10.8231, 106.6297),
                zoom: 14,
              ),

              onMapCreated: (controller) {
                mapController = controller;
              },

              onTap: (LatLng point) {
                setState(() {
                  destination = point;

                  destinationController.text =
                      "${point.latitude}, ${point.longitude}";
                });

                calculateDistance();
              },

              markers: {...buildMarkers(), ...placeMarkers},
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  searchByType("hospital");
                },
                icon: const Icon(Icons.local_hospital),
                label: const Text("Bệnh viện"),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  searchByType("school");
                },
                icon: const Icon(Icons.school),
                label: const Text("Trường học"),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  searchByType("restaurant");
                },
                icon: const Icon(Icons.restaurant),
                label: const Text("Quán ăn"),
              ),

              ElevatedButton.icon(
                onPressed: () {
                  searchByType("lodging");
                },
                icon: const Icon(Icons.hotel),
                label: const Text("Khách sạn"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
