class StepItem {
  final String id;
  final String stepTitle;
  final String? stepImage;
  final String stepDescription;
  
  StepItem({
    required this.id,
    required this.stepTitle,
    this.stepImage,
    required this.stepDescription,
  });
}
