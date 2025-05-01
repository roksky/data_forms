import 'package:flutter/material.dart';
import 'package:data_forms/core/field_callback.dart';
import 'package:data_forms/core/form_style.dart';
import 'package:data_forms/model/fields_model/location_tree_model.dart';
import 'package:provider/provider.dart';

import 'package:data_forms/model/data_model/location_item_model.dart';
import 'package:data_forms/model/state_manager.dart';
import 'package:data_forms/util/value_util.dart';
import 'notifyable_stateful_widget.dart';

// ignore: must_be_immutable
class FormLocationTreeField extends NotifiableStatefulWidget
    implements FormFieldCallBack {
  final FormLocationTreeModel model;
  final FormStyle formStyle;
  LocationItem? result = null;

  FormLocationTreeField(this.model, this.formStyle, {Key? key})
      : super(key: key);

  @override
  State<FormLocationTreeField> createState() => _GSLocationTreeFieldState();

  @override
  getValue() {
    return result;
  }

  @override
  bool isValid() {
    if (!(model.required ?? false)) {
      return true;
    } else {
      return result != null;
    }
  }
}

class _GSLocationTreeFieldState extends State<FormLocationTreeField> {
  @override
  Widget build(BuildContext context) {
    final stateManager = Provider.of<StateManager>(context);
    return Center(
      child: GestureDetector(
        onTap: () {
          showLocationPicker(stateManager);
        },
        child: Container(
          margin: EdgeInsets.all(16.0),
          padding: EdgeInsets.all(16.0),
          child: Text(
            widget.result?.name ?? widget.model.title ?? 'Select Location',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void showLocationPicker(StateManager stateManager) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Covers most of the screen height
          child: LocationPickerDialog(
            rootLocation: getValue(stateManager.get(widget.model.dependsOn)),
            hierarchy: widget.model.targetLevel != null &&
                    widget.model.hierarchy.contains(widget.model.targetLevel)
                ? widget.model.hierarchy.sublist(
                    0,
                    widget.model.hierarchy.indexOf(widget.model.targetLevel!) +
                        1)
                : widget.model.hierarchy,
            fetchLocations: widget.model.fetchLocations,
            fetchLocationById: widget.model.fetchLocationById,
            onSave: (selectedLocations) {
              // Handle the selected locations and update the UI accordingly.
              setState(() {
                widget.result = selectedLocations
                    .last; // Update the box with the final selected location
                stateManager.set(
                    widget.model.tag, widget.result); // Update the model
              });
            },
          ),
        );
      },
    );
  }
}

class LocationPickerDialog extends StatefulWidget {
  final LocationItem? rootLocation;
  final List<String> hierarchy;
  final Future<List<LocationItem>> Function(String? parentId) fetchLocations;
  final Future<LocationItem?> Function(String locationId) fetchLocationById;
  final Function(List<LocationItem>) onSave;

  LocationPickerDialog({
    this.rootLocation,
    required this.hierarchy,
    required this.fetchLocations,
    required this.fetchLocationById,
    required this.onSave,
  });

  @override
  _LocationPickerDialogState createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  List<List<LocationItem>> locations = [];
  List<LocationItem?> selectedLocations = [];
  List<String> hierarchy = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    hierarchy = widget.hierarchy;
    asyncInit();
  }

  Future<void> asyncInit() async {
    await recomputeHierarchy(widget.rootLocation?.id);
    await loadLocationsForLevel(
        widget.rootLocation?.id, 0); // Load root locations initially
  }

  Future<void> recomputeHierarchy(String? rootLocation) async {
    setState(() {
      isLoading = true; // Show loading indicator when fetching locations
    });

    if (rootLocation != null) {
      LocationItem? item = await widget.fetchLocationById(rootLocation);
      if (item != null) {
        var mylevel = item.level;
        // subset the hierarchy
        var index = hierarchy.indexOf(mylevel!);
        if (index != -1) {
          hierarchy = hierarchy.sublist(index);
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadLocationsForLevel(String? parentId, int level) async {
    // Clear locations down the hierarchy
    while (locations.length > level) {
      locations.removeLast();
      selectedLocations.removeLast();
    }

    setState(() {
      isLoading = true; // Show loading indicator when fetching locations
    });

    final newLocations = await widget.fetchLocations(parentId);

    setState(() {
      locations.add(newLocations);
      selectedLocations.add(null); // Add null for the newly loaded level
      isLoading = false; // Stop loading indicator after fetching
    });
  }

  void onLocationChanged(LocationItem? location, int level) {
    setState(() {
      selectedLocations[level] = location;
      // Load next level of locations if selected
      if (location != null) {
        loadLocationsForLevel(location.id, level + 1);
      } else {
        // Clear the levels below if current selection is null
        while (selectedLocations.length > level + 1) {
          selectedLocations.removeLast();
          locations.removeLast();
        }
      }
    });
  }

  Future<void> onLocationChanged2(String? parentId, int level) async {
    // Clear locations down the hierarchy
    while (locations.length > level) {
      locations.removeLast();
      selectedLocations.removeLast();
    }

    setState(() {
      isLoading = true; // Show loading indicator when fetching locations
    });

    final newLocations = await widget.fetchLocations(parentId);

    setState(() {
      locations.add(newLocations);
      selectedLocations.add(null); // Add null for the newly loaded level
      isLoading = false; // Stop loading indicator after fetching
    });
  }

  bool isLastItemSelected() {
    return selectedLocations.length >= hierarchy.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(hierarchy.length, (index) {
                  if (index >= locations.length) {
                    return Container(); // Return empty container if no locations are loaded yet
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: DropdownButton<LocationItem>(
                      value: selectedLocations[index],
                      hint: Text('Select ${hierarchy[index]}'),
                      isExpanded: true,
                      items: locations[index]
                          .map((location) => DropdownMenuItem<LocationItem>(
                                value: location,
                                child: Text(location.name),
                              ))
                          .toList(),
                      onChanged: (LocationItem? newValue) {
                        onLocationChanged(newValue, index);
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLastItemSelected()
                      ? () {
                          widget.onSave(selectedLocations
                              .whereType<LocationItem>()
                              .toList());
                          Navigator.of(context).pop();
                        }
                      : null, // Disable button if the last item is not selected
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
