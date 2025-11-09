import 'package:flutter/material.dart';

/// 患者詳細 + カウンセリング記録UI（モック）
/// - 上部：患者基本情報カード
/// - 中央：タブ（プロフィール / カウンセリングメモ / 来院履歴）
/// - 下部：簡易アクションボタン（次回予約メモなど）
class PatientDetailPage extends StatelessWidget {
  final String name;
  final String tag;
  final String lastVisit;

  const PatientDetailPage({
    super.key,
    required this.name,
    required this.tag,
    required this.lastVisit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'プロフィール'),
              Tab(text: 'メモ'),
              Tab(text: '来院履歴'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- タブ1：プロフィール ---
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ProfileHeader(
                    name: name,
                    tag: tag,
                    lastVisit: lastVisit,
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'ステータス', value: '手術前 / 要フォロー'),
                  const SizedBox(height: 8),
                  _InfoRow(label: '主訴', value: '二重幅を自然に広げたい'),
                  const SizedBox(height: 8),
                  _InfoRow(label: '希望イメージ', value: 'ナチュラル / 会社バレNG'),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '注意事項メモ（例）',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '・ダウンタイムを極力短くしたい\n'
                    '・家族にはまだ話していない\n'
                    '・痛みに弱いので麻酔の説明を丁寧に',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),

            // --- タブ2：カウンセリングメモ ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SectionTitle('カウンセリングメモ（UIのみ）'),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'トークのポイントや反応をメモ\n\n例）\n・シュミレーション画像を見せたとき表情が明るくなった\n'
                          '・価格について少し不安そうだったので、分割支払いの説明を追加予定',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                      },
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('メモを保存（ダミー）'),
                    ),
                  ),
                ],
              ),
            ),

            // --- タブ3：来院履歴 ---
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SectionTitle('来院履歴（ダミー）'),
                const SizedBox(height: 8),
                _VisitTile(
                  date: lastVisit,
                  title: '初回カウンセリング',
                  note: '二重全般の説明 / 料金案内',
                ),
                const _VisitTile(
                  date: '2025-10-20',
                  title: 'LINE相談',
                  note: '施術後の腫れについて相談',
                ),
                const _VisitTile(
                  date: '2025-09-30',
                  title: '無料カウンセリング予約',
                  note: 'Webフォームから申し込み',
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            decoration: BoxDecoration(
              color: scheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.event_note_outlined),
                    label: const Text('次回予約メモ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                    },
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('プランを提案'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String tag;
  final String lastVisit;

  const _ProfileHeader({
    required this.name,
    required this.tag,
    required this.lastVisit,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: scheme.onPrimaryContainer.withValues(alpha: 0.1),
            child: Text(
              name.substring(0, 1),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '最終来院：$lastVisit',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _VisitTile extends StatelessWidget {
  final String date;
  final String title;
  final String note;

  const _VisitTile({
    required this.date,
    required this.title,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Text(
          date,
          style: const TextStyle(fontSize: 11),
        ),
        title: Text(title),
        subtitle: Text(
          note,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
