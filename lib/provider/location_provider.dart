import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import '../utils/location_helper.dart';
import '../utils/routes/utils.dart';

class LocationProvider extends ChangeNotifier {
  // State variables
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  List<LocationPrediction> _predictions = [];
  bool _isSearching = false;
  bool _isSavingLocation = false;
  bool _isLoadingCurrentLocation = false;
  String _searchQuery = '';
  LocationData? _savedLocation;

  // Getters
  LatLng? get currentLocation => _currentLocation;
  Set<Marker> get markers => _markers;
  List<LocationPrediction> get predictions => _predictions;
  bool get isSearching => _isSearching;
  bool get isSavingLocation => _isSavingLocation;
  bool get isLoadingCurrentLocation => _isLoadingCurrentLocation;
  String get searchQuery => _searchQuery;
  LocationData? get savedLocation => _savedLocation;

  // Initialize the provider
  Future<void> initialize() async {
    await getCurrentLocation();
    await loadSavedLocation();
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    _isLoadingCurrentLocation = true;
    notifyListeners();

    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        _currentLocation = location;
        _addCurrentLocationMarker();
      }
    } catch (e) {
      print('Error getting current location: $e');
    } finally {
      _isLoadingCurrentLocation = false;
      notifyListeners();
    }
  }

  // Add current location marker
  void _addCurrentLocationMarker() {
    if (_currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current-location'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    }
  }

  // Search places
  Future<void> searchPlaces(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _predictions = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final predictions = await LocationService.searchPlaces(query);
      _predictions = predictions;
    } catch (e) {
      print('Error searching places: $e');
      _predictions = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Select a place from search results
  Future<void> selectPlace(LocationPrediction prediction) async {
    try {
      final locationData = await LocationService.getPlaceDetails(
        prediction.placeId,
      );
      if (locationData != null) {
        _addSelectedLocationMarker(locationData);
        _predictions = [];
        _searchQuery = prediction.description;
        notifyListeners();
      }
    } catch (e) {
      print('Error selecting place: $e');
    }
  }

  // Add selected location marker
  void _addSelectedLocationMarker(LocationData locationData) {
    final selectedLocation = LatLng(
      locationData.latitude,
      locationData.longitude,
    );

    // Remove existing selected location marker
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'selected-location',
    );

    // Add new selected location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('selected-location'),
        position: selectedLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: locationData.address,
          snippet: LocationHelper.formatCoordinates(
            locationData.latitude,
            locationData.longitude,
          ),
        ),
      ),
    );
  }

  // Select location by tapping on map
  void selectLocationByTap(LatLng position) {
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'selected-location',
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'Selected Location',
          snippet: LocationHelper.formatCoordinates(
            position.latitude,
            position.longitude,
          ),
        ),
      ),
    );

    notifyListeners();
  }

  // Save selected location to Firestore
  Future<bool> saveSelectedLocation() async {
    _isSavingLocation = true;
    notifyListeners();

    try {
      // Get the selected location marker
      final selectedMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == 'selected-location',
        orElse: () => _markers.firstWhere(
          (marker) => marker.markerId.value == 'current-location',
          orElse: () => Marker(
            markerId: const MarkerId('default'),
            position: const LatLng(37.7749, -122.4194),
          ),
        ),
      );

      final uid = Utils.getCurrentUid();

      // Create location data object
      final locationData = LocationService.createLocationData(
        latitude: selectedMarker.position.latitude,
        longitude: selectedMarker.position.longitude,
        address: selectedMarker.infoWindow.title,
      );

      // Save to Firestore
      final success = await LocationHelper.saveLocation(uid, locationData);

      if (success) {
        _savedLocation = locationData;
        print(
          'Location saved successfully: ${locationData.latitude}, ${locationData.longitude}',
        );
      }

      return success;
    } catch (e) {
      print('Error saving location: $e');
      return false;
    } finally {
      _isSavingLocation = false;
      notifyListeners();
    }
  }

  // Load saved location from Firestore
  Future<void> loadSavedLocation() async {
    try {
      final uid = Utils.getCurrentUid();
      _savedLocation = await LocationHelper.getSavedLocation(uid);
      notifyListeners();
    } catch (e) {
      print('Error loading saved location: $e');
    }
  }

  // Clear search results
  void clearSearch() {
    _predictions = [];
    _searchQuery = '';
    notifyListeners();
  }

  // Get selected location coordinates
  LatLng? getSelectedLocation() {
    final selectedMarker = _markers.firstWhere(
      (marker) => marker.markerId.value == 'selected-location',
      orElse: () => _markers.firstWhere(
        (marker) => marker.markerId.value == 'current-location',
        orElse: () => Marker(
          markerId: const MarkerId('default'),
          position: const LatLng(37.7749, -122.4194),
        ),
      ),
    );

    return selectedMarker.position;
  }

  // Check if a location is selected
  bool get hasSelectedLocation {
    return _markers.any(
      (marker) => marker.markerId.value == 'selected-location',
    );
  }

  // Reset all state
  void reset() {
    _currentLocation = null;
    _markers.clear();
    _predictions.clear();
    _isSearching = false;
    _isSavingLocation = false;
    _isLoadingCurrentLocation = false;
    _searchQuery = '';
    notifyListeners();
  }
}
