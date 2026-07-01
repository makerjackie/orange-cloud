//
//  AboutView.swift
//  Orange Cloud
//
//  「关于」二级页：版本、来源与测试用途。
//  设置根页只保留单个「关于」入口，避免根页堆积过多外链。
//

import SwiftUI

struct AboutView: View {

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    var body: some View {
        List {
            // ── App 头部 ──
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(Color.ocOrange)
                        .accessibilityHidden(true)
                    Text(verbatim: "OneCFCloud")
                        .font(.title2.bold())
                    Text(appVersion)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                    Text("第三方 Cloudflare 客户端")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }

            // ── 来源 ──
            Section {
                aboutLink("Orange Cloud", icon: "chevron.left.forwardslash.chevron.right", url: "https://github.com/chen2he/orange-cloud")
            } header: {
                Text("来源")
            } footer: {
                Text("OneCFCloud 基于开源项目 Orange Cloud 改造，仅用于个人 TestFlight 测试。")
            }
            .glassRow()

            // ── 构建说明 ──
            Section {
                Label("不接入应用内购买", systemImage: "cart.badge.minus")
                Label("自编译全功能测试构建", systemImage: "checkmark.seal")
            } footer: {
                Text("本构建通过 OPENSOURCE_UNLOCKED 启用完整功能；不提供公开商业发行。")
            }
            .glassRow()

            Section {
                Text("OneCFCloud · Modified from Orange Cloud")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.secondary)
            } footer: {
                Text("OneCFCloud · 第三方 Cloudflare 客户端")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
            }
            .glassRow()
        }
        .daybreakList()
        .navigationTitle("关于")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func aboutLink(_ title: String, icon: String, url: String) -> some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 12) {
                TintIcon(systemImage: icon, color: .gray)
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}
