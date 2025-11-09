import 'package:flutter/material.dart';
import 'scan_result_page.dart';

/// 美容外科カウンセラー向け「顔スキャン」ホームUI
/// - 上部：顔プレビュー枠（ダミー）
/// - 中央：ガイドテキスト
/// - 下部：ボタン群（ライブ撮影 / アルバム / カウンセリング開始）
class ScanHomePage extends StatelessWidget {
  const ScanHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Expanded(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  // 顔ガイド（単純な枠線）
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: scheme.primary.withValues(alpha: 0.9),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.face_retouching_natural,
                          size: 56,
                          color: scheme.primary,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '顔全体が枠内に入るように\n患者さんの位置を調整してください',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '※ この画面ではまだカメラ連携はしていません。\n   あとでGo/Python側のAPIとつなぎこみ予定。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          // TODO: 将来カメラ起動を実装
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('ライブ撮影'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: 将来ギャラリーから読み込みを実装
                        },
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('アルバムから'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // ★ スキャン結果画面へ遷移（現状はダミー遷移）
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ScanResultPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('カウンセリングを開始'),
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
        ],
      ),
    );
  }
}
