import 'package:flutter/material.dart';
import '../patients/patient_detail_page.dart';

enum DashboardRange {
  today,
  week,
  month,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DashboardRange _range = DashboardRange.today;

  // ダミーデータ：成約率・件数（0〜1スケール）
  final Map<DashboardRange, List<double>> _conversionRateData = {
    DashboardRange.today: [0.62],
    DashboardRange.week: [0.4, 0.55, 0.7, 0.6, 0.65, 0.5, 0.58],
    DashboardRange.month: [0.45, 0.52, 0.6, 0.55],
  };

  final Map<DashboardRange, List<int>> _bookingCountData = {
    DashboardRange.today: [7],
    DashboardRange.week: [5, 6, 8, 7, 9, 4, 6],
    DashboardRange.month: [30, 34, 28, 40],
  };

  String _rangeLabel(DashboardRange range) {
    switch (range) {
      case DashboardRange.today:
        return '今日';
      case DashboardRange.week:
        return '1週間';
      case DashboardRange.month:
        return '1ヶ月';
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversion = _conversionRateData[_range]!;
    final booking = _bookingCountData[_range]!;
    final avgConversion =
        (conversion.reduce((a, b) => a + b) / conversion.length) * 100;
    final totalBooking = booking.reduce((a, b) => a + b);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // 上：サマリー + 期間切り替え
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '今日のサマリー',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _RangeChips(
                value: _range,
                onChanged: (range) {
                  setState(() {
                    _range = range;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          _KpiRow(
            avgConversion: avgConversion,
            totalBooking: totalBooking,
            range: _range,
          ),

          const SizedBox(height: 24),

          // 成約率の推移（簡易棒グラフ）
          const Text(
            '成約率の推移',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _ConversionChart(
            range: _range,
            values: conversion,
          ),

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
            lastVisit: '2025-11-09',
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

class _RangeChips extends StatelessWidget {
  final DashboardRange value;
  final ValueChanged<DashboardRange> onChanged;

  const _RangeChips({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ranges = DashboardRange.values;
    return Wrap(
      spacing: 4,
      children: ranges.map((r) {
        final selected = r == value;
        return ChoiceChip(
          label: Text(
            _label(r),
            style: const TextStyle(fontSize: 11),
          ),
          selected: selected,
          onSelected: (_) => onChanged(r),
        );
      }).toList(),
    );
  }

  String _label(DashboardRange range) {
    switch (range) {
      case DashboardRange.today:
        return '今日';
      case DashboardRange.week:
        return '1週間';
      case DashboardRange.month:
        return '1ヶ月';
    }
  }
}

class _KpiRow extends StatelessWidget {
  final double avgConversion;
  final int totalBooking;
  final DashboardRange range;

  const _KpiRow({
    required this.avgConversion,
    required this.totalBooking,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    String bookingLabel;
    switch (range) {
      case DashboardRange.today:
        bookingLabel = '本日の件数';
        break;
      case DashboardRange.week:
        bookingLabel = '1週間の件数';
        break;
      case DashboardRange.month:
        bookingLabel = '1ヶ月の件数';
        break;
    }

    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            label: bookingLabel,
            value: '$totalBooking件',
            sub: 'ダミーデータ',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            label: '平均成約率',
            value: '${avgConversion.toStringAsFixed(1)}%',
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

class _ConversionChart extends StatelessWidget {
  final DashboardRange range;
  final List<double> values; // 0.0〜1.0

  const _ConversionChart({
    required this.range,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    String xLabel;
    switch (range) {
      case DashboardRange.today:
        xLabel = '本日';
        break;
      case DashboardRange.week:
        xLabel = '曜日';
        break;
      case DashboardRange.month:
        xLabel = '週';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(values.length, (index) {
              final v = values[index].clamp(0.0, 1.0);
              final barHeight = 20 + (v * 80); // 20〜100px
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${(v * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '※ $xLabelごとのダミー成約率（後でAPI連携予定）',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
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
          // ホームからも患者詳細へ飛べるように
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
