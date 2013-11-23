import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import '../mpismobile.dart';

@CustomTag('mpis-tripmgr')
class TripManagerComponent extends PolymerElement {
  
  // Observe errorMsg.
  // It displays a message for the user.
  @observable String errorMsg = '';

  // These are bound to input elements.
  @observable String newTripTitle = "New Trip Name";
  
  @observable MpisApp appObj = appObject;
   
  TripManagerComponent.created() : super.created();
  
  /*
   * Click handlers.
   * NOTE: Minus - button handler is in xmilestone web component.
   */
  // Plus + button click handler.
  void addTrip(Event e, var detail, Node target) {
    appObject.addTrip(newTripTitle, null);
  }
  
  // Clear button click handler.
  void clear(Event e, var detail, Node target) {
    errorMsg = '';
    appObject.clear();
  }
  
  /*
   * Life-cycle bizness
   */
  void enteredView() {
    super.enteredView();
    appObject.startTripStore()
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