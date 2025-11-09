import 'package:flutter/material.dart';

/// 施術シミュレーション画面
/// - 上：元の顔画像（またはダミー）
/// - 中：施術プリセット（埋没 / 全切開 / 鼻ヒアル / 糸リフト など）
/// - 下：選択施術後のイメージ＋説明（今はテキストベースのモック）
class TreatmentSimulationPage extends StatefulWidget {
  final String? imagePath;

  const TreatmentSimulationPage({super.key, this.imagePath});

  @override
  State<TreatmentSimulationPage> createState() =>
      _TreatmentSimulationPageState();
}

class _TreatmentSimulationPageState extends State<TreatmentSimulationPage> {
  int _selectedIndex = 0;

  final List<_TreatmentOption> _options = const [
    _TreatmentOption(
      name: 'ナチュラル二重（埋没）',
      tag: 'ダウンタイム：3〜5日 / 費用：中',
      effect:
          '・まぶたの重さを軽減し、自然な二重ラインを形成\n・左右差を軽減して、目の開きを良くする',
      note: '派手すぎない印象で、初めての二重整形に向いています。',
    ),
    _TreatmentOption(
      name: '二重全切開',
      tag: 'ダウンタイム：7〜14日 / 費用：高',
      effect:
          '・ラインの戻りがほぼなく、くっきりした二重を形成\n・皮膚・脂肪を調整することで、目元のもたつきを改善',
      note: 'しっかりとした二重を長期的に維持したい方に向いています。',
    ),
    _TreatmentOption(
      name: '鼻ヒアルロン酸注入',
      tag: 'ダウンタイム：1〜3日 / 費用：低〜中',
      effect:
          '・鼻筋を通して横顔のバランスを整える\n・メスを使わずに立体感をプラス',
      note: 'まずはプチ整形で変化を試したい方に向いています。',
    ),
    _TreatmentOption(
      name: '糸リフト（フェイスライン）',
      tag: 'ダウンタイム：2〜5日 / 費用：中〜高',
      effect:
          '・フェイスラインのたるみを引き上げ、輪郭をシャープに\n・口元やほうれい線の影を軽減',
      note: '「なんとなく疲れて見える」印象を改善したい方に適しています。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = _options[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('施術シミュレーション'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 上部：顔画像＋「術後イメージ」オーバーレイ
          Padding(
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      image: widget.imagePath != null
                          ? DecorationImage(
                              image: AssetImage(widget.imagePath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: widget.imagePath == null
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),
                  // 半透明の術後イメージレイヤー（今はテキストのみ）
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withValues(alpha: 0.18),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '${selected.name}\n術後イメージ（ダミー）',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 中央：施術候補のチップ
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(_options.length, (index) {
                final opt = _options[index];
                final selectedFlag = _selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      opt.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    selected: selectedFlag,
                    onSelected: (_) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 12),

          // 下部：詳細説明＆カウンセリング向けコメント
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              // ★ ここをスクロール可能にする
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selected.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected.tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '期待できる変化',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected.effect,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'カウンセリング時の伝え方ヒント',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selected.note,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          // TODO: この施術プランを患者カルテに一時保存（Go API連携）
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('この施術プランを候補に追加'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentOption {
  final String name;
  final String tag;
  final String effect;
  final String note;

  const _TreatmentOption({
    required this.name,
    required this.tag,
    required this.effect,
    required this.note,
  });
}
