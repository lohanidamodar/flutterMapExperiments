import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController _controller;
  Set<Marker> _markers;
  CameraPosition _current;
  MapType _mapType;

  @override
  void initState() { 
    super.initState();
    _markers=Set.from([
      Marker(
        markerId: MarkerId("test1"),
        infoWindow: InfoWindow(
          title: "Test marker 1",
          snippet: "Snippet fo test marker 1"
        ),
        position: LatLng(27.6990092,85.3417237),
        icon: BitmapDescriptor.defaultMarkerWithHue(2.0))
    ]);
    _mapType = MapType.normal;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(27.6990092,85.3417237),
                  zoom: 16.0,
                ),
                mapType: _mapType,
                onMapCreated: (GoogleMapController controller){
                  _controller = controller;
                },
                markers: _markers,
                onCameraMove: (CameraPosition pos){
                  _current = pos;
                },
              ),
            ),
            RaisedButton(
              child: Text("Marker to Current Position"),
              onPressed: (){
                setState(() {
                  _markers.add(Marker(
                    markerId: MarkerId("test${_markers.length +1}"),
                    position: _current.target,
                    draggable: true,
                    infoWindow: InfoWindow(
                      title: "Text marker ${_markers.length +1}",
                      snippet: "Test marker ${_markers.length +1} description"
                    ),

                  ));
                });
              },
            ),
            RaisedButton(
              child: Text("Change map type"),
              onPressed: (){
                List maptypes = [MapType.normal, MapType.hybrid, MapType.satellite, MapType.terrain];
                maptypes.shuffle();
                setState(() {
                  _mapType = maptypes[0];
                });
              },
            ),
            RaisedButton(
              child: Text("Back to begining"),
              onPressed: (){
                _controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(27.6990092,85.3417237),16.0));
              },
            ),
            RaisedButton(
              child: Text("Zoom In"),
              onPressed: (){
                _controller.animateCamera(CameraUpdate.zoomIn());
              },
            ),
            RaisedButton(
              child: Text("Zoom Out"),
              onPressed: (){
                _controller.animateCamera(CameraUpdate.zoomOut());
              },
            ),
            RaisedButton(
              child: Text("Add a marker"),
              onPressed: (){
                Random rnd = Random();
                LatLng position = LatLng(rnd.nextDouble() + 27.6, rnd.nextDouble()+84.5);
                setState(() {
                  _markers.add(Marker(
                    markerId: MarkerId("test${_markers.length +1}"),
                    position: position,
                    infoWindow: InfoWindow(
                      title: "Text marker ${_markers.length +1}",
                      snippet: "Test marker ${_markers.length +1} description"
                    )
                  ));
                });
                _controller.animateCamera(CameraUpdate.newLatLng(position));
              },
            )
          ],
        ),
      ),
    );
  }
}