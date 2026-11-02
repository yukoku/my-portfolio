# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

プロジェクト管理ツール（ポートフォリオ用 Rails アプリ）。Ruby 3.0.7 / Rails 7.0 / MySQL 5.7 / Sprockets（bootstrap-sass 3, jquery-rails, CoffeeScript）。本番は Heroku + S3（ActiveStorage）。UI・I18n のデフォルトロケールは `:ja`。

## 開発環境とコマンド

開発・テストは Docker Compose 前提。`config/database.yml` は `host: db`、`spec/rails_helper.rb` の JS 系システムテストは `http://chrome:4444/wd/hub`（Selenium コンテナ）を前提にしているため、ホスト上で直接 `rspec` を実行しても DB/ブラウザに接続できない。

```bash
docker compose build
docker compose up                                   # http://localhost:3000
docker compose run --rm web rails db:create db:schema:load db:seed
docker compose run --rm web bundle exec rspec       # 全テスト
docker compose run --rm web bundle exec rspec spec/models/ticket_spec.rb:42   # 単一テスト
docker compose run --rm web bundle exec rubocop
```

- seed で `admin@example.com / adminadmin`（admin）と `test_user@example.com / password` が作成される。
- 開発環境のメールは letter_opener_web（`/letter_opener`）で確認する。
- CI（`.github/workflows/ci.yml`）は docker-compose と同じサービス名（`db`, `chrome`）でコンテナを立てて `bundle exec rspec` を実行する。DB は `db:schema:load` で作成するので、マイグレーション追加時は `db/schema.rb` もコミットすること。
- RuboCop は `.rubocop_todo.yml` を継承しており、`config/`・`db/migrate/` などは対象外。

## アーキテクチャ

### ドメインモデル
- `User`（Devise: confirmable, invitable）。`admin` フラグを持ち、admin は全プロジェクト・全チケットにアクセス可能。
- `Project` ↔ `User` は `ProjectMember` 経由の多対多。`ProjectMember` は `owner` フラグ、`accepted_project_invitation`、`project_invitation_token`（MD5 ハッシュ化して保存）を持つ。プロジェクト作成者は `owner: true, accepted_project_invitation: true` のメンバーとして登録される。
- `Ticket` は `creator` / `assignee`（どちらも `User`、optional）を持つ。`User` 削除時は `before_destroy` でチケットの `creator_id`/`assignee_id` を nil にする。
- チケットの「種別・ステータス・優先度」はカラムではなく EAV 構造：`TicketMetadata`（プロジェクトごとの項目定義、`Project` の `after_create` でデフォルト 3 項目を I18n 文字列から生成）と `TicketMetadataValue`（チケットごとの値、`accepts_nested_attributes_for`）。`TicketsController#new/edit` で未作成の metadata 分の value を build してフォームに渡す。
- 添付ファイルは `Ticket has_many_attached :attached_files`。モデル側で 1 ファイル 512KB 以下・最大 10 ファイルのバリデーション。未添付 blob の削除は `lib/tasks/scheduler.rake`（Heroku Scheduler 用）。

### 認可
認可ライブラリは使っておらず、各コントローラの `before_action` で個別にチェックしている（`ApplicationController` で全体に `authenticate_user!`）。
- プロジェクトメンバーまたは admin のみ: tickets / comments / projects#show など
- オーナーまたは admin のみ: project_members の new/create/destroy
- 同じ判定がビュー（`projects/show`, `projects/index`）にも重複して書かれているので、認可条件を変える場合は両方を修正する。

### 招待フローは 2 種類ある
1. **サービスへのユーザー招待**: devise_invitable（`Users::InvitationsController`, `/users/invitation`）。
2. **既存ユーザーのプロジェクト招待**: 独自実装。`ProjectMembersController#create` が生トークンを生成し、ハッシュを `ProjectMember` に保存、`ProjectInvitationMailer` で `deliver_later` 送信。受諾は `edit/update` で、トークン一致・本人確認・未受諾を `before_action` で検証する。

### その他の慣習
- flash メッセージやページサイズは `config/initializers/constants.rb` の `Constants` モジュール（I18n キーのプレフィックス、`PER = 5`）を参照する。ユーザー向け文言は `config/locales/myapp.{ja,en}.yml` に追加する。
- 検索は ransack 4。検索対象を増やす場合は `Ticket.ransackable_attributes` / `ransackable_associations` の許可リストに追加が必要。
- パンくずは gretel（`config/breadcrumbs.rb`）、ページネーションは kaminari。

## テスト
- RSpec のみ（`spec/models`, `spec/requests`, `spec/system`）。FactoryBot、shoulda-matchers、DatabaseRewinder（transactional fixtures は無効）。
- system spec はデフォルト `rack_test`、`js: true` のときのみリモート Selenium Chrome を使用。
- request spec では `spec/support/request_spec_helper.rb` の Warden ベースの `sign_in` を使う。