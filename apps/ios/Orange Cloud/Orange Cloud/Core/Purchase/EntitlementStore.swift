//
//  EntitlementStore.swift
//  Orange Cloud
//
//  OneCFCloud TestFlight 自用构建不接入应用内购买。
//  原 Orange Cloud 的 Pro 状态对象保留为兼容壳，运行时始终全功能。
//

import Foundation

@Observable
@MainActor
final class EntitlementStore {

    static let shared = EntitlementStore()

    var isPro: Bool {
        true
    }

    /// OneCFCloud 不接入 IAP，启动时不做 StoreKit 监听或商品加载。
    func start() {
    }

    func loadProducts() async {
    }

    func restorePurchases() async {
    }
}
