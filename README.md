# Devcontainer Ruby Reference

このリポジトリは、Ruby の開発環境を提供し、基本構文から制御構文、クラスの書き方、関数型プログラミングまで幅広い学習をサポートします。RuboCop によるコードスタイルチェックや Rspec を用いたテスト駆動開発を簡単に実行できる設定が含まれています。

---

## **目次**

1. [セットアップ](#セットアップ)
2. [Rspec の使い方](#rspec-の使い方)
3. [RDoc の生成](#rdoc-の生成)
4. [Reference 一覧](#reference-一覧)
5. [RuboCop の利用方法](#rubocop-の利用方法)

---

## **セットアップ**

### **必要なツール**

- Docker
- Visual Studio Code
  - Dev Containers 拡張機能

### **環境構築**

1. リポジトリをクローンします。

   ```bash
   git clone https://github.com/tomohiroJin/devcontainer-ruby.git
   cd devcontainer-ruby
   ```

2. VS Code でプロジェクトを開きます。
3. `Dev Containers` 拡張機能を使ってコンテナ内で開発環境を起動します。

---

## **Rspec の使い方**

このプロジェクトでは Rspec を使用してテストを実行します。

### **テストの実行**

1. 全テストを実行:

   ```bash
   rspec
   ```

2. 特定のテストファイルを実行:

   ```bash
   rspec spec/reference/loops_spec.rb
   ```

3. 特定の行番号のテストを実行:

   ```bash
   rspec spec/reference/loops_spec.rb:10
   ```

4. テスト結果を詳細に表示:

   ```bash
   rspec --format documentation
   ```

---

## **RDoc の生成**

RDoc を使用して、このプロジェクトのコードベースから HTML ドキュメントを生成します。

### **手順**

1. RDoc のセットアップ:
   `Gemfile` に以下を追加済みです。

   ```ruby
   gem 'rdoc'
   ```

   必要に応じて以下を実行してください。

   ```bash
   bundle install
   ```

2. ドキュメントの生成:

   ```bash
   bundle exec rdoc
   ```

3. 生成されたドキュメントの確認:
   `doc/index.html` をブラウザで開いてください。

---

## **Reference 一覧**

以下は、このリポジトリで提供している Ruby の学習リファレンスの一覧です。詳細はリンク先の RDoc を参照してください。

| 機能          | 概要                                       | 詳細 |
|---------------|------------------------------------------|------|
| 基本構文       | 変数、配列、ハッシュの基本操作を学ぶ         | [詳細](doc/Reference/BasicsSyntax.html) |
| 制御構文       | if-else、case 文、三項演算子の使い方         | [詳細](doc/Reference/ControlFlow.html) |
| ループ文       | while、until、each、times の使い方          | [詳細](doc/Reference/Loops.html) |
| クラスの書き方  | 継承、抽象化、ポリモーフィズムの例           | [詳細](doc/Reference/Shape.html) |
| 関数型         | 高階関数、ラムダ、イミュータブルデータ操作の例 | [詳細](doc/Reference/Functional.html) |

---

## **RuboCop の利用方法**

このプロジェクトでは RuboCop を使用してコードの品質を保ちます。

### **コードスタイルチェック**

```bash
rubocop
```

### **自動修正**

```bash
rubocop --auto-correct
```

### **特定ファイルをチェック**

```bash
rubocop path/to/file.rb
```

---

## **ライセンス**

このリポジトリは MIT ライセンスの下で提供されています。
