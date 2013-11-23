import 'dart:html';
import 'package:polymer/polymer.dart';
import '../tripstore.dart';
import '../mpismobile.dart';


@CustomTag('mpis-trip')
class TripComponent extends PolymerElement {
  @observable Trip trip;
    
  TripComponent.created() : super.created();

  void removeTrip(Event e, var detail, Node target) {
    appObject.removeTrip(trip);
  }
}