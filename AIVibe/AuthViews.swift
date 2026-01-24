//
//  AuthViews.swift
//  AIVibe
//
//  认证相关视图 - 登录、注册、找回密码
//  1/18/2026 16 errors

import SwiftUI

// MARK: - 认证根视图（路由控制）

struct AuthRootView: View {
    @ObservedObject var authManager = AuthManager.shared

    var body: some View {
        Group {
            if authManager.isAuthenticated {
                // 已完成认证，显示主页
                MainTabView()
            } else if authManager.needsPasswordSetup {
                // OTP 已验证，需要设置密码
                SetPasswordView()
            } else {
                // 未登录，显示登录页
                LoginView()
            }
        }
    }
}

// MARK: - 主页占位（替换为你的实际主页）

struct MainTabView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)

                Text("登录成功！")
                    .font(.title)

                Text("这里是主页")
                    .foregroundColor(.secondary)

                Button("退出登录") {
                    Task {
                        await AuthManager.shared.signOut()
                    }
                }
                .foregroundColor(.red)
                .padding(.top, 40)
            }
            .navigationTitle("AIVibe")
        }
    }
}

// MARK: - 登录视图

struct LoginView: View {
    @ObservedObject var authManager = AuthManager.shared

    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showForgotPassword = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo 区域
                    VStack(spacing: 8) {
                        Image(systemName: "globe.asia.australia.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)

                        Text("AIVibe")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)

                    // 输入表单
                    VStack(spacing: 16) {
                        TextField("邮箱", text: $email)
                            #if os(iOS)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            #endif
                            .textContentType(.emailAddress)
                            .textFieldStyle(.roundedBorder)

                        SecureField("密码", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.password)
                    }
                    .padding(.horizontal)

                    // 错误信息
                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // 登录按钮
                    Button(action: login) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(authManager.isLoading ? "登录中..." : "登录")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canLogin ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!canLogin || authManager.isLoading)
                    .padding(.horizontal)

                    // 找回密码
                    Button("忘记密码？") {
                        showForgotPassword = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)

                    Divider()
                        .padding(.vertical)

                    // 注册入口
                    HStack {
                        Text("还没有账号？")
                            .foregroundColor(.secondary)
                        Button("立即注册") {
                            showRegister = true
                        }
                        .fontWeight(.semibold)
                    }
                    .font(.subheadline)

                    // 第三方登录（预留）
                    VStack(spacing: 12) {
                        Text("其他登录方式")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top)

                        HStack(spacing: 20) {
                            Button(action: { Task { await authManager.signInWithApple() } }) {
                                Image(systemName: "apple.logo")
                                    .font(.title2)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(25)
                            }

                            Button(action: { Task { await authManager.signInWithGoogle() } }) {
                                Text("G")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(width: 50, height: 50)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(25)
                            }
                        }
                        .foregroundColor(.primary)
                    }

                    Spacer()
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
            .onAppear {
                authManager.clearError()
            }
        }
    }

    private var canLogin: Bool {
        !email.isEmpty && !password.isEmpty
    }

    private func login() {
        Task {
            await authManager.signIn(email: email, password: password)
        }
    }
}

// MARK: - 注册视图

