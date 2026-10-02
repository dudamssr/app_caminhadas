import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider.dart';
import 'splash.dart';
import 'walk.dart';
import 'details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WalkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caminhadas'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.flash_on, color: Colors.pink),
              title: const Text('Splash'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.pink,
              ),
              title: Text(provider.isDarkMode ? 'Tema Claro' : 'Tema Escuro'),
              onTap: () {
                provider.toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: provider.walks.isEmpty
          ? const Center(child: Text('Nenhuma caminhada cadastrada.'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.walks.length,
              itemBuilder: (ctx, index) {
                final walk = provider.walks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailsScreen(walk: walk)),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: walk.photoPath != null && walk.photoPath!.isNotEmpty
                              ? Image.network(
                                  walk.photoPath!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: Colors.pink.shade50,
                                    child: const Icon(Icons.image, color: Colors.pink, size: 40),
                                  ),
                                )
                              : Container(
                                  color: Colors.pink.shade50,
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.crop_square, size: 40, color: Colors.pink),
                                        Text('Foto'),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            walk.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewWalkScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}