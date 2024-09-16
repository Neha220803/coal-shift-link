import 'package:flutter/material.dart';

final List<Map<String, dynamic>> previousHazards = [
  {
    "hazard_id": "hazard101",
    "description": "Dust explosion due to inadequate dust control measures.",
    "resolution":
        "Implemented better dust suppression systems and increased ventilation.",
    "date": "2024-07-15",
  },
  {
    "hazard_id": "hazard102",
    "description": "Gas leak in the mine shaft.",
    "resolution":
        "Installed advanced gas detection systems and conducted regular checks.",
    "date": "2024-08-22",
  },
  {
    "hazard_id": "hazard103",
    "description": "Electrical short circuit due to faulty wiring.",
    "resolution":
        "Replaced faulty wiring and improved electrical maintenance protocols.",
    "date": "2024-09-01",
  },
  {
    "hazard_id": "hazard104",
    "description": "Collapse of mine roof due to poor support structures.",
    "resolution":
        "Reinforced support structures and conducted regular stability checks.",
    "date": "2024-09-10",
  },
  {
    "hazard_id": "hazard105",
    "description": "Water ingress leading to flooding in the lower levels.",
    "resolution":
        "Improved drainage systems and implemented water control measures.",
    "date": "2024-09-12",
  },
  {
    "hazard_id": "hazard106",
    "description": "Fire outbreak due to flammable materials.",
    "resolution":
        "Established strict flammable material handling protocols and installed fire suppression systems.",
    "date": "2024-09-14",
  },
];

final List<String> dgmsGuidelines = List.generate(
  6,
  (index) =>
      'Guideline ${index + 1}: Ensure proper safety measures are in place.',
);

class SafetyPlanScreen extends StatefulWidget {
  const SafetyPlanScreen({super.key});

  @override
  _SafetyPlanScreenState createState() => _SafetyPlanScreenState();
}

class _SafetyPlanScreenState extends State<SafetyPlanScreen> {
  List<Map<String, dynamic>> filteredHazards = List.from(previousHazards);
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Management Plan (SMP)'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (query) {
                  setState(() {
                    searchQuery = query.toLowerCase();
                    filteredHazards = previousHazards
                        .where((hazard) => hazard['hazard_id']
                            .toLowerCase()
                            .contains(searchQuery))
                        .toList();
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  hintText: 'Search Hazards...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // DGMS Guidelines Section
                  const Text(
                    'DGMS Guidelines',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: dgmsGuidelines.map((guideline) {
                      return _buildGuidelineCard(guideline);
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  // Previous Hazards Section
                  const Text(
                    'Previous Hazards',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: filteredHazards.map((hazard) {
                      return _buildHazardCard(context, hazard);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineCard(String guideline) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade300, Colors.red.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          guideline,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHazardCard(BuildContext context, Map<String, dynamic> hazard) {
    return GestureDetector(
      onTap: () => _showHazardDetails(context, hazard),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'ID: ${hazard['hazard_id']}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showHazardDetails(BuildContext context, Map<String, dynamic> hazard) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hazard ID: ${hazard['hazard_id']}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${hazard['description']}'),
              const SizedBox(height: 8),
              Text('Resolution: ${hazard['resolution']}'),
              const SizedBox(height: 8),
              Text('Date: ${hazard['date']}'),
            ],
          ),
          actions: <Widget>[
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
  }
}
