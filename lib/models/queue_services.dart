import 'package:shared_preferences/shared_preferences.dart';

class QueueServices {
  int currentQueueNumber;
  String lastQueueNum;
  QueueServices({required this.currentQueueNumber, required this.lastQueueNum});
  Future<void> initializeQueueNumber() async {
    final prefs = await SharedPreferences.getInstance();
    currentQueueNumber = prefs.getInt(lastQueueNum) ?? 0;
  }

  // Get next bill number
  Future<int> getNextQueueNumber() async {
    final prefs = await SharedPreferences.getInstance();
    currentQueueNumber++;
    await prefs.setInt(lastQueueNum, currentQueueNumber);
    return currentQueueNumber;
  }
}
