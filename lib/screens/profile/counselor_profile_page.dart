import 'package:flutter/material.dart';

/// カウンセラー自身のプロフィール＆個人実績ダッシュボード
/// - 上：プロフィールカード
/// - 中：今月の実績サマリー（ダミー）
/// - 下：このカウンセラーでダッシュボードを絞り込むスイッチ（今は見た目だけ）
class CounselorProfilePage extends StatefulWidget {
  const CounselorProfilePage({super.key});

  @override
  State<CounselorProfilePage> createState() => _CounselorProfilePageState();
}

class _CounselorProfilePageState extends State<CounselorProfilePage> {
  bool _filterDashboardByThisCounselor = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
                          '横山 たまゆめ',
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
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: -4,
                          children: [
                            Chip(
                              label: const Text(
                                '二重・目元が得意',
                                style: TextStyle(fontSize: 11),
                              ),
                              backgroundColor: scheme.secondaryContainer,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            Chip(
                              label: const Text(
                                'カウンセリング歴 5年',
                                style: TextStyle(fontSize: 11),
                              ),
                              backgroundColor: scheme.secondaryContainer,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                            ),
                          ],
                        ),
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

          _ProfileInfoRow(
            label: 'スタッフID',
            value: 'CNS-001',
          ),
          _ProfileInfoRow(
            label: '所属院',
            value: '新宿院（美容外科）',
          ),
          _ProfileInfoRow(
            label: '勤務形態',
            value: '常勤 / シフト制',
          ),
          _ProfileInfoRow(
            label: 'メール',
            value: 'example@example.com',
          ),

          const SizedBox(height: 24),

          Text(
            'カウンセラー別 実績サマリー（ダミー）',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: const [
              Expanded(
                child: _MiniKpiCard(
                  label: '今月の成約数',
                  value: '32件',
                  sub: '先月比 +5件',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MiniKpiCard(
                  label: '今月の成約率',
                  value: '68.5%',
                  sub: '目標 70%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _MiniKpiCard(
                  label: '今月の売上',
                  value: '870万円',
                  sub: '術式ベースの概算',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MiniKpiCard(
                  label: '担当患者数',
                  value: '124人',
                  sub: 'カウンセリング済み',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ダッシュボード絞り込みスイッチ
          SwitchListTile(
            title: const Text('このカウンセラーに紐づくデータだけダッシュボードに表示'),
            subtitle: const Text(
              'オンにするとホーム画面の成約率・売上などを「自分担当分」に絞って表示（※今は見た目だけのダミー）。',
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
            title: const Text('パスワード・ログイン情報（ダミー）'),
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
              'ログアウト（ダミー）',
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
