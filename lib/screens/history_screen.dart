import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../widgets/history_item_widget.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Image.asset(
            'assets/icon/arrow.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFF0A0E21),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.historyList.isEmpty
          ? const Center(
        child: Text(
          "No history yet.\nStart by generating your first voice!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: provider.historyList.length,
        itemBuilder: (context, index) {
          return HistoryItemWidget(item: provider.historyList[index]);
        },
      ),
    );
  }
}