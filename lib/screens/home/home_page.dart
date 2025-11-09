import 'package:flutter/material.dart';
import '../patients/patient_detail_page.dart'; // ★ 患者詳細画面へのimportを追加

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            '今日のサマリー',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _KpiRow(),
          const SizedBox(height: 24),
          const Text(
            '本日の予約',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _AppointmentCard(
            time: '10:00',
            name: '山田 花子',
            menu: '二重整形 初回カウンセリング',
            tag: '初回 / 二重',
            lastVisit: '2025-11-09', // ← 今日を想定
          ),
          _AppointmentCard(
            time: '13:30',
            name: '佐藤 太郎',
            menu: '鼻整形 手術前カウンセリング',
            tag: '手術前 / 鼻',
            lastVisit: '2025-11-09',
          ),
          _AppointmentCard(
            time: '16:00',
            name: '田中 みなみ',
            menu: '輪郭(エラ) 2回目カウンセリング',
            tag: 'リピーター / 輪郭',
            lastVisit: '2025-11-09',
          ),
        ],
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _KpiCard(
            label: '本日の件数',
            value: '7件',
            sub: '＋2件 / 昨日比',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            label: '成約率',
            value: '62%',
            sub: '目標 70%',
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(fontSize: 11, color: scheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String time;
  final String name;
  final String menu;
  final String tag;
  final String lastVisit;

  const _AppointmentCard({
    required this.time,
    required this.name,
    required this.menu,
    required this.tag,
    required this.lastVisit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(top: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.secondaryContainer,
          child: Text(
            time,
            style: const TextStyle(fontSize: 11),
          ),
        ),
        title: Text(name),
        subtitle: Text(menu),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // ★ タップで患者詳細画面に遷移
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PatientDetailPage(
                name: name,
                tag: tag,
                lastVisit: lastVisit,
              ),
            ),
          );
        },
      ),
    );
  }
}
