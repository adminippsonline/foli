import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/session.dart';

class MapaPoints extends StatefulWidget {
  double lat;
  double lng;
  MapaPoints(this.lat, this.lng,{super.key});

  @override
  State<MapaPoints> createState() => _MapaPointsState();
}

class _MapaPointsState extends State<MapaPoints> {
  Map<MarkerId, Marker> markers = {};
  late GoogleMapController mapController;

  Map<PolylineId, Polyline> polylines = {};

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyD0bDkp8A6MfZrbbn0Tbk2uNNgXCIujB3g";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addMarker(LatLng(Provider.of<Session>(context,listen: false).lat, Provider.of<Session>(context,listen: false).lng), "inicio",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(widget.lat,widget.lng), "destino",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(Provider.of<Session>(context,listen: false).lat, Provider.of<Session>(context,listen: false).lng),zoom: 17),
      onMapCreated: _onMapCreated,
      markers: Set<Marker>.of(markers.values),
      polylines: Set<Polyline>.of(polylines.values),
      myLocationEnabled: true,
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(Provider.of<Session>(context,listen: false).lat, Provider.of<Session>(context,listen: false).lng),
        PointLatLng(widget.lat, widget.lng),
        travelMode: TravelMode.driving,);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(
                  Provider.of<Session>(context,listen: false).lat <= widget.lat
                      ? Provider.of<Session>(context,listen: false).lat
                      : widget.lat,
                  Provider.of<Session>(context,listen: false).lng <= widget.lng
                      ? Provider.of<Session>(context,listen: false).lng
                      : widget.lng),
              northeast: LatLng(
                  Provider.of<Session>(context,listen: false).lat <= widget.lat
                      ? widget.lat
                      : Provider.of<Session>(context,listen: false).lat,
                  Provider.of<Session>(context,listen: false).lng <= widget.lng
                      ? widget.lng
                      : Provider.of<Session>(context,listen: false).lng)),50),
    );
  }
}
