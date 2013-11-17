import 'package:polymer/polymer.dart';
import 'package:google_maps/google_maps.dart';


/**
 * A Polymer google map element.
 */
@CustomTag('mpis-maps')
class GMapElement extends PolymerElement {
  GMap map;
  List<Marker> markers = new List<Marker>();

  GMapElement.created() : super.created() {
    final mapOptions = new MapOptions()
      ..mapTypeId = MapTypeId.ROADMAP;
    //div for gmap component
    final mapView = getShadowRoot('mpis-maps').querySelector("#mapView");
    map = new GMap(mapView, mapOptions);
  }
  
  void addMarker(String title, double lat, double lng) {
    final LatLng loc = new LatLng(lat, lng);
    
    Marker m = new Marker(new MarkerOptions()
      ..position = loc
      ..map = map
      ..title = title);
    
    markers.add(m);
    
  }
  
  // Sets the map on all markers in the array.
  void setAllMap(GMap map) {
    for (final marker in markers) {
      marker.map = map;
    }
  }
  
  void clearMarkers() {
    setAllMap(null);
  }
  
  void deleteMarkers() {
    clearMarkers();
    markers.clear();
  }

  enteredView() {
    super.enteredView();
    // this allow to notify the map that the size of the canvas has changed.
    // in some cases, the map behaves like it has a 0*0 size.
    event.trigger(map, 'resize', []);
  }
}

