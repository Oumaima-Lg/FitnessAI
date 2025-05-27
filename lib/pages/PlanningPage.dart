import 'package:fitness/components/personalized_widget.dart';
import 'package:fitness/components/textStyle/textstyle.dart';
import 'package:fitness/pages/planning/focus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void navigateToPlanningPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E2F55),
              Color(0xFF23253C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: page,
      ),
    ),
  );
}

class PlanningPage extends StatefulWidget {
  const PlanningPage({super.key});

  @override
  State<PlanningPage> createState() => _PlanningPageState();
}

class _PlanningPageState extends State<PlanningPage> {
  final ScrollController _scrollController = ScrollController();
  late DateTime _currentDate;
  late List<DateTime> _dates;
  final double _dayCardWidth = 72.0;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentDate());
  }

  void _generateDates() {
    _dates = List.generate(
        21, (index) => _currentDate.subtract(Duration(days: 10 - index)));
  }

  void _scrollToCurrentDate() {
    final initialOffset = 10 * _dayCardWidth;
    _scrollController.animateTo(
      initialOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   centerTitle: true,
      //   title: Text(
      //     'Planning',
      //     style: titleTextStyle(),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Action de retour
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            'Planning',
            style: titleTextStyle(),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                navigateToPlanningPage(context, FocusScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Color(0xFFC58BF2), Color(0xFFEEA4CE)],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildDateSelector(),
              const SizedBox(height: 28),
              Image.asset('images/calendar.png'),
              const SizedBox(height: 24),
              _buildActivitiesList(),
              const SizedBox(height: 25),
              buildSchedule(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Text(
        //   'Planning',
        //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        // ),
        SizedBox(
          height: 30,
        ),

        Text(
          DateFormat('MMMM y').format(_currentDate),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isToday = _isSameDay(date, DateTime.now());

          return DayCard(
            date: date,
            isToday: isToday,
          );
        },
      ),
    );
  }

  Widget _buildActivitiesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: GradientTitleText(
                  text: 'Today',
                  alignment: Alignment.topLeft,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '7 Activities',
                style: TextStyle(
                    color: Color(0xFFDBC4C8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Column(
        //   children: const [
        //     ActivityItem(time: '7:30 AM', activity: 'Drinking 300ml Water'),
        //     ActivityItem(time: '11:30 AM', activity: 'Eat Snack (Fitbar)'),
        //     ActivityItem(time: '2:30 PM', activity: 'Eat Snack (Fitbar)'),
        //     ActivityItem(time: '3:30 PM', activity: 'Eat Snack (Fitbar)'),
        //   ],
        // ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget buildSchedule() {
    final events = [
      {
        'time': '8:30 AM',
        'title': 'Drinking 300ml',
        'icon': 'images/icons/Cardio/icon1.png'
      },
      {
        'time': '11:30 AM',
        'title': 'Eat Smack',
        'icon': 'images/icons/Cardio/icon1.png'
      },
      {
        'time': '2:30 PM',
        'title': 'Eat Smack',
        'icon': 'images/icons/Cardio/icon1.png'
      },
      {
        'time': '3:30 PM',
        'title': 'Eat Smack',
        'icon': 'images/icons/Cardio/icon1.png'
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (context, index) => const Divider(height: 40),
      itemBuilder: (context, index) {
        final event = events[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                event['time']!,
                style: TextStyle(
                  color: Color(0xFFDBC4C8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color(0xFFDBC4C8),
                  //     spreadRadius: 2,
                  //     blurRadius: 2,
                  //   )
                  // ]
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/icons/Cardio/icon1.png',
                      width: 37.62,
                      height: 40.63,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Text(
                        event['title']!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DayCard extends StatelessWidget {
  final DateTime date;
  final bool isToday;

  const DayCard({
    super.key,
    required this.date,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: isToday ? null : Color(0xFFA8ACAC),
        gradient: isToday
            ? LinearGradient(
                colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        // color: isToday ? Colors.blue[100] : Color(0xFFA8ACAC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('E').format(date),
            style: TextStyle(
              color: isToday ? Colors.white : Color(0xFF7B6F72),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('d').format(date),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.white : Color(0xFF7B6F72),
            ),
          ),
        ],
      ),
    );
  }
}

// ActivityItem reste identique à la version précédente
class ActivityItem extends StatelessWidget {
  final String time;
  final String activity;

  const ActivityItem({
    super.key,
    required this.time,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              activity,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
