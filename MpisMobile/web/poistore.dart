library poistore;

import 'package:polymer/polymer.dart';
import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';

/*
 * The MODEL for the app.
 * 
 * Contains two classes:
 * PointOfInterest to hold info for an individual PointOfInterest.
 * PointOfInterestStore to manage a list of points of interest in memory
 * and in the IndexedDB.
 */

/****
 * A class to hold the info for an individual PointOfInterest.
 */
class PointOfInterest extends Observable {
 
  @observable String title = '';
  final double latitude;  
  final double longitude;
  @observable String description = '';
  
  var dbKey;
    
  PointOfInterest(this.title, this.latitude, this.longitude, this.description );
  
  String toString() => '$title $latitude $longitude';
  
  // Constructor which creates a PointOfInterest
  // from the value (a Map) stored in the database.
  PointOfInterest.fromRaw(key, Map value):
    dbKey = key,
    title = value['title'],
    latitude = value['latitude'],
    longitude = value['longitude'],
    description = value['description']{
    tick();
  }
  
  // Serialize this to an object (a Map) to insert into the database.
  Map toRaw() {
    return {
      'title': title,
      'latitude': latitude,
      'longitude': longitude,
      'description': description

    };
  }
    
  // Called from the VIEW-MODEL to update the time remaining.
  void tick() {
    //do nothing
  }
}
 
/****
 * A class to manage a list of PointOfInterest in memory
 * and in an IndexedDB.
 */
class PointOfInterestStore {
  static const String POI_STORE = 'poiStore';
  static const String NAME_INDEX = 'name_index';
  
  final List<PointOfInterest> pois = toObservable(new List());
  
  Database _db;
  
  Future open() {
    return window.indexedDB.open('poisDB',
        version: 1,
        onUpgradeNeeded: _initializeDatabase)
      .then(_loadFromDB);
  }
  
  // Initializes the object store if it is brand new,
  // or upgrades it if the version is older. 
  void _initializeDatabase(VersionChangeEvent e) {
    Database db = (e.target as Request).result;
    
    var objectStore = db.createObjectStore(POI_STORE,
        autoIncrement: true);
    
    // Create an index to search by name,
    // unique is true: the index doesn't allow duplicate PointOfInterest names.
    objectStore.createIndex(NAME_INDEX, 'PointOfInterestName', unique: true);
  }
  
  // Loads all of the existing objects from the database.
  // The future completes when loading is finished.
  Future _loadFromDB(Database db) {
    _db = db;
    
    var trans = db.transaction(POI_STORE, 'readonly');
    var store = trans.objectStore(POI_STORE);
    
    // Get everything in the store.
    var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      // Add PointOfInterest to the internal list.
      var poi = new PointOfInterest.fromRaw(cursor.key, cursor.value);
      pois.add(poi);

    });
    return cursors.length.then((_) {
      return pois.length;
    });
  }
  
  // Add a new PointOfInterest to the PointOfInterests in the Database.
  // 
  // This returns a Future with the new PointOfInterest when the PointOfInterest
  // has been added.
  Future<PointOfInterest> add(String title, String description, double longitude, double latitude) {
    var poi = new PointOfInterest(title,longitude, latitude,description);
    var pointOfInterestAsMap = poi.toRaw();

    var transaction = _db.transaction(POI_STORE, 'readwrite');
    var objectStore = transaction.objectStore(POI_STORE);
    
    
    objectStore.add(pointOfInterestAsMap).then((addedKey) {
      // NOTE! The key cannot be used until the transaction completes.
      poi.dbKey = addedKey;
    });
    
    // Note that the PointOfInterest cannot be queried until the transaction
    // has completed!
    return transaction.completed.then((_) {
      // Once the transaction completes, add it to our list of available items.
      pois.add(poi);
      
      // Return the PointOfInterest so this becomes the result of the future.
      return poi;
    });
  }
  
  // Removes a PointOfInterest from the list of PointOfInterests.
  // 
  // This returns a Future which completes when the PointOfInterest has been removed.
  Future remove(PointOfInterest poi) {
    // Remove from database.
    var transaction = _db.transaction(POI_STORE, 'readwrite');
    transaction.objectStore(POI_STORE).delete(poi.dbKey);
    
    return transaction.completed.then((_) {
      // Null out the key to indicate that the PointOfInterest is dead.
      poi.dbKey = null;
      // Remove from internal list.
      pois.remove(poi);
    });
  }
  
  // Removes ALL PointOfInterests.
  Future clear() {
    // Clear database.
    var transaction = _db.transaction(POI_STORE, 'readwrite');
    transaction.objectStore(POI_STORE).clear();
    
    return transaction.completed.then((_) {
      // Clear internal list.
      pois.clear();
    });
  }
}