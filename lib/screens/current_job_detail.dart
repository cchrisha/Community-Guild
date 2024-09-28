import 'package:flutter/material.dart';

class CurrentJobDetailPage extends StatefulWidget {
  const CurrentJobDetailPage({super.key});

  @override
  State<CurrentJobDetailPage> createState() => _CurrentJobDetailPageState();
}

class _CurrentJobDetailPageState extends State<CurrentJobDetailPage> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finishing Job',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Implement share functionality
            },
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (item) {
              // Implement menu item selection
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Edit')),
              const PopupMenuItem<int>(value: 1, child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 28,
                    left: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: _toggleExpansion,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height: _isExpanded ? 180 : 120,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          child: Stack(
                            children: [
                              const Positioned(
                                top: 16,
                                left: 16,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.lightBlueAccent,
                                  child: Icon(Icons.person,
                                      color: Colors.white, size: 30),
                                ),
                              ),
                              Positioned(
                                left:
                                    72, // Adjust this value to position text properly
                                top: 16,
                                right: 16,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Lana',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Location: Mangaldan Pangasinan',
                                        style: TextStyle(color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Text(
                                        'Profession: Electrician',
                                        style: TextStyle(color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (_isExpanded) ...[
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Contact: +63 912 345 6789',
                                          style:
                                              TextStyle(color: Colors.black54),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Text(
                                          'Email: example@example.com',
                                          style:
                                              TextStyle(color: Colors.black54),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Reward: P1000.00',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const ExpansionTile(
              title: Text(
                'Job Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'I need an Electrician that can fix my refrigerator. The reward is still negotiable.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const JobPhotoCard(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 238, 238),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  child: const Text(
                    'Cancel this job',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement Start action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                  child: const Text(
                    'Complete',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class JobPhotoCard extends StatelessWidget {
  const JobPhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Replace with the number of photos
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://via.placeholder.com/150', // Replace with actual photo URL
                fit: BoxFit.cover,
                width: 150,
              ),
            ),
          );
        },
      ),
    );
  }
}
