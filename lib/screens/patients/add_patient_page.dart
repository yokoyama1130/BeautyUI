import 'package:flutter/material.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '基本情報',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: '氏名',
                  hintText: '例）山田 花子',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'フリガナ',
                  hintText: '例）ヤマダ ハナコ',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: '生年月日',
                        hintText: '選択',
                        prefixIcon: Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      // TODO: 日付ピッカー
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 110,
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('女性'),
                        ),
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('男性'),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text('その他'),
                        ),
                      ],
                      onChanged: (_) {},
                      decoration: const InputDecoration(
                        labelText: '性別',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '電話番号',
                  hintText: '例）09012345678',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'メールアドレス（任意）',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'タグ・メモ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'タグ（例：リピーター／インフルエンサー／VIP など）',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: '特記事項・注意点（既往歴・アレルギー・こだわりポイント等）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Go/Python APIで患者マスタに保存
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ダミー保存：患者情報を登録しました')),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('患者情報を保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
