import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/location_model.dart';
import 'package:data_forms/model/response/position_response.dart';
import 'package:data_forms/values/colors.dart';

import 'package:data_forms/model/state_manager.dart';
import 'package:provider/provider.dart';
import 'notifyable_stateful_widget.dart';

class FormLocationField extends NotifiableStatefulWidget
    implements FormFieldCallBack {
  late FormLocationModel model;
  final FormStyle formStyle;

  FormLocationField(this.model, this.formStyle, {Key? key}) : super(key: key);
  Position? _currentLocation;

  @override
  State<FormLocationField> createState() => _GSLocationFieldState();

  @override
  getValue() {
    return _currentLocation == null
        ? null
        : PositionResponse.fromPosition(_currentLocation!).toString();
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return _currentLocation != null;
    }
  }
}

class _GSLocationFieldState extends State<FormLocationField> {
  String _currentLocation = 'Location not fetched';
  bool isLoading = false;

  Future<void> _getCurrentLocation(StateManager stateManager) async {
    setState(() {
      isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      setState(() {
        _currentLocation = 'Location services are disabled.';
        isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        setState(() {
          _currentLocation = 'Location permissions are denied';
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        _currentLocation =
            'Location permissions are permanently denied, we cannot request permissions.';
        isLoading = false;
      });
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation =
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      widget._currentLocation = position;
      stateManager.set(
          widget.model.tag, widget._currentLocation); // Update the model
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = Provider.of<StateManager>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.transparent,
        child: isLoading
            ? Container(
                color:
                    Colors.black54, // Optional: To give a dim background effect
                child: Center(
                  child: CircularProgressIndicator(),
                  // You can use the flutter_spinkit package for more options:
                  // child: SpinKitCircle(color: Colors.white),
                ),
              )
            : InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onTap: () {
                  _getCurrentLocation(stateManager);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.model.iconWidget ?? Container(),
                      const SizedBox(height: 6.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.model.required ?? false,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4, left: 4),
                              child: Text(
                                widget.formStyle.requiredText,
                                style: const TextStyle(
                                  color: FormColors.red,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.model.title ?? '',
                            style: widget.formStyle.titleTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _currentLocation,
                        style: widget.formStyle.fieldTextStyle,
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
