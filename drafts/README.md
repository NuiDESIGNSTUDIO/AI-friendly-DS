# drafts/ — 作成中タスクの作業場所

fix前(検討中)のデザイン作業はすべてここに置く。`mock/` には fix 後の最終稿のみ反映するため、検討中のファイルを直接 `mock/` に置かない。

## 配置ルール

タスクごとにサブディレクトリを切る。命名は `YYYY-MM-DD_タスク概要`(feedback-log.mdの日付形式と揃える)。

```
drafts/
└── 2026-08-11_user-list-bulk-export/
    ├── a.html          (Step1 A案の実装検討)
    ├── b.html          (Step1 B案)
    ├── c.html          (Step1 C案)
    └── working.html    (Step5で反復修正中のファイル。最終的にmock/へコピーされる)
```

## fix後の扱い

- `working.html`(または採用案)の最終稿を `mock/` の対応パスへコピー/上書きする。
- `drafts/`配下のファイルは**削除せず残す**。3案の検討履歴として、後から「なぜこの方向にしたか」を辿れるようにするため(feedback-log.mdと合わせて参照する)。
