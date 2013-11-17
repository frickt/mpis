library mpis.models;

import 'package:polymer/polymer.dart';
import 'dart:html';

final appModel = new TripApp();

/**
 * A model for the tracker app.
 *
 * [pointsOfInterests] contains all tasks used in this app.
 */
class TripApp extends Observable {
  @observable List<PointOfInterest> pointsOfInterests;
  
  Tripp() {
    pointsOfInterests.add(  
        new PointOfInterest('Starbucks', 'Starbucks am Central. Tüüüre Kafi', null)  
        );
  }
}

/**
 * A model for creating a PointOfInterest.
 */
class PointOfInterest extends Observable {
  
  @observable String title = '';
  @observable String description = '';
  @observable Geoposition position;

  PointOfInterest(this.title, this.description, this.position);
}