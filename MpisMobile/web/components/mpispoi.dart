import 'dart:html';
import 'package:polymer/polymer.dart';
import '../../lib/poistore.dart';
import '../mpismobile.dart';


@CustomTag('mpis-poi')
class PointOfInterestComponent extends PolymerElement {
  @observable PointOfInterest poi;
    
  PointOfInterestComponent.created() : super.created();

  void removePointOfInterest(Event e, var detail, Node target) {
    appObject.removePointOfInterest(poi);
  }
}