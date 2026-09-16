
import 'package:room_service_x/HomeScreen/RoomModal.dart';


class HomeModal {
  List<RoomModal> roomsAvailable;
  int nightsSelected;
  String pageId;
  String navBarBgColor;
  String navBarFgColor;
  String pageTitle;
  bool hasBackButton;
  bool hasLeftMenu;
  String leftMenuIcon;
  String leftMenuCTA;
  bool hasRightMenu;
  String rightMenuIcon;
  String rightMenuCTA;
  String pageBgColor;

  HomeModal(
    this.roomsAvailable,
    this.nightsSelected,
    this.pageId,
    this.navBarBgColor,
    this.navBarFgColor,
    this.pageTitle,
    this.hasBackButton,
    this.hasLeftMenu,
    this.leftMenuIcon,
    this.leftMenuCTA,
    this.hasRightMenu,
    this.pageBgColor,
    this.rightMenuCTA,
    this.rightMenuIcon,
  );

  factory HomeModal.fromJson(Map<String, dynamic> json) {
    final List<RoomModal> roomsAvailable = (json['roomsAvailable'] as List<dynamic>? ?? [])
          .map((room) => RoomModal.fromJson(room))
          .toList();
    return HomeModal(
      roomsAvailable,
      json['nightsSelected'],
      json['pageId'],
      json['navBarBgColor'],
      json['navBarFgColor'],
      json['pageTitle'],
      json['hasBackButton'],
      json['hasLeftMenu'],
      json['leftMenuIcon'],
      json['leftMenuCTA'],
      json['hasRightMenu'],
      json['pageBgColor'],
      json['rightMenuCTA'],
      json['rightMenuIcon'],
    );}
  }

