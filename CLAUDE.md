# CLAUDE.md — AIフレンドリーデザインシステム 地図

このリポジトリで UI/デザイン作業を行う前に、必ず以下の順で読み込むこと。

## 最初に読むもの
1. **[WORKFLOW.md](./WORKFLOW.md)** — 作業前に必読。STG確認→3案提案→出し戻し→実装→検品の手順を厳守する。
2. **[tokens.json](./tokens.json)** — 色・余白・角丸などのデザイン値のSSOT(Figma Variablesエクスポート)。値のハードコード禁止、必ず参照する。
3. **[rules.json](./rules.json)** — 禁止パターン集。実装前後で必ず照合する。
4. **[components.json](./components.json)** — Figma「01_UI kit」のコンポーネント一覧(node-id付き)。Storybookが無いため、これが正解コードの参照元。
5. **[icons.json](./icons.json)** — Figma「02_Icon」のアイコン一覧(node-id付き)。使用時はnode-idでSVGを取得する。

## 絶対遵守ルール
- WORKFLOW.md の Step1（3案提案）を飛ばして、いきなりコードを書かない。
- tokens.json にない色・余白の値を直書きしない。
- rules.json に列挙された禁止クラス/パターンを使用しない（`scripts/hook-check-rule.sh` が自動検知する）。
- コンポーネントを実装する際は、まず components.json でFigma node-idを確認し、Figma MCPの `get_design_context` で実際のデザインを参照してから実装する。
- 生成後は `skills/design-review` でセルフレビューし、人間からの指摘は `skills/ban-pattern` で rules.json に反映する。

## 主要ファイル
- コンポーネントカタログ: `components.json`(Figma「01_UI kit」の全コンポーネントとnode-id)
- アイコンカタログ: `icons.json`(Figma「02_Icon」の全アイコンとnode-id、`assets/icons/12px/`に実SVGサンプルあり)
- ASIS参照リポジトリ: `reference/sharewis-act/`（本番サイトのコードをローカルクローン、Git管理外。現行画面・コンポーネントの実装確認に使う）
- 検品スクリプト: `scripts/hook-check-rule.sh`
- 改善ログ: `feedback-log.md`
- Figma Design System: https://www.figma.com/design/3IHJOBCeBTUrU6EqMpjART/Sharewis-Design-System
