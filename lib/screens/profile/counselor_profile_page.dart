import 'package:flutter/material.dart';

/// カウンセラー自身のプロフィール＆個人実績ダッシュボード
/// - 上：プロフィールカード
/// - 中：カウンセラー別実績サマリー（期間切り替え対応）+ 成約率グラフ
/// - 下：このカウンセラーでダッシュボードを絞り込むスイッチ（今は見た目だけ）

// プロフィール画面用の表示範囲
enum CounselorRange {
  today,
  week,
  month,
}

class CounselorProfilePage extends StatefulWidget {
  const CounselorProfilePage({super.key});

  @override
  State<CounselorProfilePage> createState() => _CounselorProfilePageState();
}

class _CounselorProfilePageState extends State<CounselorProfilePage> {
  bool _filterDashboardByThisCounselor = true;
  CounselorRange _range = CounselorRange.month; // デフォルトは「1ヶ月」

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // ===== グラフ用ダミーデータ & KPI 用ダミーデータ =====
    List<double> conversions;
    List<String> xLabels;
    String chartTitle;

    String countLabel;
    String countValue;
    String rateLabel;
    String rateValue;
    String salesLabel;
    String salesValue;
    String patientLabel;
    String patientValue;

    switch (_range) {
      case CounselorRange.today:
        // 今日
        conversions = [0.72]; // 72%
        xLabels = ['本日'];
        // ダミー
        chartTitle = '今日の成約率';

        countLabel = '今日の成約数';
        countValue = '5件';

        rateLabel = '今日の成約率';
        rateValue = '72.0%';

        salesLabel = '今日の売上';
        salesValue = '120万円';

        patientLabel = '本日の担当患者';
        patientValue = '7人';
        break;

      case CounselorRange.week:
        // 直近1週間
        conversions = [0.62, 0.7, 0.68, 0.75, 0.65, 0.7, 0.66];
        xLabels = ['月', '火', '水', '木', '金', '土', '日'];
        // ダミー
        chartTitle = '直近1週間の成約率の推移';

        countLabel = '今週の成約数';
        countValue = '18件';

        rateLabel = '今週の成約率';
        rateValue = '69.2%';

        salesLabel = '今週の売上';
        salesValue = '320万円';

        patientLabel = '今週の担当患者';
        patientValue = '24人';
        break;

      case CounselorRange.month:
        // 今月
        conversions = [0.6, 0.68, 0.7, 0.72];
        xLabels = ['1週目', '2週目', '3週目', '4週目'];
        chartTitle = '今月の成約率の推移';

        countLabel = '今月の成約数';
        countValue = '32件';

        rateLabel = '今月の成約率';
        rateValue = '68.5%';

        salesLabel = '今月の売上';
        salesValue = '870万円';

        patientLabel = '今月の担当患者数';
        patientValue = '124人';
        break;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // プロフィールカード
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: scheme.primaryContainer,
                    child: const Icon(
                      Icons.person,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '土岐',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '美容外科カウンセラー（リーダー）',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '基本情報',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          const _ProfileInfoRow(
            label: 'スタッフID',
            value: 'CNS-001',
          ),
          const _ProfileInfoRow(
            label: '所属院',
            value: '新宿院（美容外科）',
          ),
          const _ProfileInfoRow(
            label: '勤務形態',
            value: '常勤 / シフト制',
          ),
          const _ProfileInfoRow(
            label: 'メール',
            value: 'example@example.com',
          ),

          const SizedBox(height: 24),

          // ===== 期間切り替え + 実績サマリー =====
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // ダミー
                'カウンセラー別 実績サマリー',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: _ProfileRangeChips(
                  value: _range,
                  onChanged: (r) {
                    setState(() {
                      _range = r;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _MiniKpiCard(
                  label: countLabel,
                  value: countValue,
                  // ダミー
                  sub: 'データ',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniKpiCard(
                  label: rateLabel,
                  value: rateValue,
                  sub: '目標 70%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniKpiCard(
                  label: salesLabel,
                  value: salesValue,
                  // ダミー
                  sub: '術式ベースの概算',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniKpiCard(
                  label: patientLabel,
                  value: patientValue,
                  // ダミー
                  sub: 'カウンセリング済み',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ===== グラフ =====
          Text(
            chartTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          _CounselorTrendChart(
            conversions: conversions,
            xLabels: xLabels,
          ),

          const SizedBox(height: 24),

          // ダッシュボード絞り込みスイッチ
          SwitchListTile(
            title: const Text('このカウンセラーに紐づくデータだけダッシュボードに表示'),
            subtitle: const Text(
              // ダミー
              'オンにするとホーム画面の成約率・売上などを「自分担当分」に絞って表示',
              style: TextStyle(fontSize: 11),
            ),
            value: _filterDashboardByThisCounselor,
            onChanged: (value) {
              setState(() {
                _filterDashboardByThisCounselor = value;
              });
              // TODO:
              // ここでグローバルな状態管理や Go/Python API へ
              // 「current_counselor_id」「filter_enabled」を保存して、
              // HomePage のクエリなどに反映させる想定。
            },
          ),

          const SizedBox(height: 24),

          Text(
            'アカウント',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_person_outlined),
            // ダミー
            title: const Text('パスワード・ログイン情報'),
            subtitle: const Text(
              '本番運用時はここからパスワード変更や2段階認証を設定。',
              style: TextStyle(fontSize: 11),
            ),
            onTap: () {
              // TODO: 認証まわりが入ったら遷移
            },
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout, color: scheme.error),
            title: Text(
              // ダミー
              'ログアウト',
              style: TextStyle(color: scheme.error),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ログアウト処理はまだダミーです')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniKpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _MiniKpiCard({
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
        color: scheme.primaryContainer.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(
              fontSize: 11,
              color: scheme.onPrimaryContainer.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

/// プロフィール画面用の期間切り替えチップ
class _ProfileRangeChips extends StatelessWidget {
  final CounselorRange value;
  final ValueChanged<CounselorRange> onChanged;

  const _ProfileRangeChips({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = CounselorRange.values;
    return Wrap(
      spacing: 4,
      children: items.map((r) {
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

  String _label(CounselorRange r) {
    switch (r) {
      case CounselorRange.today:
        return '今日';
      case CounselorRange.week:
        return '1週間';
      case CounselorRange.month:
        return '1ヶ月';
    }
  }
}

/// カウンセラー個人の成約率推移グラフ（ホームのグラフと似たバー表示）
class _CounselorTrendChart extends StatelessWidget {
  final List<double> conversions; // 0.0〜1.0
  final List<String> xLabels; // X軸ラベル（本日 / 曜日 / 週 など）

  const _CounselorTrendChart({
    required this.conversions,
    required this.xLabels,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // 0.0〜1.0 にクランプしてパーセント表示に
    final values = conversions.map((v) => v.clamp(0.0, 1.0)).toList();
    final labels =
        values.map((v) => '${(v * 100).toStringAsFixed(0)}%').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // ちょっと高さに余裕を持たせる
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(values.length, (index) {
              final v = values[index];
              // 棒の最大高さも少し控えめに
              final barHeight = 20 + (v * 70); // 20〜90px くらい

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        labels[index],
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        xLabels[index],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '※ 後でGo/PythonのAPIと連携して実データを表示予定。',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}
