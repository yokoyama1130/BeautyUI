import 'package:flutter/material.dart';

/// 施術シミュレーション画面
/// - 上：元の顔画像（またはダミー）
/// - 中：施術プリセット（埋没 / 全切開 / 鼻ヒアル / 糸リフト など）
/// - 下：選択施術後のイメージ＋説明
/// - ＋「何年後の顔」パラメータ付き
class TreatmentSimulationPage extends StatefulWidget {
  final String? imagePath;

  const TreatmentSimulationPage({super.key, this.imagePath});

  @override
  State<TreatmentSimulationPage> createState() =>
      _TreatmentSimulationPageState();
}

class _TreatmentSimulationPageState extends State<TreatmentSimulationPage> {
  int _selectedIndex = 0;

  // 何年後を見るかの候補
  final List<int> _yearsOptions = [0, 1, 5, 10];
  int _selectedYearsIndex = 0; // 0=現在, 1=1年後, ...

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
      name: '目頭切開',
      tag: 'ダウンタイム：5〜7日 / 費用：中〜高',
      effect:
          '・目と目の間の距離を調整し、目頭側の丸みを整える\n・目の横幅だけでなく、目力の印象をアップ',
      note: '「離れ目が気になる」「もう少し目を大きく見せたい」方に向いています。',
    ),
    _TreatmentOption(
      name: '鼻ヒアルロン酸注入',
      tag: 'ダウンタイム：1〜3日 / 費用：低〜中',
      effect:
          '・鼻筋を通して横顔のバランスを整える\n・メスを使わずに立体感をプラス',
      note: 'まずはプチ整形で変化を試したい方に向いています。',
    ),
    _TreatmentOption(
      name: 'ほうれい線ヒアルロン酸',
      tag: 'ダウンタイム：1〜3日 / 費用：中',
      effect:
          '・ほうれい線の溝をふっくらさせ、影をやわらげる\n・疲れて見える・老けて見える印象を軽減',
      note: 'マスクを外したときの印象を若々しく整えたい方に適しています。',
    ),
    _TreatmentOption(
      name: '糸リフト（フェイスライン）',
      tag: 'ダウンタイム：2〜5日 / 費用：中〜高',
      effect:
          '・フェイスラインのたるみを引き上げ、輪郭をシャープに\n・口元やほうれい線の影を軽減',
      note: '「なんとなく疲れて見える」印象を改善したい方に適しています。',
    ),
    _TreatmentOption(
      name: 'エラボトックス（小顔）',
      tag: 'ダウンタイム：ほぼなし / 費用：低〜中',
      effect:
          '・エラ部分の筋肉（咬筋）のボリュームを少しずつ軽減\n・横顔・正面の輪郭をほっそりと見せる',
      note: 'メスを使わずにフェイスラインをすっきりさせたい方に向いています。',
    ),
    _TreatmentOption(
      name: '顎下脂肪吸引',
      tag: 'ダウンタイム：7〜10日 / 費用：高',
      effect:
          '・二重あごのボリュームを減らし、首との境目をはっきりさせる\n・横顔のラインをシャープに整える',
      note: 'ダイエットをしても顎下だけが残りやすい方に適した施術です。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = _options[_selectedIndex];
    final years = _yearsOptions[_selectedYearsIndex];

    String yearsLabel;
    if (years == 0) {
      yearsLabel = '現在';
    } else {
      yearsLabel = '$years年後';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('施術シミュレーション'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
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
                            '$yearsLabel × ${selected.name}\n術後イメージ（ダミー）',
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

            // 中央：施術候補チップ
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

            const SizedBox(height: 8),

            // 中央：何年後を見るかのチップ
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(_yearsOptions.length, (index) {
                  final y = _yearsOptions[index];
                  final selectedFlag = _selectedYearsIndex == index;
                  final label = y == 0 ? '現在' : '$y年後';
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        label,
                        style: const TextStyle(fontSize: 12),
                      ),
                      selected: selectedFlag,
                      onSelected: (_) {
                        setState(() {
                          _selectedYearsIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 12),

            // 下部：詳細説明＆カウンセリング向けコメント
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$yearsLabelの${selected.name}',
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
                      '加齢による見た目の変化イメージ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      years == 0
                          ? '現在時点での見た目に対する施術後イメージです。'
                          : '$years年後を想定した肌のハリ・輪郭の変化を加味した上での、施術後イメージです。（※実際の経過には個人差があります）',
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
                          // TODO:
                          // ここで Go / Python API に
                          // - treatment: selected.name
                          // - years_offset: years
                          // を送って「◯年後×施術後」の画像生成リクエストを投げる想定
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('この施術プランを候補に追加'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
