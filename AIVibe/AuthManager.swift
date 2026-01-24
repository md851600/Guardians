//
//  AuthManager.swift
//  AIVibe
//
//  认证管理器 - 处理注册、登录、找回密码流程
//  认证模式：
//  - 注册：发验证码 → 验证（已登录但无密码）→ 强制设置密码 → 完成
//  - 登录：邮箱 + 密码（直接登录）
//  - 找回密码：发验证码 → 验证（已登录）→ 设置新密码 → 完成
//  1/18/2026 Sunday from home; 8 errors fixed by adding imports

import Foundation
import SwiftUI
import Combine
import Auth
import Supabase
// 使用 SupabaseTestView.swift 中定义的全局 supabase 客户端
import GoogleSignIn
// Ethanyang999; add dependencies quided by Claude
@MainActor
class AuthManager: ObservableObject {

    // MARK: - 单例
    static let shared = AuthManager()

    // MARK: - 发布属性

    /// 已登录且完成所有流程（注册流程需要设置密码后才为 true）
    @Published var isAuthenticated: Bool = false

    /// OTP 验证后需要设置密码（注册/找回密码流程中）
    @Published var needsPasswordSetup: Bool = false

    /// 当前用户
    @Published var currentUser: User? = nil

    /// 加载状态
    @Published var isLoading: Bool = false

    /// 错误信息
    @Published var errorMessage: String? = nil

    /// 验证码已发送
    @Published var otpSent: Bool = false

    /// 验证码已验证，等待设置密码
    @Published var otpVerified: Bool = false

    // MARK: - 初始化

    private init() {
        // 启动时检查现有会话
        Task {
            await checkSession()
        }
    }

    // MARK: - 注册流程

    /// 发送注册验证码
    /// - Parameter email: 用户邮箱
    func sendRegisterOTP(email: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // shouldCreateUser: true 表示如果用户不存在则创建
            try await supabase.auth.signInWithOTP(
                email: email,
                shouldCreateUser: true
            )

            otpSent = true
            print("[AuthManager] 注册验证码已发送至: \(email)")

        } catch {
            errorMessage = "发送验证码失败: \(error.localizedDescription)"
            print("[AuthManager] 发送注册验证码失败: \(error)")
        }

