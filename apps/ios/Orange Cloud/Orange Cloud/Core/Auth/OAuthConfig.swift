//
//  OAuthConfig.swift
//  Orange Cloud
//
//  在 Cloudflare Dashboard 创建 OAuth Client 后，填入真实 clientID。
//  redirect_uri 必须与 Dashboard 中注册的完全一致。
//

import Foundation

nonisolated enum OAuthConfig {
    /// OneCFCloud OAuth Client（Cloudflare Dashboard → OAuth clients）。
    static let clientID = "5296ce169556ba6a1d84f00912afea92"

    /// 自定义 scheme，供 Worker 回调中转 302 跳回 App
    static let callbackScheme = "onecfcloud"

    // Cloudflare OAuth 只接受 https redirect_uri，指向 Worker 回调中转。
//    #if DEBUG
//    static let redirectURI = "http://localhost:3000/oauth/callback"
//    #else
    static let redirectURI = "https://onecfcloud-oauth-callback.jackie-xiao.workers.dev/oauth/callback"
//    #endif

    // Cloudflare OAuth 端点
    static let authorizationURL = URL(string: "https://dash.cloudflare.com/oauth2/auth")!
    static let tokenURL         = URL(string: "https://dash.cloudflare.com/oauth2/token")!
    static let revokeURL        = URL(string: "https://dash.cloudflare.com/oauth2/revoke")!
    static let userInfoURL      = URL(string: "https://dash.cloudflare.com/oauth2/userinfo")!
}
