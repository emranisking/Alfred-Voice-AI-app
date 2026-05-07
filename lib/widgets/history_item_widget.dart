import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/history.dart';
import '../providers/history_provider.dart';

class HistoryItemWidget extends StatelessWidget {
  final History item;

  const HistoryItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.message,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        item.timestamp.toLocal().toString(),
        style: const TextStyle(color: Colors.white54),
      ),
      trailing: IconButton(
        icon: Image.asset(
          'assets/icon/play-button-arrowhead.png',
          width: 28,
          height: 28,
          color: Colors.yellow,
        ),
        onPressed: () {
          context.read<HistoryProvider>().playAudio(item.mp3Path);
        },
      ),
    );
  }
}