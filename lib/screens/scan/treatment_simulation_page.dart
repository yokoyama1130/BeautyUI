import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// 施術シミュレーション画面
/// - 上：カテゴリTab → 直下に施術チップ
/// - 中：顔画像（ダミー or 渡された画像）→ 年数チップ
/// - 下：説明 + Go→Python API結果表示
class TreatmentSimulationPage extends StatefulWidget {
  final String? imagePath;

  const TreatmentSimulationPage({super.key, this.imagePath});

  @override
  State<TreatmentSimulationPage> createState() =>
      _TreatmentSimulationPageState();
}

class _TreatmentSimulationPageState extends State<TreatmentSimulationPage>
    with SingleTickerProviderStateMixin {
  // ===== 年数候補 =====
  final List<int> _yearsOptions = [0, 1, 5, 10];
  int _selectedYearsIndex = 0; // 0=現在

  // ===== カテゴリ & オプション定義 =====
  late final List<String> _categories = const [
    '二重',
    '鼻',
    '糸リフト',
    '脂肪吸引',
    'ヒアルロン酸',
    '小皺',
  ];

  late final Map<String, List<_TreatmentOption>> _optionsByCategory = {
    '二重': const [
      _TreatmentOption(
        name: '2点留め',
        tag: 'ダウンタイム：短め / 費用：低〜中',
        effect: '・自然な二重ライン形成\n・ダウンタイムを抑えて様子見したい方向け',
        note: '初めての埋没に。戻りやすさは個人差あり。',
      ),
      _TreatmentOption(
        name: '4点留め',
        tag: 'ダウンタイム：中 / 費用：中',
        effect: '・ラインの安定性アップ\n・左右差の改善に寄与',
        note: '自然さと安定性のバランスが良い。',
      ),
      _TreatmentOption(
        name: '6点留め',
        tag: 'ダウンタイム：やや長め / 費用：中〜高',
        effect: '・しっかりめのライン維持\n・厚めのまぶたにも対応しやすい',
        note: '長期的なライン保持を重視したい方向け。',
      ),
      _TreatmentOption(
        name: '全切開',
        tag: 'ダウンタイム：7〜14日 / 費用：高',
        effect: '・戻りづらく、くっきりライン\n・皮膚/脂肪の調整も可能',
        note: '長期維持と明瞭なラインを希望の方へ。',
      ),
      _TreatmentOption(
        name: '目頭切開',
        tag: 'ダウンタイム：5〜7日 / 費用：中〜高',
        effect: '・目頭側の丸み改善\n・目の横幅・目力の印象アップ',
        note: '離れ目が気になる方に。',
      ),
      _TreatmentOption(
        name: '目尻切開',
        tag: 'ダウンタイム：5〜7日 / 費用：中〜高',
        effect: '・目の横幅を後方に拡張\n・優しい印象の拡張',
        note: '目尻側の狭さが気になる方に。',
      ),
      _TreatmentOption(
        name: 'グラマラス埋没',
        tag: 'ダウンタイム：中 / 費用：中',
        effect: '・丸みとボリュームを強調\n・華やかな目元へ',
        note: '派手すぎない範囲での印象チェンジに最適。',
      ),
    ],
    '鼻': const [
      _TreatmentOption(
        name: 'プロテーゼ(鼻筋)',
        tag: 'DT：7日〜 / 費用：高',
        effect: '・鼻筋を通し立体的に\n・横顔バランス改善',
        note: '持続性重視。入替や修正の可能性は説明要。',
      ),
      _TreatmentOption(
        name: 'メッシュ(鼻筋)',
        tag: 'DT：短め / 費用：中',
        effect: '・比較的低侵襲で鼻筋形成\n・自然な立体感',
        note: 'ダウンタイムを抑えて高さを調整したい方に。',
      ),
      _TreatmentOption(
        name: '鼻尖形成(鼻先)',
        tag: 'DT：1〜2週 / 費用：中〜高',
        effect: '・鼻先をシャープに\n・団子鼻の印象を軽減',
        note: '鼻先の形状に悩む方へ。',
      ),
      _TreatmentOption(
        name: '3D鼻尖(鼻先)',
        tag: 'DT：1〜2週 / 費用：高',
        effect: '・複合的な鼻先形成\n・立体的で洗練された印象',
        note: '高度なデザイン性を求める方向け。',
      ),
      _TreatmentOption(
        name: '鼻先尖鋭(鼻先)',
        tag: 'DT：1〜2週 / 費用：中〜高',
        effect: '・鼻先の尖鋭化\n・輪郭をキリッと',
        note: '鼻先の丸みを抑えたい方に。',
      ),
      _TreatmentOption(
        name: '小鼻縮小埋没(小鼻)',
        tag: 'DT：短め / 費用：中',
        effect: '・小鼻のボリュームを控えめに\n・外見上の傷を最小化',
        note: '傷跡を気にする方に配慮。',
      ),
      _TreatmentOption(
        name: '小鼻縮小内側切開(小鼻)',
        tag: 'DT：1週〜 / 費用：中〜高',
        effect: '・内側からボリューム調整\n・自然な縮小',
        note: '効果優先かつ傷跡を抑えたい方向け。',
      ),
      _TreatmentOption(
        name: '小鼻縮小外側切開(小鼻)',
        tag: 'DT：1週〜 / 費用：中〜高',
        effect: '・外側からしっかり縮小\n・効果実感が分かりやすい',
        note: 'より大きな縮小が必要なケースに。',
      ),
    ],
    '糸リフト': const [
      _TreatmentOption(
        name: '小顔美肌再生ストロング(半永久)',
        tag: 'DT：短め / 費用：高',
        effect: '・強い引き上げと長期維持\n・輪郭のたるみ改善',
        note: '維持力優先。適切な維持期間の説明が必要。',
      ),
      _TreatmentOption(
        name: '小顔美肌再生ソフト(約2〜3年)',
        tag: 'DT：短め / 費用：中〜高',
        effect: '・中〜長期の引き上げ\n・自然な仕上がり',
        note: 'コスパと自然さのバランスが良い。',
      ),
      _TreatmentOption(
        name: 'ルピナス(約半年〜1年)',
        tag: 'DT：短め / 費用：中',
        effect: '・短中期の引き上げ\n・手軽に試しやすい',
        note: '初回の糸リフト導入に向いています。',
      ),
    ],
    '脂肪吸引': const [
      _TreatmentOption(
        name: '頬下脂肪吸引注射',
        tag: 'DT：短め / 費用：中',
        effect: '・頬下のボリューム減少\n・フェイスラインを軽く',
        note: '注射ベースで手軽に試したい方向け。',
      ),
      _TreatmentOption(
        name: '顎下脂肪吸引注射',
        tag: 'DT：短め / 費用：中',
        effect: '・二重あご軽減\n・首との境目を明瞭化',
        note: '顎下のボリュームが気になる方に。',
      ),
      _TreatmentOption(
        name: '頬下脂肪吸引プレミアム',
        tag: 'DT：7〜10日 / 費用：高',
        effect: '・しっかり吸引で輪郭改善\n・持続実感が高い',
        note: '注射より強い効果を求める方へ。',
      ),
      _TreatmentOption(
        name: '顎下脂肪吸引プレミアム',
        tag: 'DT：7〜10日 / 費用：高',
        effect: '・顎下を集中的に吸引\n・横顔ラインをシャープに',
        note: '根本的な改善を希望の方に。',
      ),
      _TreatmentOption(
        name: 'ジョールファット',
        tag: 'DT：短〜中 / 費用：中〜高',
        effect: '・口角横の脂肪を調整\n・ほうれい線〜口元の影を軽減',
        note: 'もたつき印象が強い方に。',
      ),
      _TreatmentOption(
        name: 'メーラーファット',
        tag: 'DT：短〜中 / 費用：中〜高',
        effect: '・頬中央のボリューム調整\n・輪郭を軽やかに',
        note: '頬の重さが気になる方向け。',
      ),
      _TreatmentOption(
        name: 'バッカルファット',
        tag: 'DT：中 / 費用：高',
        effect: '・頬深部の脂肪除去\n・下顔面のスリム化',
        note: '丸顔/下膨れの改善にアプローチ。',
      ),
    ],
    'ヒアルロン酸': const [
      _TreatmentOption(name: '額', tag: 'DT：短め / 費用：中', effect: '・丸みと立体感', note: '前額部の凹凸補正に。'),
      _TreatmentOption(name: 'こめかみ', tag: 'DT：短め / 費用：中', effect: '・側頭部の凹み改善', note: 'やつれ印象の緩和。'),
      _TreatmentOption(name: '鼻根', tag: 'DT：短め / 費用：低〜中', effect: '・鼻根の高さ調整', note: '横顔のバランス改善。'),
      _TreatmentOption(name: '涙袋', tag: 'DT：短め / 費用：低〜中', effect: '・可愛らしい目元', note: '過量は不自然に注意。'),
      _TreatmentOption(name: '眼窩縁', tag: 'DT：短め / 費用：中', effect: '・目周りの影軽減', note: '疲れ顔の緩和。'),
      _TreatmentOption(name: 'ゴルゴライン', tag: 'DT：短め / 費用：中', effect: '・頬中央の影改善', note: '若々しい印象へ。'),
      _TreatmentOption(name: 'ドールチーク', tag: 'DT：短め / 費用：中', effect: '・丸みのある頬', note: '立体的で華やかに。'),
      _TreatmentOption(name: '頬', tag: 'DT：短め / 費用：中', effect: '・ボリューム補填', note: 'やせ見えを軽減。'),
      _TreatmentOption(name: '法令線', tag: 'DT：短め / 費用：中', effect: '・溝を浅く', note: '老け見えの代表部位に。'),
      _TreatmentOption(name: '唇', tag: 'DT：短め / 費用：低〜中', effect: '・ボリュームと輪郭', note: '上下バランスに配慮。'),
      _TreatmentOption(name: '顎', tag: 'DT：短め / 費用：中', effect: '・Eライン調整', note: '横顔の完成度UP。'),
    ],
    '小皺': const [
      _TreatmentOption(
        name: 'スネコス',
        tag: 'DT：ほぼなし / 費用：中',
        effect: '・肌質改善と小皺の緩和',
        note: 'コラーゲン産生促進を狙う注入系。',
      ),
      _TreatmentOption(
        name: 'ベビーコラーゲン',
        tag: 'DT：ほぼなし / 費用：中〜高',
        effect: '・目周りなどの細かい皺に',
        note: '自然な質感で馴染みやすい。',
      ),
      _TreatmentOption(
        name: 'リジュラン',
        tag: 'DT：短め / 費用：中〜高',
        effect: '・肌再生・弾力感アップ',
        note: '全体的な肌の若返りを狙う。',
      ),
    ],
  };

  // 現在のカテゴリと選択オプション
  late TabController _tabController;
  int _selectedCategoryIndex = 0;
  _TreatmentOption? _selectedOption; // nullなら各カテゴリ先頭を使用

  // ===== Go API 連携用状態 =====
  static const String _backendBaseUrl = 'http://127.0.0.1:8080';
  bool _isLoading = false;
  String? _apiSummary; // summaryJp
  String? _apiNote; // noteForUx
  String? _apiImageUrl;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        _selectedCategoryIndex = _tabController.index;
        _selectedOption = null; // カテゴリ切替時は先頭に戻す
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _TreatmentOption _currentOption() {
    final cat = _categories[_selectedCategoryIndex];
    final list = _optionsByCategory[cat]!;
    return _selectedOption ?? list.first; // 定義済み前提
  }

  Future<void> _callTreatmentSimulation() async {
    final selected = _currentOption();
    final years = _yearsOptions[_selectedYearsIndex];

    setState(() {
      _isLoading = true;
      _apiError = null;
      _apiSummary = null;
      _apiNote = null;
      _apiImageUrl = null;
    });

    try {
      final uri = Uri.parse('$_backendBaseUrl/treatment_simulations');

      final body = jsonEncode({
        'treatmentName': selected.name,
        'yearsOffset': years,
      });

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: body,
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final json = jsonDecode(resp.body) as Map<String, dynamic>;
        setState(() {
          _apiSummary = json['summaryJp'] as String?;
          _apiNote = json['noteForUx'] as String?;
          _apiImageUrl = json['imageUrl'] as String?;
        });
      } else {
        setState(() {
          _apiError = 'サーバーエラーが発生しました（${resp.statusCode}）';
        });
      }
    } catch (e) {
      setState(() {
        _apiError = 'API呼び出しに失敗しました：$e';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = _currentOption();
    final years = _yearsOptions[_selectedYearsIndex];
    final yearsLabel = years == 0 ? '現在' : '$years年後';

    return Scaffold(
      appBar: AppBar(
        title: const Text('施術シミュレーション'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ★ TabBar直下にカテゴリ内の施術チップを配置
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: _CategoryChips(
                  options: _optionsByCategory[_categories[_selectedCategoryIndex]]!,
                  selected: _selectedOption ?? selected,
                  onSelected: (opt) => setState(() => _selectedOption = opt),
                ),
              ),

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

              // 年数チップ
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
                        label: Text(label, style: const TextStyle(fontSize: 12)),
                        selected: selectedFlag,
                        onSelected: (_) => setState(() {
                          _selectedYearsIndex = index;
                        }),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 12),

              // 下部：詳細 + API結果
              Container(
                width: double.infinity,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // タイトル（例：現在の 2点留め）
                    Text(
                      '$yearsLabelの${selected.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // タグ
                    Text(
                      selected.tag,
                      style: TextStyle(fontSize: 12, color: scheme.secondary),
                    ),
                    const SizedBox(height: 12),

                    // 説明
                    const Text(
                      '期待できる変化',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(selected.effect, style: const TextStyle(fontSize: 13)),

                    const SizedBox(height: 12),
                    const Text(
                      '加齢による見た目の変化イメージ',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(selected.note, style: const TextStyle(fontSize: 13)),

                    const SizedBox(height: 24),

                    // Go → Python API 連携ボタン
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : _callTreatmentSimulation,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(_isLoading ? 'AIシミュレーション中…' : 'AIシミュレーションを実行（Go → Python）'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // API 結果表示
                    if (_apiError != null) ...[
                      Text(_apiError!, style: TextStyle(fontSize: 12, color: scheme.error)),
                    ] else if (_apiSummary != null || _apiNote != null || _apiImageUrl != null) ...[
                      const Text('AIシミュレーション結果', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      if (_apiImageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _apiImageUrl!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('画像を読み込めませんでした', style: TextStyle(fontSize: 12)),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      if (_apiSummary != null)
                        Text(_apiSummary!, style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      if (_apiNote != null)
                        Text(_apiNote!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ] else ...[
                      const Text(
                        '※ ボタンを押すと、選択中の施術 × 年数をもとに\n'
                        'Go → Python バックエンドでAIシミュレーションを行う想定です（今はダミー）。',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<_TreatmentOption> options;
  final _TreatmentOption? selected;
  final ValueChanged<_TreatmentOption> onSelected;

  const _CategoryChips({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected?.name == opt.name;
        return ChoiceChip(
          label: Text(opt.name, style: const TextStyle(fontSize: 12)),
          selected: isSelected,
          onSelected: (_) => onSelected(opt),
        );
      }).toList(),
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
