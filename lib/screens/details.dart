import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/model.dart';
import '../providers/provider.dart';

class DetailsScreen extends StatefulWidget {
  final Walk walk;
  const DetailsScreen({super.key, required this.walk});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String? _currentPhotoPath;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _currentPhotoPath = widget.walk.photoPath;
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();

        if (!mounted) return;

        Provider.of<WalkProvider>(context, listen: false)
            .updateWalkPhoto(widget.walk.id, image.path);

        setState(() {
          _currentPhotoPath = image.path;
          _imageBytes = bytes;
          widget.walk.photoPath = image.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar imagem: $e'),
          backgroundColor: Colors.pink,
        ),
      );
    }
  }

  Widget _buildImageWidget() {
    if (_imageBytes != null) {
      return Image.memory(_imageBytes!, fit: BoxFit.cover);
    } else if (_currentPhotoPath != null && _currentPhotoPath!.isNotEmpty) {
      return Image.network(
        _currentPhotoPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              'Clique para selecionar uma imagem',
              style: TextStyle(color: Colors.pink.shade700),
            ),
          );
        },
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo, size: 50, color: Colors.pink.shade400),
          onPressed: _pickImage,
        ),
        Text(
          'Clique para escolher uma imagem',
          style: TextStyle(
            color: Colors.pink.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = widget.walk.estimatedMinutes > 0
        ? widget.walk.estimatedMinutes
        : (widget.walk.distanceInMeters / 83.3).round().clamp(1, 9999);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.walk.title),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            color: Colors.pink.shade50,
            child: InkWell(
              onTap: _pickImage,
              child: _buildImageWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Caminhou uma distância de ${widget.walk.distanceInMeters.toStringAsFixed(0)}m '
              'em cerca de $minutes min, '
              'queimando aproximadamente ${widget.walk.estimatedCalories} calorias.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade900,
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: widget.walk.startPoint,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.walk.startPoint,
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                    ),
                    Marker(
                      point: widget.walk.endPoint,
                      child: const Icon(Icons.location_on, color: Colors.pink, size: 40),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [widget.walk.startPoint, widget.walk.endPoint],
                      strokeWidth: 4.0,
                      color: Colors.pink,
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