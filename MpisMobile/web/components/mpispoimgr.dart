import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import '../mpismobile.dart';

@CustomTag('mpis-poimgr')
class CountDownComponent extends PolymerElement {
  
  // Observe errorMsg.
  // It displays a message for the user.
  @observable String errorMsg = '';

  // These are bound to input elements.
  @observable String newPointOfInterestTitle = "Name of point of interest";
  @observable String newPointOfInterestLongitude = '0';
  @observable String newPointOfInterestLatitude = '1';
  @observable String newPointOfInterestDescr = 'Description of point of interest';
  
  @observable MpisApp appObj = appObject;
   
  CountDownComponent.created() : super.created();
  
  /*
   * Click handlers.
   * NOTE: Minus - button handler is in xmilestone web component.
   */
  // Plus + button click handler.
  void addPointOfInterest(Event e, var detail, Node target) {
    double la = double.parse(newPointOfInterestLatitude);
    double lo = double.parse(newPointOfInterestLongitude);    

    appObject.addPointOfInterest(newPointOfInterestTitle, la, lo, newPointOfInterestDescr);
  }

  // Clear button click handler.
  void clear(Event e, var detail, Node target) {
    errorMsg = '';
    appObject.clear();
  }
  
  // Clear button click handler.
  void loadDummy(Event e, var detail, Node target) {
    appObject.loadDummyData();
  }
   
  /*
   * Life-cycle bizness
   */
  void enteredView() {
    super.enteredView();
    appObject.start()
      .catchError((e) {
        ($['addbutton'] as ButtonElement).disabled = true;
        ($['clearbutton'] as ButtonElement).disabled = true;

        errorMsg = e.toString();
      });
  }
  
  void leftView() {
    super.leftView();
    appObject.stop();
  }
} // end class