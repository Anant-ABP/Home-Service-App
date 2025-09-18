import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  final List<String> _days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  final Map<String, bool> _dayEnabled = {};
  final Map<String, TimeOfDay> _startTime = {};
  final Map<String, TimeOfDay> _endTime = {};

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var day in _days) {
        _dayEnabled[day] = prefs.getBool('${day}_enabled') ?? false;
        int startHour = prefs.getInt('${day}_startHour') ?? 9;
        int startMinute = prefs.getInt('${day}_startMinute') ?? 0;
        int endHour = prefs.getInt('${day}_endHour') ?? 17;
        int endMinute = prefs.getInt('${day}_endMinute') ?? 0;
        _startTime[day] = TimeOfDay(hour: startHour, minute: startMinute);
        _endTime[day] = TimeOfDay(hour: endHour, minute: endMinute);
      }
    });
  }

  Future<void> _saveAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    for (var day in _days) {
      await prefs.setBool('${day}_enabled', _dayEnabled[day]!);
      await prefs.setInt('${day}_startHour', _startTime[day]!.hour);
      await prefs.setInt('${day}_startMinute', _startTime[day]!.minute);
      await prefs.setInt('${day}_endHour', _endTime[day]!.hour);
      await prefs.setInt('${day}_endMinute', _endTime[day]!.minute);
    }
  }

  Future<void> _pickTime(String day, bool isStart) async {
    final initial = isStart ? _startTime[day]! : _endTime[day]!;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime[day] = picked;
        } else {
          _endTime[day] = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available At'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _days.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final enabled = _dayEnabled[day] ?? false;

                  return ListTile(
                    title: Text(day, style: const TextStyle(fontSize: 16)),
                    subtitle: enabled
                        ? Text(
                            '${_startTime[day]!.format(context)} - ${_endTime[day]!.format(context)}',
                          )
                        : const Text('Not Available'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (enabled) ...[
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _pickTime(day, true),
                          ),
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _pickTime(day, false),
                          ),
                        ],
                        Switch(
                          value: enabled,
                          onChanged: (value) {
                            setState(() {
                              _dayEnabled[day] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveAvailability();
                  Navigator.pop(context, _dayEnabled);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