        isLoading = false
    }

    /// 验证注册验证码
    /// - Parameters:
    ///   - email: 用户邮箱
    ///   - code: 验证码
    func verifyRegisterOTP(email: String, code: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // 验证 OTP，type 为 .email（注册/登录用）
            let session = try await supabase.auth.verifyOTP(
                email: email,
                token: code,
                type: .email
            )

            // ⚠️ 此时用户已登录，但注册流程需要强制设置密码
            currentUser = session.user
            otpVerified = true
            needsPasswordSetup = true
            // isAuthenticated 保持 false，必须设置密码后才能进入主页

            print("[AuthManager] 注册验证码验证成功，用户已登录但需要设置密码")

        } catch {
            errorMessage = "验证码验证失败: \(error.localizedDescription)"
            print("[AuthManager] 验证注册验证码失败: \(error)")
        }

        isLoading = false
    }

    /// 完成注册（设置密码）
    /// - Parameter password: 用户密码
    func completeRegistration(password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // 更新用户密码
            try await supabase.auth.update(user: UserAttributes(password: password))

            // 密码设置成功，注册流程完成
            needsPasswordSetup = false
            isAuthenticated = true

            // 重置 OTP 相关状态
            otpSent = false
            otpVerified = false

            print("[AuthManager] 注册完成，密码已设置")

        } catch {
            errorMessage = "设置密码失败: \(error.localizedDescription)"
            print("[AuthManager] 设置密码失败: \(error)")
        }

        isLoading = false
    }

    // MARK: - 登录

    /// 邮箱密码登录
    /// - Parameters:
    ///   - email: 用户邮箱
    ///   - password: 用户密码
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )

            currentUser = session.user
            isAuthenticated = true

            print("[AuthManager] 登录成功: \(session.user.email ?? "unknown")")

        } catch {
            errorMessage = "登录失败: \(error.localizedDescription)"
            print("[AuthManager] 登录失败: \(error)")
        }

        isLoading = false
    }

    // MARK: - 找回密码流程

    /// 发送重置密码验证码
    /// - Parameter email: 用户邮箱
    func sendResetOTP(email: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // 发送重置密码邮件（使用 Reset Password 邮件模板）
            try await supabase.auth.resetPasswordForEmail(email)

            otpSent = true
            print("[AuthManager] 重置密码验证码已发送至: \(email)")

        } catch {
            errorMessage = "发送重置验证码失败: \(error.localizedDescription)"
            print("[AuthManager] 发送重置验证码失败: \(error)")
        }

        isLoading = false
    }

    /// 验证重置密码验证码
    /// - Parameters:
    ///   - email: 用户邮箱
    ///   - code: 验证码
    func verifyResetOTP(email: String, code: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // ⚠️ 重置密码使用 .recovery 类型，不是 .email
            let session = try await supabase.auth.verifyOTP(
                email: email,
                token: code,
                type: .recovery
            )

            // 验证成功，用户已登录，等待设置新密码
            currentUser = session.user
            otpVerified = true
            needsPasswordSetup = true

            print("[AuthManager] 重置密码验证码验证成功，等待设置新密码")

        } catch {
            errorMessage = "验证码验证失败: \(error.localizedDescription)"
            print("[AuthManager] 验证重置验证码失败: \(error)")
        }

        isLoading = false
    }

    /// 重置密码（设置新密码）
    /// - Parameter newPassword: 新密码
    func resetPassword(newPassword: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // 更新用户密码
            try await supabase.auth.update(user: UserAttributes(password: newPassword))

            // 密码重置成功
            needsPasswordSetup = false
            isAuthenticated = true

            // 重置 OTP 相关状态
            otpSent = false
            otpVerified = false

            print("[AuthManager] 密码重置成功")

        } catch {
            errorMessage = "重置密码失败: \(error.localizedDescription)"
            print("[AuthManager] 重置密码失败: \(error)")
        }

        isLoading = false
    }

    // MARK: - 第三方登录（预留）

    /// Apple 登录
    func signInWithApple() async {
        // TODO: 实现 Apple 登录
        // 1. 使用 AuthenticationServices 获取 Apple ID credential
        // 2. 调用 supabase.auth.signInWithIdToken(credentials:)
        print("[AuthManager] Apple 登录 - 待实现")
    }

    /// Google 登录
    func signInWithGoogle() async {
        // TODO: 实现 Google 登录
        // 1. 使用 GoogleSignIn SDK 获取 ID token
        // 2. 调用 supabase.auth.signInWithIdToken(credentials:)
        print("[AuthManager] Google 登录 - 待实现")
    }

    // MARK: - 其他方法

    /// 登出
    func signOut() async {
        isLoading = true
        errorMessage = nil

        do {
            try await supabase.auth.signOut()

            // 重置所有状态
            isAuthenticated = false
            needsPasswordSetup = false
            currentUser = nil
            otpSent = false
            otpVerified = false

            print("[AuthManager] 已登出")

        } catch {
            errorMessage = "登出失败: \(error.localizedDescription)"
            print("[AuthManager] 登出失败: \(error)")
        }

        isLoading = false
    }

    /// 检查现有会话
    func checkSession() async {
        isLoading = true

        do {
            let session = try await supabase.auth.session
            currentUser = session.user

            // 检查用户是否有密码（通过 identities 判断）
            // 如果用户通过 OTP 登录但未设置密码，需要继续设置密码流程
            if let identities = session.user.identities,
               identities.contains(where: { $0.provider == "email" }) {
                // 有邮箱身份，认为已完成注册
                isAuthenticated = true
            } else {
                // 可能是 OTP 登录但未设置密码的状态
                needsPasswordSetup = true
            }

            print("[AuthManager] 检测到现有会话: \(session.user.email ?? "unknown")")

        } catch {
            // 没有有效会话，保持未认证状态
            isAuthenticated = false
            currentUser = nil
            print("[AuthManager] 无有效会话")
        }

        isLoading = false
    }

    // MARK: - 辅助方法

    /// 清除错误信息
    func clearError() {
        errorMessage = nil
    }

    /// 重置 OTP 流程状态（用于取消或重新开始）
    func resetOTPFlow() {
        otpSent = false
        otpVerified = false
        needsPasswordSetup = false
        errorMessage = nil
    }
}
