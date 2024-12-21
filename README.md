# Ruby 開発用 Dev Container

このリポジトリは、Visual Studio Code の Dev Containers 機能を利用した Ruby 開発環境を提供します。事前に設定された環境を使用することで、効率的に Ruby の開発を進めることができます。

---

## 特徴

- **Ruby 環境**: 指定されたバージョンの Ruby 開発環境を簡単に構築。
- **VS Code との統合**: Visual Studio Code の Dev Containers 機能に最適化され、シームレスな開発体験を提供。
- **依存関係管理**: Bundler を使用して Gem の依存関係を簡単に管理。

---

## 始め方

### 1. **リポジトリのクローン**

ターミナルで以下のコマンドを実行してください:

```bash
git clone https://github.com/tomohiroJin/devcontainer-ruby.git
cd devcontainer-ruby
```

### 2. **VS Code で開く**

- 最新版の [Visual Studio Code](https://code.visualstudio.com/) をインストールしてください。
- [Dev Containers 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)をインストールしてください。
- このリポジトリを VS Code で開き、`Dev Container` の再読み込みを求められたら承認します。

### 3. **アプリケーションの実行**

- アプリケーションの実行や Rake タスクの実行が可能です。
- 必要に応じてコンテナ内でスクリプトを実行してください。

---

## カスタマイズ

`.devcontainer/devcontainer.json` を編集することで、開発環境を自由にカスタマイズできます。例えば、Ruby のバージョンを変更する場合は、`Dockerfile` 内の `VARIANT` 引数を変更してください。

---

## ライセンス

このプロジェクトは MIT ライセンスの下で提供されています。詳細については [LICENSE](LICENSE) ファイルをご覧ください。

---

このリポジトリを活用することで、VS Code と Docker による再現性・移植性の高い Ruby 開発環境を手軽に構築できます。是非活用してみてください。