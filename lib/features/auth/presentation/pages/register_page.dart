import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _agreed = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid =>
      RegExp(r'^1[3-9]\d{9}$').hasMatch(_phoneController.text);
  bool get _isPasswordValid => _passwordController.text.length >= 6;
  bool get _canRegister =>
      _agreed && _isPhoneValid && _isPasswordValid;

  Future<void> _handleRegister() async {
    if (!_canRegister) return;
    await ref.read(authProvider.notifier).register(
          _phoneController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (_, state) {
      if (state.status == AuthStatus.authenticated) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(AppStrings.registerTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(AppStrings.registerSubtitle,
                style: TextStyle(
                    fontSize: 14, color: AppColors.mutedForeground)),
            const SizedBox(height: 32),

            // Phone input
            Text(AppStrings.phoneHint,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.foreground)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '请输入手机号',
                prefixIcon: const Icon(Icons.phone,
                    color: AppColors.mutedForeground),
              ),
            ),
            if (_phoneController.text.isNotEmpty && !_isPhoneValid)
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(AppStrings.phoneInvalid,
                    style: TextStyle(
                        color: AppColors.destructive, fontSize: 12)),
              ),
            const SizedBox(height: 20),

            // Password
            Text('设置密码',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.foreground)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                hintText: '请设置登录密码',
                prefixIcon: const Icon(Icons.lock,
                    color: AppColors.mutedForeground),
                suffixIcon: IconButton(
                  icon: Icon(_showPassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  color: AppColors.mutedForeground,
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                ),
              ),
            ),
            if (_passwordController.text.isNotEmpty && !_isPasswordValid)
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(AppStrings.passwordTooShort,
                    style: TextStyle(
                        color: AppColors.destructive, fontSize: 12)),
              )
            else if (_isPasswordValid)
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 4),
                child: Text(AppStrings.passwordStrengthOk,
                    style:
                        TextStyle(color: AppColors.success, fontSize: 12)),
              ),
            const SizedBox(height: 24),

            // Agreement
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _agreed,
                    onChanged: (v) =>
                        setState(() => _agreed = v ?? false),
                    activeColor: AppColors.primary,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedForeground),
                      children: [
                        const TextSpan(text: '我已阅读并同意'),
                        TextSpan(
                          text: '《用户协议》',
                          style:
                              TextStyle(color: AppColors.primary),
                        ),
                        const TextSpan(text: '和'),
                        TextSpan(
                          text: '《隐私政策》',
                          style:
                              TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Error
            if (authState.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(authState.error!,
                    style: const TextStyle(
                        color: AppColors.destructive, fontSize: 13)),
              ),

            // Register button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    authState.isLoading || !_canRegister ? null : _handleRegister,
                child: authState.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('注册'),
              ),
            ),
            const SizedBox(height: 16),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('已有账号? ',
                    style: TextStyle(color: AppColors.mutedForeground)),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('立即登录',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
