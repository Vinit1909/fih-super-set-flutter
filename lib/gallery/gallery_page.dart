// lib/gallery/gallery_page.dart
import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> apps = List.generate(10, (index) {
      return {
        'name': 'App ${index + 1}',
        'image':
            'assets/images/game${index + 1}.png', // Different image for each app
        'age': '${3 + index}+' // Example age recommendation
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Superset Gallery'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // Handle home action
          },
        ),
        centerTitle: true, // Center the logo in the AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu action
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      3, // Increase the number of tiles in the horizontal axis
                  crossAxisSpacing: 20, // Space between tiles in the cross axis
                  mainAxisSpacing: 20, // Space between tiles in the main axis
                  childAspectRatio:
                      2 / 1, // Adjust the aspect ratio to make tiles smaller
                ),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(apps[index]['name']!),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Image.asset(
                                    apps[index]['image']!,
                                    fit: BoxFit.contain,
                                    width: 80, // Smaller width
                                    height: 80, // Smaller height
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  child: Text(
                                    'Age: ${apps[index]['age']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text('App information goes here.'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Play Now'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Add action for "Play Now" button here
                                },
                              ),
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.asset(
                                apps[index]['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                                4.0), // Adjust padding to fit smaller tiles
                            child: Text(
                              apps[index]['name']!,
                              style: const TextStyle(
                                fontSize:
                                    12, // Smaller font size to fit smaller tiles
                                fontWeight: FontWeight.bold,
                                color: Colors
                                    .deepPurple, // Use previous color scheme
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
