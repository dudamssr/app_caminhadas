import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:app_caminhadas/models/model.dart';
import 'package:app_caminhadas/providers/provider.dart';

class NewWalkScreen extends StatefulWidget {
  const NewWalkScreen({super.key});

  @override
  State<NewWalkScreen> createState() => _NewWalkScreenState();
}

class _NewWalkScreenState extends State<NewWalkScreen> {
  final LatLng _startPoint = const LatLng(-22.7011, -46.7644);
  LatLng? _destinationPoint;

  double _distanceInMeters = 0.0;
  int _calories = 0;
  int _minutes = 0;

  void _onTapMap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _destinationPoint = point;
      const Distance distance = Distance();
      _distanceInMeters = distance.as(LengthUnit.Meter, _startPoint, _destinationPoint!);

      _minutes = (_distanceInMeters / 83.3).round();
      if (_minutes < 1) _minutes = 1;

      _calories = ((_distanceInMeters / 1000) * 65).round();
    });
  }

  void _showSaveModal() {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Caminhou uma distância de ${_distanceInMeters.toStringAsFixed(0)}m queimando cerca de $_calories calorias',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título da caminhada',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  final newWalk = Walk(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text.trim(),
                    startPoint: _startPoint,
                    endPoint: _destinationPoint!,
                    distanceInMeters: _distanceInMeters,
                    estimatedCalories: _calories,
                    estimatedMinutes: _minutes,
                  );

                  Provider.of<WalkProvider>(context, listen: false).addWalk(newWalk);
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova caminhada'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _destinationPoint == null
                  ? 'Clique no destino da sua caminhada'
                  : 'Vai percorrer uma distância de ${_distanceInMeters.toStringAsFixed(0)}m queimando cerca de $_calories calorias',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (_destinationPoint != null)
            ElevatedButton(
              onPressed: _showSaveModal,
              child: const Text('Salvar'),
            ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _startPoint,
                initialZoom: 15.0,
                onTap: _onTapMap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _startPoint,
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                    ),
                    if (_destinationPoint != null)
                      Marker(
                        point: _destinationPoint!,
                        child: const Icon(Icons.location_on, color: Colors.black, size: 40),
                      ),
                  ],
                ),
                if (_destinationPoint != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [_startPoint, _destinationPoint!],
                        strokeWidth: 4.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}