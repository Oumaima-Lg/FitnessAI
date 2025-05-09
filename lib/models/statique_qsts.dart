import 'package:flutter/material.dart';

class StatiqueQsts {
  final String title;
  final IconData icon;
  final List<String> qsts;

  StatiqueQsts({
    required this.title,
    required this.icon,
    required this.qsts,
  });
}

final List<StatiqueQsts> lesQuestions = [
  StatiqueQsts(
    title: 'Ask', 
    icon: Icons.edit,
    qsts: [
      'What should I eat after a workout ?',
      'How many calories do I need per day ?',
      'How much water should I drink per day ?',
    ],
  ),
  StatiqueQsts(
    title: 'Explain', 
    icon: Icons.info_outline,
    qsts: [
      'Why is protein important after training ?',
      'How does sleep affect muscle recovery ?',
      'What happens if I skip meals regularly ?',
    ],
  ),
  StatiqueQsts(
    title: 'Recommend', 
    icon: Icons.recommend,
    qsts: [
      'Recommend me a 20-minute home workout ?',
      'What are some healthy snacks after dinner ?',
      'Suggest a weekly workout plan for beginners.',
    ],
  ),
];