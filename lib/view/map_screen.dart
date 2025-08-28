import 'dart:async';
import 'package:cage/utils/routes/routes.dart';
import 'package:cage/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:cage/provider/location_provider.dart';

class SelectLocationView extends StatefulWidget {
  @override
  _SelectLocationViewState createState() => _SelectLocationViewState();
}

class _SelectLocationViewState extends State<SelectLocationView> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  String _mapStyle = '';

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Example: San Francisco
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });

    // Initialize location provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      locationProvider.initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition:
                      locationProvider.currentLocation != null
                      ? CameraPosition(
                          target: locationProvider.currentLocation!,
                          zoom: 15,
                        )
                      : _initialPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(_mapStyle);
                    _controller.complete(controller);
                  },
                  onTap: (LatLng position) async {
                    await locationProvider.selectLocationByTap(position);
                  },
                  markers: locationProvider.markers,
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Select Your Location",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search for a location...",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () {
                                if (_searchController.text.isNotEmpty) {
                                  locationProvider.searchPlaces(
                                    _searchController.text,
                                  );
                                }
                              },
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              locationProvider.searchPlaces(value);
                            } else {
                              locationProvider.clearSearch();
                            }
                          },
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              locationProvider.searchPlaces(value);
                            }
                          },
                        ),
                      ),
                      // Search suggestions dropdown
                      if (locationProvider.predictions.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: locationProvider.predictions.length,
                            itemBuilder: (context, index) {
                              final prediction =
                                  locationProvider.predictions[index];
                              return ListTile(
                                title: Text(
                                  prediction.description,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                onTap: () {
                                  locationProvider.selectPlace(prediction);
                                  _searchController.text =
                                      prediction.description;
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 16,
                  right: 16,
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: locationProvider.isSavingLocation
                          ? null
                          : () async {
                              final success = await locationProvider
                                  .saveSelectedLocation();

                              if (success) {
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Location saved successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                // Return the selected location
                                final selectedLocation = locationProvider
                                    .getSelectedLocation();

                                Navigator.pushNamed(context, RoutesName.home); 
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error saving location'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: locationProvider.isSavingLocation
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Saving...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Confirm Location",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
