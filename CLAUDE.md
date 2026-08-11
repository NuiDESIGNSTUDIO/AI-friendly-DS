# CLAUDE.md — AIフレンドリーデザインシステム 地図

このリポジトリで UI/デザイン作業を行う前に、必ず以下の順で読み込むこと。対象は既存画面の改修・エンハンス。前例のない新規UIパターンの発明は不得意な領域なので、その場合は先に人間に相談する。

## 最初に読むもの
1. **[WORKFLOW.md](./WORKFLOW.md)** — 作業前に必読。現行確認→3案提案→出し戻し→実装→ブラウザプレビューで反復修正(3〜4往復目安)→mockへ反映、の手順を厳守する。
2. **[tokens.json](./tokens.json)** — 色・余白・角丸などのデザイン値のSSOT(Figma Variablesエクスポート)。値のハードコード禁止、必ず参照する。
3. **[rules.json](./rules.json)** — 禁止パターン集。実装前後で必ず照合する。
4. **[components.json](./components.json)** — Figma「01_UI kit」のコンポーネント一覧(node-id付き)。Storybookが無いため、これが正解コードの参照元。
5. **[icons.json](./icons.json)** — Figma「02_Icon」のアイコン一覧(node-id付き)。使用時はnode-idでSVGを取得する。
6. **[screens.json](./screens.json)** — 人間デザイナー作成の参考画面カタログ(node-id付き)。近い役割の画面があれば構成・レイアウトの参考にする。

## 絶対遵守ルール
- WORKFLOW.md の Step1（3案提案）を飛ばして、いきなりコードを書かない。
- tokens.json にない色・余白の値を直書きしない。
- rules.json に列挙された禁止クラス/パターンを使用しない（`scripts/hook-check-rule.sh` が自動検知する）。
- コンポーネントを実装する際は、まず components.json でFigma node-idを確認し、Figma MCPの `get_design_context` で実際のデザインを参照してから実装する。
- 生成後は `design-review` スキルでセルフレビューし、人間からの指摘は `ban-pattern` スキルで rules.json に反映する(いずれも `.claude/skills/` に登録済み、AI専用でuser-invocable: false)。
- fix前のファイルは `drafts/` に置き、`mock/` には触れない。fixした最終稿だけを `mock/` に反映する。`reference/sharewis-act`(実装リポジトリ)への書き込み・コミットは行わない(人間の作業範囲)。

## 主要ファイル
- コンポーネントカタログ: `components.json`(Figma「01_UI kit」の全コンポーネントとnode-id)
- アイコンカタログ: `icons.json`(Figma「02_Icon」の全アイコンとnode-id、`assets/icons/12px/`に実SVGサンプルあり)
- 参考画面カタログ: `screens.json`(人間デザイナー作成の参考画面。`assets/reference-screens/`に代表フレームのスクリーンショットあり)
- サイト全体モック: `mock/`(fix済みデザインのみ。実装と差分のない最新状態を保つ。詳細は `mock/README.md`)
- 作業中フォルダ: `drafts/`(fix前の検討中ファイル。詳細は `drafts/README.md`)
- ASIS参照リポジトリ: `reference/sharewis-act/`（本番サイトのコードをローカルクローン、Git管理外。現行画面・コンポーネントの実装確認に使う）
- 検品スクリプト: `scripts/hook-check-rule.sh`
- 改善ログ: `feedback-log.md`
- Figma Design System: https://www.figma.com/design/3IHJOBCeBTUrU6EqMpjART/Sharewis-Design-System
