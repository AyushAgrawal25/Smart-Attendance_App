import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  final List<String> lables;
  final List<double> probabilities;
  const AttendancePage({
    Key? key,
    required this.lables,
    required this.probabilities,
  }) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 35,
        ),
        child: Column(
          children: [
            const Text(
              'Attendance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.lables.length,
                itemBuilder: (context, index) {
                  return AttendanceCard(
                    rollNo: widget.lables[index],
                    probability:
                        (widget.probabilities[index] * 100).toStringAsFixed(2),
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

class AttendanceCard extends StatelessWidget {
  final String rollNo, probability;
  const AttendanceCard({
    Key? key,
    required this.rollNo,
    required this.probability,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            rollNo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$probability%',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