struct RegisterView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var otpCode = ""

    // 步骤: 1=输入邮箱, 2=输入验证码
    private var currentStep: Int {
        if authManager.otpVerified {
            return 3 // 会被 AuthRootView 处理，跳转到 SetPasswordView
        } else if authManager.otpSent {
            return 2
        } else {
            return 1
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 步骤指示器
                    StepIndicator(currentStep: currentStep, totalSteps: 3)
                        .padding(.top)

                    // 标题
                    VStack(spacing: 8) {
                        Text(stepTitle)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(stepSubtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)

                    // 输入区域
                    VStack(spacing: 16) {
                        if currentStep == 1 {
                            TextField("邮箱地址", text: $email)
                                #if os(iOS)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                #endif
                                .textContentType(.emailAddress)
                                .textFieldStyle(.roundedBorder)
                        } else if currentStep == 2 {
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            TextField("6位验证码", text: $otpCode)
                                .textFieldStyle(.roundedBorder)
                                #if os(iOS)
                                .keyboardType(.numberPad)
                                #endif
                                .multilineTextAlignment(.center)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)

                    // 错误信息
                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // 操作按钮
                    Button(action: handleAction) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(buttonTitle)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canProceed ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!canProceed || authManager.isLoading)
                    .padding(.horizontal)

                    // 重新发送验证码
                    if currentStep == 2 {
                        Button("重新发送验证码") {
                            Task {
                                await authManager.sendRegisterOTP(email: email)
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .disabled(authManager.isLoading)
                    }

                    Spacer()
                }
            }
            .navigationTitle("注册")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        authManager.resetOTPFlow()
                        dismiss()
                    }
                }
            }
            .onAppear {
                authManager.clearError()
            }
        }
    }

    private var stepTitle: String {
        switch currentStep {
        case 1: return "输入邮箱"
        case 2: return "验证邮箱"
        default: return "设置密码"
        }
    }

    private var stepSubtitle: String {
        switch currentStep {
        case 1: return "我们将向您的邮箱发送验证码"
        case 2: return "请输入发送到 \(email) 的验证码"
        default: return "设置您的登录密码"
        }
    }

    private var buttonTitle: String {
        if authManager.isLoading {
            return currentStep == 1 ? "发送中..." : "验证中..."
        }
        return currentStep == 1 ? "发送验证码" : "验证"
    }

    private var canProceed: Bool {
        switch currentStep {
        case 1: return !email.isEmpty && email.contains("@")
        case 2: return otpCode.count >= 6
        default: return false
        }
    }

    private func handleAction() {
        Task {
            if currentStep == 1 {
                await authManager.sendRegisterOTP(email: email)
            } else if currentStep == 2 {
                await authManager.verifyRegisterOTP(email: email, code: otpCode)
                // 验证成功后，AuthRootView 会自动跳转到 SetPasswordView
            }
        }
    }
}

// MARK: - 设置密码视图（注册/重置密码共用）

struct SetPasswordView: View {
    @ObservedObject var authManager = AuthManager.shared

    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 图标
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .padding(.top, 40)

                    // 标题
                    VStack(spacing: 8) {
                        Text("设置密码")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("请设置一个安全的密码")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // 密码输入
                    VStack(spacing: 16) {
                        SecureField("密码（至少6位）", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.newPassword)

                        SecureField("确认密码", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.newPassword)
                    }
                    .padding(.horizontal)

                    // 密码匹配提示
                    if !confirmPassword.isEmpty && password != confirmPassword {
                        Text("两次密码输入不一致")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }

                    // 错误信息
                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // 提交按钮
                    Button(action: setPassword) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(authManager.isLoading ? "设置中..." : "完成")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canSubmit ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!canSubmit || authManager.isLoading)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }

    private var canSubmit: Bool {
        password.count >= 6 && password == confirmPassword
    }

    private func setPassword() {
        Task {
            await authManager.completeRegistration(password: password)
        }
    }
}

// MARK: - 找回密码视图

