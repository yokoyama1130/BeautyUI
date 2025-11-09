import 'package:flutter/material.dart';

/// 顔スキャンの結果を表示するページ
/// （現時点ではUIモック。後でPython/Go APIに接続予定）
class ScanResultPage extends StatelessWidget {
  final String? imagePath; // 撮影 or ギャラリー選択した画像パス

  const ScanResultPage({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('スキャン結果'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 解析画像プレビュー
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image: imagePath != null
                      ? DecorationImage(
                          image: AssetImage(imagePath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imagePath == null
                    ? const Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'AI解析結果',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _AnalysisCard(
              icon: Icons.face_retouching_natural,
              label: '肌質',
              result: '水分量：やや低め（38%）\n毛穴の開き：軽度\nしみ：小〜中程度',
              suggestion: '保湿ケアと美白成分（ビタミンC誘導体）を推奨',
            ),
            _AnalysisCard(
              icon: Icons.remove_red_eye_outlined,
              label: '目元',
              result: '左右差：小\nまぶた：厚め\nクマ：わずかにあり',
              suggestion: '埋没法 + ヒアルロン酸注入が適応範囲',
            ),
            _AnalysisCard(
              icon: Icons.camera_front_outlined,
              label: '鼻・輪郭',
              result: '鼻背：わずかに低め\n顎：バランス良好',
              suggestion: '鼻尖形成またはヒアルロン酸注入で自然な立体感を強調可能',
            ),
            const SizedBox(height: 20),

            const Text(
              'AIからの総合提案',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                '全体的にバランスが良いですが、肌の保湿と目元の印象改善で若々しさがより引き立ちます。\n'
                'AI推奨プラン：スキンケア＋埋没法（自然型）＋ヒアルロン酸（目元）',
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text('再スキャン'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // TODO: 結果保存（Go API連携）
                    },
                    icon: const Icon(Icons.save_alt_outlined),
                    label: const Text('結果を保存'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: PythonのAI再解析APIへPOST
                },
                icon: const Icon(Icons.psychology_alt_outlined),
                label: const Text('AIに再解析を依頼'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String result;
  final String suggestion;

  const _AnalysisCard({
    required this.icon,
    required this.label,
    required this.result,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(result, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  '💡 $suggestion',
                  style: TextStyle(
                      fontSize: 12, color: scheme.primary.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
