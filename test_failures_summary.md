# RSpec Test Failure Summary

`docker compose run web rspec` を実行した結果、108件中8件のテストが失敗しました。
失敗したテストの詳細は以下の通りです。

## 1. チケットのファイル添付数のバリデーションエラー

-   **テスト**: `Ticket with attached files validate with file count is valid with 10 attached files`
-   **原因**: 10個のファイルを添付した場合に、本来は成功するべきところがバリデーションエラーとなっています。ファイル数の上限チェックのロジック（`<=` or `<`）に問題がある可能性があります。

## 3. チケット更新時のファイルサイズ検証エラー

-   **テスト**: `Tickets PATCH #update with attached files over 512KB size file fails to update ticket for file size validation`
-   **原因**: 512KBを超えるファイルを添付してチケットを更新した際に、レスポンスボディに期待されるエラーメッセージが含まれていませんでした。バリデーション自体が機能していないか、エラーメッセージの表示に問題がある可能性があります。

## 4. チケット更新時のファイル数検証エラー

-   **テスト**: `Tickets PATCH #update with attached files too many files fails to update ticket for file count validation`
-   **原因**: 制限を超える数のファイルを添付してチケットを更新した際に、レスポンスボディに期待されるエラーメッセージが含まれていませんでした。上記と同様の問題が考えられます。

## 5. プロジェクトメンバー招待時のボタンクリックエラー

-   **テスト**: `InviteProjectMembers invite new member and confirm`
-   **原因**: システムテストにおいて、プロジェクトへの招待を承諾する画面の「参加する」ボタンが見つからない、または無効化されているためクリックできず、テストが失敗しています。

## 6. 不正なユーザーによる招待承諾時のエラーメッセージ不一致

-   **テスト**: `InviteProjectMembers invite new member then other user request to get edit_url with valid token`
-   **原因**: 招待された本人以外のユーザーが招待URLにアクセスした際に、期待されるエラーメッセージ「不正なユーザーです」が表示されていません。

## 7. 不正なトークンによる招待承諾時のエラーメッセージ不一致

-   **テスト**: `InviteProjectMembers invite new member then new member request request to get edit_url with invalid token`
-   **原因**: 不正な認証トークンで招待URLにアクセスした際に、期待されるエラーメッセージ「認証トークンが不正です」が表示されていません。

## 8. ユーザー新規登録後のメッセージ不一致

-   **テスト**: `SignUp sign up`
-   **原因**: ユーザーの新規登録後、画面に表示されるべき「アカウントを登録しました。」という文言が見つかりませんでした。代わりに「メールアドレスが確認できました。」と表示されており、期待するメッセージと異なっています。