struct ForgotPasswordView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var otpCode = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    // 步骤: 1=输入邮箱, 2=输入验证码, 3=设置新密码
    private var currentStep: Int {
        if authManager.otpVerified {
            return 3
        } else if authManager.otpSent {
            return 2
        } else {
            return 1
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 步骤指示器
                    StepIndicator(currentStep: currentStep, totalSteps: 3)
                        .padding(.top)

                    // 图标
                    Image(systemName: stepIcon)
                        .font(.system(size: 50))
                        .foregroundColor(.blue)

                    // 标题
                    VStack(spacing: 8) {
                        Text(stepTitle)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(stepSubtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)

                    // 输入区域
                    VStack(spacing: 16) {
                        switch currentStep {
                        case 1:
                            TextField("邮箱地址", text: $email)
                                #if os(iOS)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                #endif
                                .textContentType(.emailAddress)
                                .textFieldStyle(.roundedBorder)

                        case 2:
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            TextField("6位验证码", text: $otpCode)
                                .textFieldStyle(.roundedBorder)
                                #if os(iOS)
                                .keyboardType(.numberPad)
                                #endif
                                .multilineTextAlignment(.center)
                                .font(.title2)

                        case 3:
                            SecureField("新密码（至少6位）", text: $newPassword)
                                .textFieldStyle(.roundedBorder)
                                .textContentType(.newPassword)

                            SecureField("确认新密码", text: $confirmPassword)
                                .textFieldStyle(.roundedBorder)
                                .textContentType(.newPassword)

                            if !confirmPassword.isEmpty && newPassword != confirmPassword {
                                Text("两次密码输入不一致")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }

                        default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal)

                    // 错误信息
                    if let error = authManager.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // 操作按钮
                    Button(action: handleAction) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(buttonTitle)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canProceed ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(!canProceed || authManager.isLoading)
                    .padding(.horizontal)

                    // 重新发送验证码
                    if currentStep == 2 {
                        Button("重新发送验证码") {
                            Task {
                                await authManager.sendResetOTP(email: email)
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .disabled(authManager.isLoading)
                    }

                    Spacer()
                }
            }
            .navigationTitle("找回密码")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        authManager.resetOTPFlow()
                        dismiss()
                    }
                }
            }
            .onAppear {
                authManager.clearError()
            }
            .onChange(of: authManager.isAuthenticated) { _, authenticated in
                // 密码重置成功后关闭页面
                if authenticated {
                    dismiss()
                }
            }
        }
    }

    private var stepIcon: String {
        switch currentStep {
        case 1: return "envelope.fill"
        case 2: return "number.circle.fill"
        case 3: return "lock.rotation"
        default: return "questionmark.circle"
        }
    }

    private var stepTitle: String {
        switch currentStep {
        case 1: return "输入邮箱"
        case 2: return "验证身份"
        case 3: return "设置新密码"
        default: return ""
        }
    }

    private var stepSubtitle: String {
        switch currentStep {
        case 1: return "请输入您的注册邮箱"
        case 2: return "请输入发送到 \(email) 的验证码"
        case 3: return "请设置您的新密码"
        default: return ""
        }
    }

    private var buttonTitle: String {
        if authManager.isLoading {
            switch currentStep {
            case 1: return "发送中..."
            case 2: return "验证中..."
            case 3: return "设置中..."
            default: return ""
            }
        }
        switch currentStep {
        case 1: return "发送验证码"
        case 2: return "验证"
        case 3: return "完成"
        default: return ""
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 1: return !email.isEmpty && email.contains("@")
        case 2: return otpCode.count >= 6
        case 3: return newPassword.count >= 6 && newPassword == confirmPassword
        default: return false
        }
    }

    private func handleAction() {
        Task {
            switch currentStep {
            case 1:
                await authManager.sendResetOTP(email: email)
            case 2:
                await authManager.verifyResetOTP(email: email, code: otpCode)
            case 3:
                await authManager.resetPassword(newPassword: newPassword)
            default:
                break
            }
        }
    }
}

// MARK: - 步骤指示器组件

struct StepIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                Circle()
                    .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)

                if step < totalSteps {
                    Rectangle()
                        .fill(step < currentStep ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 30, height: 2)
                }
            }
        }
    }
}

// MARK: - 预览

#Preview("登录") {
    LoginView()
}

#Preview("注册") {
    RegisterView()
}

#Preview("找回密码") {
    ForgotPasswordView()
}

#Preview("认证根视图") {
    AuthRootView()
}
