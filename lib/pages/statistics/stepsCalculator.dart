import 'package:pedometer/pedometer.dart';

class StepCounterService {
  late final Stream<StepCount> _stepCountStream;
  int steps = 0;

  Function(int)? onStepsUpdated;
  Function(dynamic)? onError;

  StepCounterService({this.onStepsUpdated, this.onError});

  void start() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (StepCount event) {
        steps = event.steps;
        if (onStepsUpdated != null) {
          onStepsUpdated!(steps);
        }
      },
      onError: (error) {
        if (onError != null) {
          onError!(error);
        }
      },
    );
  }

  void stop() {
    _stepCountStream.drain();
  }

  int getSteps() {
    return steps;
  }
}