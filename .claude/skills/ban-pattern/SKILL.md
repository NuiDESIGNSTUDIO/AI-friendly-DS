---
name: ban-pattern
description: 人間からの「ここがダサい/NG」というデザイン指摘を rules.json に禁止パターンとして即時追記し、feedback-log.md に経緯を記録する。人間からデザイン修正のダメ出しを受けた直後に実行する。
user-invocable: false
---

# ban-pattern

WORKFLOW.md の Step4 で使う学習コマンド。人間からの指摘を一過性の修正で終わらせず、rules.json と feedback-log.md に昇格させる。

## 手順

1. **指摘の言語化**
   人間の指摘(例:「このシャドウ濃すぎ」「カラーバーはダサい」)から、対象となるTailwindクラス／パターン／実装方針、および代替案(何を使うべきか)を特定する。
   指摘が曖昧で対象パターンや代替案が一意に決まらない場合は、推測で進めず AskUserQuestion で具体例(該当箇所のコードやスクリーンショット)を確認する。

2. **rules.json への追記**
   `rules.json` の `rules` 配列に以下の形式でオブジェクトを追加する。既存ルールと重複しないか確認する(重複・類似があれば新規追加ではなく既存ルールの更新を検討し、人間に確認する)。
   ```json
   {
     "id": "kebab-case-の一意なID",
     "pattern": "正規表現 or クラス名",
     "type": "tailwind-class | tailwind-arbitrary | html-jsx-pattern | html-pattern",
     "reason": "なぜ禁止か(人間の指摘内容を要約)",
     "alternative": "代わりに何を使うべきか(具体的に)",
     "severity": "error | warning"
   }
   ```
   `alternative` は省略しない。ここが空だと `scripts/hook-check-rule.sh` が違反を検知してもAIが何に直せばよいか分からず、Step3の自己修正ループが機能しなくなる。

3. **feedback-log.md への記録**
   `feedback-log.md` の末尾に以下の形式で追記する。
   ```markdown
   ## YYYY-MM-DD
   - **指摘内容**: (人間からの指摘をそのまま/要約して記載)
   - **対象**: (画面/コンポーネント名)
   - **追加されたルール**: `rules.json` の `id`
   ```

4. **即時反映の確認**
   追記後、対象コードに同じ違反がないか `scripts/hook-check-rule.sh` 相当のチェック(grep)を自分で走らせ、他にも同様の違反が残っていないか確認する。

5. **結果を報告する**
   以下の形式で人間に報告する。
   ```
   ## 禁止パターン登録完了
   ルールID: [id]
   パターン: [禁止したパターン]
   代替: [代わりに使うべきもの]
   severity: [error | warning]
   更新ファイル: rules.json, feedback-log.md
   ```

## 注意
- 個別画面だけの一時的な好みは rules.json に昇格させず、feedback-log.md にのみ記録する(判断に迷う場合は人間に確認する)。
- 既存ルールと矛盾する指摘を受けた場合は、rules.json を上書きする前に人間に確認する。
