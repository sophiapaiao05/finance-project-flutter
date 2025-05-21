import 'package:finance_project_sophia_flutter/features/login/presentation/controllers/login_controller.dart';
import 'package:finance_project_sophia_flutter/features/login/utils/login_texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Tentar login automático
    Provider.of<LoginController>(context, listen: false).autoLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildLoginPage(context, loginController),
          _buildRegisterPage(context, loginController),
        ],
      ),
    );
  }

  Widget _buildLoginPage(
      BuildContext context, LoginController loginController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<String?>(
            stream: loginController.errorMessageStream,
            builder: (context, snapshot) {
              return TextFieldLogin(
                controller: _emailController,
                errorMessage: snapshot.data,
                hintText: LoginTexts.emailHint,
              );
            },
          ),
          const SizedBox(height: 20),
          TextFieldLogin(
            controller: _passwordController,
            hintText: LoginTexts.passwordHint,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          StreamBuilder<bool>(
            stream: loginController.isLoadingStream,
            builder: (context, snapshot) {
              final isLoading = snapshot.data ?? false;
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => loginController.login(
                          context,
                          _emailController.text,
                          _passwordController.text,
                        ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        LoginTexts.loginButton,
                        style: TextStyle(color: FinanceProjectColors.orange),
                      ),
              );
            },
          ),
          TextButton(
            onPressed: () => _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Text(
              LoginTexts.registerTitle,
              style: TextStyle(color: FinanceProjectColors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPage(
      BuildContext context, LoginController loginController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFieldLogin(
            controller: _emailController,
            hintText: LoginTexts.emailHint,
          ),
          const SizedBox(height: 20),
          TextFieldLogin(
            controller: _passwordController,
            hintText: LoginTexts.passwordHint,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          StreamBuilder<bool>(
            stream: loginController.isLoadingStream,
            builder: (context, snapshot) {
              final isLoading = snapshot.data ?? false;
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => loginController.register(
                          context,
                          _emailController.text,
                          _passwordController.text,
                        ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        LoginTexts.registerButton,
                        style: TextStyle(color: FinanceProjectColors.orange),
                      ),
              );
            },
          ),
          TextButton(
            onPressed: () => _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Text(
              LoginTexts.loginTitle,
              style: TextStyle(color: FinanceProjectColors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldLogin extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorMessage;
  final bool obscureText;

  const TextFieldLogin({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorMessage,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorMessage,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
