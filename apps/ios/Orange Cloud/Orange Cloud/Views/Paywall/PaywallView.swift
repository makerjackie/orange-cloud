//
//  PaywallView.swift
//  Orange Cloud
//
//  OneCFCloud 全功能说明页。
//  原 Orange Cloud 的付费墙入口保留为兼容壳，但本 TestFlight 构建不接入 IAP。
//

import SwiftUI

struct PaywallView: View {

    /// 触发场景；nil = 从设置页常驻入口打开
    var feature: ProFeature? = nil

    @Environment(EntitlementStore.self) private var entitlements
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header

                    if entitlements.isPro {
                        unlockedCard
                    }

                    featureList
                    buildFooter
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background { SkyBackground() }
            .navigationTitle("OneCFCloud Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("关闭")
                }
            }
        }
        .sensoryFeedback(.success, trigger: entitlements.isPro)
    }

    // MARK: - 头部

    private var header: some View {
        VStack(spacing: 8) {
            TintIcon(systemImage: feature?.systemImage ?? "sparkles", color: .ocOrange, size: 56)
                .padding(.top, 12)

            Text(feature?.headline ?? String(localized: "解锁多账号与全部专业功能"))
                .font(.title3.weight(.bold))
                .multilineTextAlignment(.center)

            if let feature {
                Text(feature.blurb)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - 已解锁

    private var unlockedCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 40))
                .foregroundStyle(Color.ocOrange)
                .oneShotBounceSymbolEffect()
            Text("Pro 已解锁")
                .font(.headline)
            Text("OneCFCloud 测试构建已启用完整功能。")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .glassIsland()
    }

    // MARK: - Pro 功能清单

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 12) {
            bulletRow("person.2",                      String(localized: "多账号快速切换"))
            bulletRow("externaldrive",                 String(localized: "存储管理（R2 / D1 / KV）"))
            bulletRow("text.alignleft",                String(localized: "Workers 实时日志 + Live Activity"))
            bulletRow("shield",                        String(localized: "WAF 规则启停"))
            bulletRow("arrow.triangle.2.circlepath",   String(localized: "Cloudflare Tunnel"))
            bulletRow("chart.xyaxis.line",             String(localized: "完整流量分析（7 / 30 天）"))
        }
        .padding(OCLayout.islandPadding + 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassIsland()
    }

    private func bulletRow(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.ocOrange)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }

    // MARK: - 构建说明

    private var buildFooter: some View {
        VStack(spacing: 8) {
            Text("OneCFCloud 是基于开源项目 Orange Cloud 改造的个人 TestFlight 构建。")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            Text("本版本通过 OPENSOURCE_UNLOCKED 启用完整功能，不提供应用内购买。")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }
}

#Preview {
    PaywallView(feature: .storage)
        .environment(EntitlementStore.shared)
}
