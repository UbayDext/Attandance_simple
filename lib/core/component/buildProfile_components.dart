import 'package:flutter/material.dart';

class BuildprofileComponents extends StatelessWidget {
  final String name;
  final String role;
  final String imageAssets;
  const BuildprofileComponents({
    super.key,
     required this.name,
     required this.role,
     required this.imageAssets,
     });

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/Untitled.jpg'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(role, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ],
    ),
  );
  }
}
