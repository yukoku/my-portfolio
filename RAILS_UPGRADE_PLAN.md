# Rails 7 アップグレード実行計画

現在のRailsバージョン `6.1.3.1` から `7.0` 系へのアップグレード計画です。
Docker Compose 環境での実行を前提としています。

---

### **フェーズ1: 準備**

1.  **ブランチの作成:**
    *   アップグレード作業用に新しいGitブランチを作成します。
    *   ```bash
      git switch -c feature/upgrade-rails-7
      ```

2.  **現在のテストスイートの確認:**
    *   現在のブランチで全てのテストがパスすることを必ず確認します。これにより、アップグレード作業による問題を特定しやすくなります。
    *   ```bash
      docker-compose run --rm web rails test
      ```

---

### **フェーズ2: Rails本体のアップグレード**

1.  **`Gemfile`の更新:**
    *   `Gemfile`内の`rails`のバージョンを`~> 7.0.8`のように、7.0系の最新安定版に更新します。（7.1系へのアップグレードは、まず7.0系で安定させてから段階的に行うことを推奨します）

2.  **依存関係の更新:**
    *   コンテナ内で`bundle update`を実行し、Railsと関連Gemを更新します。
    *   ```bash
      docker-compose run --rm web bundle update rails
      ```
    *   このコマンドの出力で、他のGemとの間に互換性の問題が発生していないか確認します。問題がある場合は、該当するGemのバージョンアップや代替を検討する必要があります。

---

### **フェーズ3: 設定ファイルの更新**

1.  **`app:update`タスクの実行:**
    *   Rails 7用の新しい設定ファイルを生成し、既存のファイルとの差分を確認します。
    *   ```bash
      docker-compose run --rm web rails app:update
      ```
    *   このコマンドを実行すると、上書きするかどうかの確認（`Y/n/d/a`）が求められます。`d`を選択して差分を確認し、必要なカスタマイズ（`config/application.rb` や `config/environments/*.rb` など）を慎重に新しいファイルへ反映させます。

2.  **アセットパイプラインの確認:**
    *   Rails 7では、JavaScriptの管理方法として`importmap-rails`がデフォルトになりました。現在の`sprockets`（`bootstrap-sass`, `jquery-rails`）ベースの構成から移行するか、`sprockets-rails`を引き続き利用するかを決定する必要があります。これはアップグレードにおける最も大きな変更点の一つです。

---

### **フェーズ4: 確認とテスト**

1.  **Dockerイメージの再ビルド:**
    *   `Gemfile.lock`の変更を反映させるため、Dockerイメージを再ビルドします。
    *   ```bash
      docker-compose build
      ```

2.  **動作確認とテスト実行:**
    *   `docker-compose up`でサーバーを起動し、基本的な画面が正しく表示されるか確認します。
    *   再度テストスイートを実行し、失敗するテストを特定します。
    *   ```bash
      docker-compose run --rm web rails test
      ```
