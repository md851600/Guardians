//
//  SettingsView.swift
//  AIVibe
//
//  Created by Claude on 1/12/26.
//

import SwiftUI
import Supabase

struct SettingsView: View {
    @State private var showDeleteConfirmation = false
    @State private var deleteConfirmText = ""
    @State private var isDeleting = false
    @State private var logMessage = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    private let requiredConfirmText = "删除"

    var body: some View {
        Form {
            // App Info Section
            Section(header: Text("应用信息")) {
                HStack {
                    Text("版本")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }

            // Debug Log Section
            if !logMessage.isEmpty {
                Section(header: Text("调试日志")) {
                    ScrollView {
                        Text(logMessage)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 150)
                }
            }

            // Danger Zone Section
            Section(header: Text("危险区域"), footer: Text("删除账户后，所有数据将被永久删除且无法恢复。")) {
                Button(action: {
                    showDeleteConfirmation = true
                    logMessage = "[日志] 用户点击了删除账户按钮\n"
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Text("删除账户")
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("设置")
        .sheet(isPresented: $showDeleteConfirmation) {
            deleteConfirmationSheet
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Delete Confirmation Sheet
    var deleteConfirmationSheet: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Warning Icon
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .padding(.top, 40)

                // Warning Text
                Text("确认删除账户？")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("此操作不可撤销。您的所有数据将被永久删除。")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Confirmation Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("请输入「\(requiredConfirmText)」以确认：")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("输入确认文字", text: $deleteConfirmText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal)

                Spacer()

                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        performDeleteAccount()
                    }) {
                        HStack {
                            if isDeleting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(isDeleting ? "删除中..." : "确认删除")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(deleteConfirmText == requiredConfirmText ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(deleteConfirmText != requiredConfirmText || isDeleting)

                    Button(action: {
                        showDeleteConfirmation = false
                        deleteConfirmText = ""
                        logMessage += "[日志] 用户取消了删除操作\n"
                    }) {
                        Text("取消")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                    .disabled(isDeleting)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("删除账户")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }

    // MARK: - Delete Account Function
    func performDeleteAccount() {
        isDeleting = true
        logMessage += "[日志] 开始删除账户流程...\n"

        Task {
            do {
                logMessage += "[日志] 正在获取用户会话...\n"

                // Get current session
                let session = try await supabase.auth.session
                let accessToken = session.accessToken

                logMessage += "[日志] 成功获取访问令牌\n"
                logMessage += "[日志] 正在调用 delete-account 边缘函数...\n"

                // Call the edge function
                let url = URL(string: "https://eujoyccryuwhxtqceqgy.supabase.co/functions/v1/delete-account")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NSError(domain: "DeleteAccount", code: -1, userInfo: [NSLocalizedDescriptionKey: "无效的响应"])
                }

                logMessage += "[日志] 收到响应，状态码: \(httpResponse.statusCode)\n"

                let responseString = String(data: data, encoding: .utf8) ?? "无法解析响应"
                logMessage += "[日志] 响应内容: \(responseString)\n"

                if httpResponse.statusCode == 200 {
                    logMessage += "[日志] 账户删除成功！\n"

                    await MainActor.run {
                        isDeleting = false
                        showDeleteConfirmation = false
                        deleteConfirmText = ""
                        alertTitle = "成功"
                        alertMessage = "您的账户已被成功删除。"
                        showAlert = true
                    }

                    // Sign out locally
                    try? await supabase.auth.signOut()
                    logMessage += "[日志] 已退出本地会话\n"

                } else {
                    logMessage += "[日志] 删除失败，状态码: \(httpResponse.statusCode)\n"

                    await MainActor.run {
                        isDeleting = false
                        alertTitle = "错误"
                        alertMessage = "删除账户失败: \(responseString)"
                        showAlert = true
                    }
                }

            } catch {
                logMessage += "[日志] 发生错误: \(error.localizedDescription)\n"

                await MainActor.run {
                    isDeleting = false
                    alertTitle = "错误"
                    alertMessage = "删除账户时发生错误: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
