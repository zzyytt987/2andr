import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/enums/login_method.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  LoginMethod _method = LoginMethod.password;
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _showPassword = false;
  bool _agreed = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_agreed || _phoneController.text.isEmpty) return;

    final phone = _phoneController.text;
    final authNotifier = ref.read(authProvider.notifier);

    if (_method == LoginMethod.password) {
      if (_passwordController.text.isEmpty) return;
      await authNotifier.loginWithPassword(phone, _passwordController.text);
    } else {
      if (_codeController.text.isEmpty) return;
      await authNotifier.loginWithSms(phone, _codeController.text);
    }
  }

  Future<void> _sendSms() async {
    final phone = _phoneController.text;
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(phone)) return;
    await ref.read(authProvider.notifier).sendSmsCode(phone, 'LOGIN');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.welcomeBack,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground)),
                    SizedBox(height: 4),
                    Text(AppStrings.loginSubtitle,
                        style: TextStyle(
                            fontSize: 14, color: AppColors.mutedForeground)),
                  ],
                ),
              ),
            ),

            // Illustration
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0x1A1677FF),
                      Color(0x80E6F4FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.smartphone,
                      size: 64, color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form card
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2)),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Toggle
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _method = LoginMethod.password),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _method == LoginMethod.password
                                        ? AppColors.card
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow:
                                        _method == LoginMethod.password
                                            ? [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.04),
                                                    blurRadius: 4)
                                              ]
                                            : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(AppStrings.phoneLogin,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              _method == LoginMethod.password
                                                  ? AppColors.foreground
                                                  : AppColors.mutedForeground)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _method = LoginMethod.sms),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _method == LoginMethod.sms
                                        ? AppColors.card
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: _method == LoginMethod.sms
                                        ? [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.04),
                                                blurRadius: 4)
                                          ]
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(AppStrings.smsLogin,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: _method == LoginMethod.sms
                                              ? AppColors.foreground
                                              : AppColors.mutedForeground)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Phone input
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: AppStrings.phoneHint,
                          prefixIcon: const Icon(Icons.phone,
                              color: AppColors.mutedForeground),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password or SMS code input
                      if (_method == LoginMethod.password)
                        TextField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            hintText: AppStrings.passwordHint,
                            prefixIcon: const Icon(Icons.lock,
                                color: AppColors.mutedForeground),
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              color: AppColors.mutedForeground,
                              onPressed: () => setState(
                                  () => _showPassword = !_showPassword),
                            ),
                          ),
                        )
                      else
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '请输入验证码',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _sendSms,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(120, 56),
                                ),
                                child: const Text('获取验证码'),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),

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
                                    style: TextStyle(
                                        color: AppColors.primary),
                                  ),
                                  const TextSpan(text: '和'),
                                  TextSpan(
                                    text: '《隐私政策》',
                                    style: TextStyle(
                                        color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Error message
                      if (authState.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(authState.error!,
                              style: const TextStyle(
                                  color: AppColors.destructive, fontSize: 13)),
                        ),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ||
                                  !_agreed ||
                                  _phoneController.text.isEmpty
                              ? null
                              : _handleLogin,
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('登录'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => context.push('/register'),
                            child: const Text('注册新账号',
                                style: TextStyle(color: AppColors.primary)),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('忘记密码?',
                                style:
                                    TextStyle(color: AppColors.mutedForeground)),
                          ),
                        ],
                      ),

                      // Third-party login
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('其他登录方式',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.mutedForeground)),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(Icons.wechat, const Color(0xFF07C160)),
                          const SizedBox(width: 24),
                          _socialButton(Icons.alternate_email,
                              const Color(0xFF1DA1F2)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 24),
        onPressed: () {},
      ),
    );
  }
}
