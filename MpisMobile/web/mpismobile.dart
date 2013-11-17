import 'dart:async';
import 'dart:indexed_db';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:js/js.dart' as js;
import 'package:google_maps/google_maps.dart';
import '../lib/poistore.dart';
import 'components/mpismaps.dart' as map;


/*
 * The VIEW-MODEL for the app.
 * 
 * Implements the business logic 
 * and manages the information exchanges
 * between the MODEL (PointOfInterest & PointOfInterestStore)
 * and the VIEW (CountDownComponent & MilestoneComponent).
 * 
 * Manages a PointsOfInterest to update the points of interest.
 */

MpisApp appObject = new MpisApp();

class MpisApp extends Observable {
  /****
   * Some things we need...
   */  
  // Is IndexedDB supported in this browser?
  bool idbAvailable = IdbFactory.supported;
  
  // A place to save the points of interest (is the MODEL).
  PointOfInterestStore _store = new PointOfInterestStore();
  
  // Called from the VIEW.
  @observable bool hazPointsOfInterest;
    
  // The list of points of interest in the MODEL.
  List<PointOfInterest> get pois => _store.pois;
  
  map.GMapElement mapElem;
  
  /****
   * Life-cycle methods...
   */
  
  // Called from the VIEW when the element is inserted into the DOM.
  Future start() {
    if (!idbAvailable) {
      return new Future.error('IndexedDB not supported.');
    }
    
    return _store.open().then((_) {
      hazPointsOfInterest = notifyPropertyChange(const Symbol('hazPointsOfInterest'),
          hazPointsOfInterest, (pois.length == 0) ? false : true);

    });
  }
  
  // Called from the VIEW when the element is removed from the DOM.
  void stop() {
    //do nothing
  }

  /****
   * Click handlers...
   * Called from the VIEW (mpispoimgr) when the user clicks a button.
   * Delegates to MODEL.
   */  
  void addPointOfInterest(String title, double latitude, double longitude, String description) {
    // Make sure PointOfInterest is in the future, and not in the past.
    _store.add(title, description, longitude, latitude).then((_) {
      hazPointsOfInterest = notifyPropertyChange(const Symbol('hazPointsOfInterest'),
          hazPointsOfInterest, (pois.length == 0) ? false : true);
    },
    onError: (e) { print('duplicate key'); } );    
  }

  Future removePointOfInterest(PointOfInterest poi) {
    return _store.remove(poi).then((_) {
      hazPointsOfInterest = notifyPropertyChange(const Symbol('hazPointsOfInterest'),
          hazPointsOfInterest, (pois.length == 0) ? false : true);
   });
  }
  
  Future clear() {
    mapElem.deleteMarkers();
    
    return _store.clear().then((_) {
      hazPointsOfInterest = notifyPropertyChange(const Symbol('hazPointsOfInterest'),
          hazPointsOfInterest, (pois.length == 0) ? false : true);
    });    
  }
  
  void loadDummyData() {
    if(!appObject.hazPointsOfInterest) {
      appObject.addPointOfInterest('Starbucks', 47.376997, 8.543881, 'Kaffi trinken');
      mapElem.addMarker('Starbucks', 47.376997, 8.543881);      
      appObject.addPointOfInterest('Tannenbar', 47.377423, 8.548070, 'Burger essen');
      mapElem.addMarker('Tannenbar', 47.377423, 8.548070);
      appObject.addPointOfInterest('Doener', 47.375221, 8.543881, 'Geile Kebab');
      mapElem.addMarker('Doener', 47.375221, 8.543881 );
      appObject.addPointOfInterest('Thai', 47.374046, 8.521966, 'Sgeilschte aber chli tuuers Thai uf dere Erde');
      mapElem.addMarker('Thai', 47.374046, 8.521966);
    }
  }
   
}

main() {
  js.context.google.maps.visualRefresh = true;
  
  initPolymer();
  //set starting map position
  final startLocation = new LatLng(47.37416, 8.52254);
  
  map.GMapElement mapElement = querySelector('#myMap');
  mapElement.map
    ..panTo(startLocation)
      ..zoom = 17;
  
  appObject.mapElem = mapElement;
}