library tripstore;

import 'package:polymer/polymer.dart';
import 'dart:async';
import 'dart:html';
import 'dart:indexed_db';
import 'poistore.dart';

/*
 * The MODEL for the app.
 * 
 * Contains two classes:
 * Trip to hold info for an individual Trip.
 * TripStore to manage a list of points of interest in memory
 * and in the IndexedDB.
 */

/****
 * A class to hold the info for an individual Trip.
 */
class Trip extends Observable {
 
  @observable String title = '';
  @observable List<PointOfInterest> pois = new List<PointOfInterest>();
  
  var dbKey;
    
  Trip(this.title);
  
  String toString() => '$title $pois.length';
  
  // Constructor which creates a Trip
  // from the value (a Map) stored in the database.
  Trip.fromRaw(key, Map value):
    dbKey = key,
    title = value['title'],
    pois = value['pois']{
    tick();
  }
  
  // Serialize this to an object (a Map) to insert into the database.
  Map toRaw() {
    return {
      'title': title,
      'pois': pois,
    };
  }
    
  // Called from the VIEW-MODEL to update the time remaining.
  void tick() {
    //do nothing
  }
}
 
/****
 * A class to manage a list of Trip in memory
 * and in an IndexedDB.
 */
class TripStore {
  static const String TRIP_STORE = 'tripStore';
  static const String NAME_INDEX = 'name_index';
  
  final List<Trip> trips = toObservable(new List());
  
  Database _db;
  
  Future open() {
    return window.indexedDB.open('tripsDB',
        version: 1,
        onUpgradeNeeded: _initializeDatabase)
      .then(_loadFromDB);
  }
  
  // Initializes the object store if it is brand new,
  // or upgrades it if the version is older. 
  void _initializeDatabase(VersionChangeEvent e) {
    Database db = (e.target as Request).result;
    
    var objectStore = db.createObjectStore(TRIP_STORE,
        autoIncrement: true);
    
    // Create an index to search by name,
    // unique is true: the index doesn't allow duplicate Trip names.
    objectStore.createIndex(NAME_INDEX, 'TripName', unique: true);
  }
  
  // Loads all of the existing objects from the database.
  // The future completes when loading is finished.
  Future _loadFromDB(Database db) {
    _db = db;
    
    var trans = db.transaction(TRIP_STORE, 'readonly');
    var store = trans.objectStore(TRIP_STORE);
    
    // Get everything in the store.
    var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      // Add Trip to the internal list.
      var trip = new Trip.fromRaw(cursor.key, cursor.value);
      trips.add(trip);

    });
    return cursors.length.then((_) {
      return trips.length;
    });
  }
  
  // Add a new Trip to the Trips in the Database.
  // 
  // This returns a Future with the new Trip when the Trip
  // has been added.
  Future<Trip> add(String title) {
    var trip = new Trip(title);
    var TripAsMap = trip.toRaw();

    var transaction = _db.transaction(TRIP_STORE, 'readwrite');
    var objectStore = transaction.objectStore(TRIP_STORE);
    
    
    objectStore.add(TripAsMap).then((addedKey) {
      // NOTE! The key cannot be used until the transaction completes.
      trip.dbKey = addedKey;
    });
    
    // Note that the Trip cannot be queried until the transaction
    // has completed!
    return transaction.completed.then((_) {
      // Once the transaction completes, add it to our list of available items.
      trips.add(trip);
      
      // Return the Trip so this becomes the result of the future.
      return trip;
    });
  }
  
  // Removes a Trip from the list of Trips.
  // 
  // This returns a Future which completes when the Trip has been removed.
  Future remove(Trip trip) {
    // Remove from database.
    var transaction = _db.transaction(TRIP_STORE, 'readwrite');
    transaction.objectStore(TRIP_STORE).delete(trip.dbKey);
    
    return transaction.completed.then((_) {
      // Null out the key to indicate that the Trip is dead.
      trip.dbKey = null;
      // Remove from internal list.
      trips.remove(trip);
    });
  }
  
  // Removes ALL Trips.
  Future clear() {
    // Clear database.
    var transaction = _db.transaction(TRIP_STORE, 'readwrite');
    transaction.objectStore(TRIP_STORE).clear();
    
    return transaction.completed.then((_) {
      // Clear internal list.
      trips.clear();
    });
  }
}