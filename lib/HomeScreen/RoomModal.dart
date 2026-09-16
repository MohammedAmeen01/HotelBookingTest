
class RoomModal {

  String roomcode;
  String roomtype;
  double pricepernight;
  int maxguests;
  int defaultguests;

  RoomModal(
    this.roomcode,
    this.roomtype,
    this.pricepernight,
    this.maxguests,
    this.defaultguests
  );

  factory RoomModal.fromJson(Map<String, dynamic> json) {
    return RoomModal(
      json['roomcode'],
      json['roomtype'],
      json['pricepernight'],
      json['maxguests'],
      json['defaultguests']
    );}

}