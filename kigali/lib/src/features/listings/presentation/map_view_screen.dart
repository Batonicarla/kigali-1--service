import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../data/listing_repository.dart';

class MapViewScreen extends ConsumerWidget {
  const MapViewScreen({super.key});

  static final _kigaliCenter = LatLng(-1.94995, 30.05885);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(listingsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: listingsAsync.when(
        data: (listings) {
          final markers = listings
              .map(
                (l) => Marker(
                  point: LatLng(l.latitude, l.longitude),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
              )
              .toList();

          return FlutterMap(
            options: MapOptions(
              initialCenter: _kigaliCenter,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.kigali',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

