class FavoriteRoute {
  int? id;

  String startAddress;

  String endAddress;

  String distance;

  String duration;

  FavoriteRoute({
    this.id,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "startAddress": startAddress,
      "endAddress": endAddress,
      "distance": distance,
      "duration": duration,
    };
  }

  factory FavoriteRoute.fromMap(
    Map<String, dynamic> map,
  ) {
    return FavoriteRoute(
      id: map["id"],
      startAddress: map["startAddress"],
      endAddress: map["endAddress"],
      distance: map["distance"],
      duration: map["duration"],
    );
  }
}