import 'package:flutter/material.dart';

class CustomTimeInputPicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const CustomTimeInputPicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  State<CustomTimeInputPicker> createState() => _CustomTimeInputPickerState();
}

class _CustomTimeInputPickerState extends State<CustomTimeInputPicker> {
  late TextEditingController hourController;
  late TextEditingController minuteController;
  late String period; // AM / PM
  late FocusNode hourFocus;
  late FocusNode minuteFocus;

  @override
  void initState() {
    super.initState();
    final hour = widget.initialTime.hourOfPeriod;
    final minute = widget.initialTime.minute;
    period = widget.initialTime.period == DayPeriod.am ? 'AM' : 'PM';

    hourController = TextEditingController(text: hour.toString().padLeft(1, '0'));
    minuteController = TextEditingController(text: minute.toString().padLeft(2, '0'));
    hourFocus = FocusNode();
    minuteFocus = FocusNode();

    // Add listeners to rebuild when focus changes
    hourFocus.addListener(() => setState(() {}));
    minuteFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    hourFocus.dispose();
    minuteFocus.dispose();
    super.dispose();
  }

  void _updateTime() {
    final int? hour = int.tryParse(hourController.text);
    final int? minute = int.tryParse(minuteController.text);

    if (hour == null || hour < 1 || hour > 12) return;
    if (minute == null || minute < 0 || minute > 59) return;

    final int fullHour = period == 'AM' ? hour % 12 : (hour % 12) + 12;

    widget.onTimeChanged(TimeOfDay(hour: fullHour, minute: minute));
  }

  void _setPeriod(String newPeriod) {
    setState(() {
      period = newPeriod;
      _updateTime();
    });
  }

  InputDecoration _inputDecoration(FocusNode focusNode) {
    return InputDecoration(
      filled: true,
      fillColor: focusNode.hasFocus ? Color(0xFF6B5DAD).withOpacity(0.3) : Color(0xFF2E2B5A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF6B5DAD), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF6B5DAD), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF6B5DAD), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      counterText: '', // Hide the character counter
    );
  }

  TextStyle _textStyle(FocusNode focusNode) {
    return TextStyle(
      fontSize: 32,
      color: focusNode.hasFocus ? Colors.white : Colors.white70,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hour input
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: hourController,
            focusNode: hourFocus,
            keyboardType: TextInputType.number,
            maxLength: 2,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF6B5DAD),
              fontWeight: FontWeight.bold,
            ),
            onChanged: (_) => _updateTime(),
          ),
        ),
        SizedBox(width: 8),
        Text(
          ':', 
          style: TextStyle(
            fontSize: 24, 
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8),

        // Minute input
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: minuteController,
            focusNode: minuteFocus,
            keyboardType: TextInputType.number,
            maxLength: 2,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF6B5DAD),
              fontWeight: FontWeight.bold,
            ),
            onChanged: (_) => _updateTime(),
          ),
        ),
        SizedBox(width: 12),

        // AM/PM selector
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _PeriodButton(
                text: 'AM',
                selected: period == 'AM',
                onTap: () => _setPeriod('AM'),
              ),
              Container(height: 1, color: Colors.grey.shade300),
              _PeriodButton(
                text: 'PM',
                selected: period == 'PM',
                onTap: () => _setPeriod('PM'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: selected ? Color(0xFF6B5DAD) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Color(0xFF6B5DAD),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}