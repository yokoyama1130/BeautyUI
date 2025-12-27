import 'package:flutter/material.dart';
import '../patients/patient_detail_page.dart';

enum DashboardRange {
  today,
  week,
  month,
}

enum DashboardMetric {
  conversion,
  sales,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DashboardRange _range = DashboardRange.today;
  DashboardMetric _metric = DashboardMetric.conversion;

  // ダミーデータ：成約率（0〜1スケール）
  final Map<DashboardRange, List<double>> _conversionRateData = {
    DashboardRange.today: [0.62],
    DashboardRange.week: [0.4, 0.55, 0.7, 0.6, 0.65, 0.5, 0.58],
    DashboardRange.month: [0.45, 0.52, 0.6, 0.55],
  };

  // ダミーデータ：売上（円）
  final Map<DashboardRange, List<int>> _salesData = {
    DashboardRange.today: [350000], // 35万くらい
    DashboardRange.week: [
      300000,
      420000,
      500000,
      380000,
      600000,
      250000,
      450000,
    ],
    DashboardRange.month: [
      2200000,
      2500000,
      2000000,
      2800000,
    ],
  };

  final Map<DashboardRange, List<int>> _bookingCountData = {
    DashboardRange.today: [7],
    DashboardRange.week: [5, 6, 8, 7, 9, 4, 6],
    DashboardRange.month: [30, 34, 28, 40],
  };

  @override
  Widget build(BuildContext context) {
    final conversion = _conversionRateData[_range]!;
    final booking = _bookingCountData[_range]!;
    final sales = _salesData[_range]!;

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

          // グラフタイトル + メトリック切り替え
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _metric == DashboardMetric.conversion
                    ? '成約率の推移'
                    : '売上の推移',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _MetricToggle(
                value: _metric,
                onChanged: (m) {
                  setState(() {
                    _metric = m;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          _MetricChart(
            range: _range,
            metric: _metric,
            conversionValues: conversion,
            salesValues: sales,
          ),

          const SizedBox(height: 24),

          const Text(
            '本日の予約',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const _AppointmentCard(
            time: '10:00',
            name: '山田 花子',
            menu: '二重整形 初回カウンセリング',
            tag: '初回 / 二重',
            lastVisit: '2025-11-09',
          ),
          const _AppointmentCard(
            time: '13:30',
            name: '佐藤 太郎',
            menu: '鼻整形 手術前カウンセリング',
            tag: '手術前 / 鼻',
            lastVisit: '2025-11-09',
          ),
          const _AppointmentCard(
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

class _MetricToggle extends StatelessWidget {
  final DashboardMetric value;
  final ValueChanged<DashboardMetric> onChanged;

  const _MetricToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: [
        ChoiceChip(
          label: const Text('成約率', style: TextStyle(fontSize: 11)),
          selected: value == DashboardMetric.conversion,
          onSelected: (_) => onChanged(DashboardMetric.conversion),
        ),
        ChoiceChip(
          label: const Text('売上', style: TextStyle(fontSize: 11)),
          selected: value == DashboardMetric.sales,
          onSelected: (_) => onChanged(DashboardMetric.sales),
        ),
      ],
    );
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
            sub: 'データ',
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

class _MetricChart extends StatelessWidget {
  final DashboardRange range;
  final DashboardMetric metric;
  final List<double> conversionValues; // 0.0〜1.0
  final List<int> salesValues; // 円

  const _MetricChart({
    required this.range,
    required this.metric,
    required this.conversionValues,
    required this.salesValues,
  });

  @override
  Widget build(BuildContext context) {
    // ★ 「今日」のときだけ専用カードUIに切り替え
    if (range == DashboardRange.today) {
      return _TodayMetricChart(
        metric: metric,
        conversion: conversionValues.isNotEmpty ? conversionValues.first : 0.0,
        sales: salesValues.isNotEmpty ? salesValues.first : 0,
      );
    }

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

    final bool isConversion = metric == DashboardMetric.conversion;

    // 棒の高さ計算用
    List<double> barValues;
    List<String> displayValues;

    if (isConversion) {
      barValues = conversionValues.map((v) => v.clamp(0.0, 1.0)).toList();
      displayValues =
          barValues.map((v) => '${(v * 100).toStringAsFixed(0)}%').toList();
    } else {
      // 売上は最大値に対する比率で高さを決める
      final maxSale = salesValues
          .reduce((a, b) => a > b ? a : b)
          .toDouble()
          .clamp(1, double.infinity);
      barValues = salesValues
          .map((v) => (v.toDouble() / maxSale).clamp(0.0, 1.0))
          .toList();
      displayValues =
          salesValues.map((v) => '${(v / 10000).toStringAsFixed(1)}万').toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(barValues.length, (index) {
              final v = barValues[index];
              final barHeight = 20 + (v * 80); // 20〜100px

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        displayValues[index],
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
          isConversion
              ? '※ $xLabelごとの成約率（後でAPI連携予定）'
              : '※ $xLabelごとの売上（後でAPI連携予定）',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _TodayMetricChart extends StatelessWidget {
  final DashboardMetric metric;
  final double conversion; // 0.0〜1.0
  final int sales; // 円

  const _TodayMetricChart({
    required this.metric,
    required this.conversion,
    required this.sales,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isConversion = metric == DashboardMetric.conversion;

    final double ratio = isConversion
        ? conversion.clamp(0.0, 1.0)
        : (sales.toDouble() / 500000).clamp(0.0, 1.0); // 売上は50万を目安に

    final String title = isConversion ? '今日の成約率' : '今日の売上';
    final String valueText = isConversion
        ? '${(conversion * 100).toStringAsFixed(1)}%'
        : '${(sales / 10000).toStringAsFixed(1)}万円';
    final String subText = isConversion
        ? '目標：70% をイメージ'
        : '目標：50万円をイメージ';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                valueText,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                subText,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 横のプログレスバー
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              return Stack(
                children: [
                  Container(
                    width: barWidth,
                    height: 10,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: barWidth * ratio,
                    height: 10,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  if (isConversion)
                    // 目標70%の位置に細いラインを表示（なんとなくの指標）
                    Positioned(
                      left: barWidth * 0.7,
                      child: Container(
                        width: 2,
                        height: 14,
                        decoration: BoxDecoration(
                          color: scheme.error.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            isConversion
                ? '赤線が目標成約率70%の目安です。'
                : '棒の長さは目安（50万円）に対する達成度です。',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
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
