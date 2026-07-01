# OneCFCloud 自用构建说明

OneCFCloud 是基于 [Orange Cloud](https://github.com/chen2he/orange-cloud) 改造的个人自用版本。原项目是一款 Apple 平台上的原生 Cloudflare 客户端。

这个仓库保留了上游项目历史、授权文件和来源声明，同时把 iOS 构建改成可以使用我自己的 Apple Developer 账号和 Cloudflare OAuth Client 签名、安装、授权和使用。

## 这次改了什么

- 将面向用户的 App 名称改为 `OneCFCloud`。
- 将 bundle identifier、App Group、Keychain access group、后台任务标识和签名配置切换到 `com.01mvp.onecfcloud` 命名空间。
- 将上游官方 OAuth Client 和 `o-c.do` 回调中转替换为自建 Cloudflare OAuth Client 和自建 Worker 回调中转。
- 新增 `apps/onecfcloud-oauth-worker/`，用于把 Cloudflare 的 HTTPS OAuth callback 转回 App URL scheme：
  - HTTPS callback: `https://onecfcloud-oauth-callback.jackie-xiao.workers.dev/oauth/callback`
  - App callback: `onecfcloud://oauth/callback`
- 启用自编译 Pro 解锁路径，并移除这个个人构建里的订阅 / Paywall 路径。
- 将首次授权默认权限改为只勾选必要的只读 scopes；需要额外功能时仍可继续手动选择更多 scopes。
- 新增 `apps/ios/ExportOptions-TestFlightInternal.plist`，用于上传 internal TestFlight。
- 改进 OAuth callback 错误展示：Cloudflare 返回 `error_description` 时，App 会显示更完整的错误，而不是只显示 `invalid_scope` 这类短错误码。

## 当前用途

当前这个 fork 只用于个人 internal TestFlight 自用。

在这个模式下，Cloudflare OAuth Client 可以保持 `Private`。Private Client 只允许所属 Cloudflare Account 里的成员授权；对个人自用来说，这刚好够用。

如果以后要通过 external TestFlight 或 public TestFlight 给更多人使用，建议先做这些收口：

- 等域名验证、logo、client URL、隐私链接等元信息准备好后，再考虑把 Cloudflare OAuth Client 提升为 `Public`；
- 不要默认请求大量 read/write scopes，应按功能最小化请求；
- 公开分发对应的完整源码；
- 保持 `OneCFCloud` 自己的名称和图标，不使用 Orange Cloud 的名称、图标或 App Store 身份；
- 保留 Orange Cloud 来源声明和上游授权文件。

## Cloudflare OAuth 方案

Cloudflare OAuth 只接受 HTTPS redirect URI，所以这里用一个很小的 Cloudflare Worker 做回调中转。

流程是：

1. iOS App 用 PKCE 打开 Cloudflare 授权页。
2. Cloudflare 授权完成后跳转到 Worker 的 HTTPS callback。
3. Worker 把 `code`、`state` 或 OAuth error 字段原样带回 `onecfcloud://oauth/callback`。
4. App 在本机校验 `state`，再用 authorization code 换 token。

如果别人参考这个仓库自建，需要替换这些值：

- `OAuthConfig.clientID`
- `OAuthConfig.redirectURI`
- `OAuthConfig.callbackScheme`
- bundle identifiers 和 App Groups
- Keychain access group prefix / Apple Team ID
- Cloudflare Worker route 和 Cloudflare account

## Scope 经验

个人自用时，在 Cloudflare OAuth Client 里勾全 read scopes 最省事。

但如果面向外部用户，不建议这样做。更稳的方式是首次授权只请求最小权限，例如 account settings / zone read；当用户打开某个高级功能时，再提示补充授权对应 scopes。

这次遇到过一个具体坑：Cloudflare 有一些显示名非常相近的 Zero Trust scopes，例如 account 级 `access.read` 和 zone 级 `zone-access.read`。如果 App 请求的是 `access.read`，但 OAuth Client 只允许了 `zone-access.read`，授权会失败并显示 `invalid_scope`。

## 构建方式

打开 iOS 工程：

```sh
open "apps/ios/Orange Cloud/Orange Cloud.xcodeproj"
```

构建前确认：

- signing team 是自己的 Apple Developer team；
- bundle IDs 和 App Groups 已经在 Apple Developer / App Store Connect 里创建；
- 自编译构建的 active compilation conditions 里包含 `OPENSOURCE_UNLOCKED`；
- Cloudflare OAuth Client 的 redirect URI 和部署的 Worker 地址一致；
- App URL scheme 和 Worker 回跳的 scheme 一致。

本地编译检查可以用：

```sh
xcodebuild build \
  -project "apps/ios/Orange Cloud/Orange Cloud.xcodeproj" \
  -scheme "Orange Cloud" \
  -configuration Debug \
  -destination "generic/platform=iOS" \
  -allowProvisioningUpdates \
  -skipPackagePluginValidation \
  -skipMacroValidation
```

## 授权和来源

这个 fork 改造自 Orange Cloud。

Orange Cloud 使用 AGPL-3.0 + Commons Clause 授权。完整条款见 [LICENSE](LICENSE)、[TRADEMARK.md](TRADEMARK.md)、[CLA.md](CLA.md) 和上游仓库。

Orange Cloud 的名称、图标和 App Store 产品身份不授权给二开分发使用。OneCFCloud 使用自己的 App 名称和 bundle 命名空间。
