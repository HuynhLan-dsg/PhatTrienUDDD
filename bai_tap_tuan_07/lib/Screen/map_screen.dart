import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../Services/routes_service.dart';
import '../Services/geocoding_service.dart';

import '../Database/database_helper.dart';
import '../Models/favourite_route.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //todo: khai báo biến: mục đích là điều khiển camera trên gg máp
  GoogleMapController? mapController;

  LatLng? currentLocation; //* Lưu vị trí hiện tại
  LatLng? destination; //* Lưu điểm đích

  String travelMode = "DRIVE"; //* Chọn phương tiện

  String distanceText = ""; //* hiển thị kết quả  khoản cách
  String durationText = ""; //* hiển thị kết quả thời gian

  final GeocodingService geocodingService =
      GeocodingService(); //? gọi hàm trong services
  final TextEditingController startController = TextEditingController();

  final TextEditingController endController = TextEditingController();
  final RoutesService routesService = RoutesService(); //? gọi hàm trên services

  //Lưu vị trí hiện tại, điểm đầu, kết thúc
  Set<Marker> markers = {};

  //Vẽ biểu đồ
  Set<Polyline> polylines = {};

  //* Khai báo danh sách yêu thích
  List<FavoriteRoute> favoriteRoutes = [];

  @override
  //* Khi mở app thì tự động lấy vị trí hiện tại
  void initState() {
    super.initState();
    getCurrentLocation();

    //*tự động mở tiến đường yêu thích
    loadFavoriteRoutes();
  }

  //todo: lấy vị trí hiện tại
  Future<void> getCurrentLocation() async {
    //* Xin quyền google map
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    //* lấy vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      //* tạo latlng
      currentLocation = LatLng(position.latitude, position.longitude);

      markers.add(
        Marker(
          markerId: const MarkerId("current"),
          position: currentLocation!,
          infoWindow: const InfoWindow(title: "Vị trí hiện tại"),
        ),
      );
    });

    //* di chuyển camera
    mapController?.animateCamera(
      //* Nhảy tới vị trí hiện tại
      CameraUpdate.newLatLngZoom(currentLocation!, 16),
    );
  }

  //* Lấy vị trí hiện tại làm điểm đich
  Future<void> setCurrentLocationAsDestination() async {
    //* Lấy GPS
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      //* Gán
      destination = LatLng(position.latitude, position.longitude);

      //* hiển thị textfield
      endController.text = "${position.latitude}, ${position.longitude}";

      markers.removeWhere((element) => element.markerId.value == "destination");

      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: destination!,
          infoWindow: const InfoWindow(title: "Điểm đích"),
        ),
      );
    });
  }

  void clearRoute() {
    setState(() {
      //Xóa đường vẽ
      polylines.clear();

      //Xóa kết quả cũ
      distanceText = "";

      durationText = "";
    });
  }

  //todo: vẽ đường đi
  void drawRoute(Map<String, dynamic> data) {
    print(data);

    if (data["features"] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["error"]?["message"] ?? "Không tìm được đường đi"),
        ),
      );

      return;
    }

    final coordinates = data["features"][0]["geometry"]["coordinates"];

    List<LatLng> routePoints = [];

    for (var item in coordinates) {
      routePoints.add(LatLng(item[1], item[0]));
    }

    final summary = data["features"][0]["properties"]["summary"];

    setState(() {
      polylines.clear();

      polylines.add(
        //Vẽ đường đi
        Polyline(
          polylineId: const PolylineId("route"),
          points: routePoints,
          color: Colors.blue,
          width: 6,
        ),
      );

      distanceText =
          "${(summary["distance"] / 1000).toStringAsFixed(2)} km"; // khoản cách

      durationText =
          "${(summary["duration"] / 60).toStringAsFixed(0)} phút"; // thời gian
    });
  }

  //todo
  Future<void> findRoute() async {
    //* Chuyển địa chỉ thành tọa độ.
    LatLng? start = await geocodingService.getCoordinates(startController.text);

    //*Lấy điểm đích.
    LatLng? end;

    if (destination != null) {
      //*Nếu click bản đồ:
      end = destination;
    } else {
      //*Nếu nhập địa chỉ:
      end = await geocodingService.getCoordinates(endController.text);
    }
    print("START LAT = ${start?.latitude}");
    print("START LNG = ${start?.longitude}");

    print("END LAT = ${end?.latitude}");
    print("END LNG = ${end?.longitude}");

    if (start == null || end == null) {
      return;
    }

    //*Chọn phương tiện.
    String mode = "driving-car";

    if (travelMode == "WALK") {
      mode = "foot-walking";
    }

    if (travelMode == "TWO_WHEELER") {
      mode = "cycling-regular";
    }

    //?Gọi RoutesService.

    //*Nhận dữ liệu.
    final data = await routesService.getRoute(
      startLat: start.latitude,
      startLng: start.longitude,
      endLat: end.latitude,
      endLng: end.longitude,
      mode: mode,
    );

    //*drawRoute(data);
    drawRoute(data);

    markers.removeWhere((m) => m.markerId.value == "start");

    markers.removeWhere((m) => m.markerId.value == "destination");

    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("start"),
          position: start,
          infoWindow: const InfoWindow(title: "Điểm bắt đầu"),
        ),
      );

      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: end!,
          infoWindow: const InfoWindow(title: "Điểm đến"),
        ),
      );
    });

    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            start.latitude < end.latitude ? start.latitude : end.latitude,
            start.longitude < end.longitude ? start.longitude : end.longitude,
          ),
          northeast: LatLng(
            start.latitude > end.latitude ? start.latitude : end.latitude,
            start.longitude > end.longitude ? start.longitude : end.longitude,
          ),
        ),
        100,
      ),
    );
  }

  //*Kiểm tra Geocoding
  Future<void> testGeocoding() async {
    LatLng? location = await geocodingService.getCoordinates(
      startController.text,
    );

    if (location == null) {
      return;
    }

    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("start"),
          position: location,
          infoWindow: const InfoWindow(title: "Điểm bắt đầu"),
        ),
      );
    });

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
  }

  //todo: Load dữ liệu
  Future<void> loadFavoriteRoutes() async {
    final routes = await DatabaseHelper.instance.getRoutes();

    setState(() {
      favoriteRoutes = routes;
    });
  }

  //todo: hàm thêm tiến đường
  Future<void> saveFavoriteRoute() async {
    if (distanceText.isEmpty) {
      return;
    }

    FavoriteRoute route = FavoriteRoute(
      startAddress: startController.text,

      endAddress: endController.text,

      distance: distanceText,

      duration: durationText,
    );

    await DatabaseHelper.instance.insertRoute(route);

    await loadFavoriteRoutes();

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Đã lưu tuyến đường")));
    }
  }

  //* Hàm xóa tuyến đường yêu thích
  Future<void> deleteRoute(int id) async {
    await DatabaseHelper.instance.deleteRoute(id);

    await loadFavoriteRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bài tập bản đồ")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: startController,
                  decoration: const InputDecoration(
                    labelText: "Điểm bắt đầu",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: endController,
                  decoration: const InputDecoration(
                    labelText: "Điểm đến",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField(
                  value: travelMode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "DRIVE", child: Text("Ô tô")),

                    DropdownMenuItem(value: "WALK", child: Text("Đi bộ")),

                    DropdownMenuItem(
                      value: "TWO_WHEELER",
                      child: Text("Xe máy"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      travelMode = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: getCurrentLocation,
                        child: const Text("GPS hiện tại"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: setCurrentLocationAsDestination,
                        child: const Text("Làm đích"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: testGeocoding,
                      child: const Text("Test Geocoding"),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: findRoute,
                        child: const Text("Tìm đường"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: saveFavoriteRoute,
                        child: const Text("Lưu yêu thích"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: clearRoute,
                        child: const Text("Xóa đường"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text("Khoảng cách: $distanceText"),

                Text("Thời gian: $durationText"),
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

                  endController.text = "${point.latitude}, ${point.longitude}";

                  markers.removeWhere((e) => e.markerId.value == "destination");

                  markers.add(
                    Marker(
                      markerId: const MarkerId("destination"),
                      position: point,
                    ),
                  );
                });
              },

              markers: markers,

              polylines: polylines,

              myLocationEnabled: true,

              myLocationButtonEnabled: true,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteRoutes.length,

              itemBuilder: (context, index) {
                final route = favoriteRoutes[index];

                return Card(
                  child: ListTile(
                    title: Text(route.endAddress),

                    subtitle: Text(
                      "${route.distance}\n"
                      "${route.duration}",
                    ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete),

                      onPressed: () {
                        deleteRoute(route.id!);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
