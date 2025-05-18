import 'package:finance_project_sophia_flutter/login/presentation/pages/login_controller.dart';
import 'package:finance_project_sophia_flutter/login/presentation/utils/login_texts.dart';
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
          TextFieldLogin(
            controller: _emailController,
            errorMessage: loginController.errorMessage,
            hintText: 'Email',
          ),
          const SizedBox(height: 20),
          TextFieldLogin(
            controller: _passwordController,
            errorMessage: loginController.errorMessage,
            hintText: 'Senha',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => loginController.login(
              context,
              _emailController.text,
              _passwordController.text,
            ),
            child: loginController.isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    LoginTexts.loginButton,
                    style: TextStyle(color: FinanceProjectColors.orange),
                  ),
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
            errorMessage: loginController.errorMessage,
            hintText: LoginTexts.emailHint,
          ),
          const SizedBox(height: 20),
          TextFieldLogin(
            controller: _passwordController,
            errorMessage: loginController.errorMessage,
            hintText: LoginTexts.passwordHint,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => loginController.register(
              context,
              _emailController.text,
              _passwordController.text,
            ),
            child: loginController.isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    LoginTexts.registerButton,
                    style: TextStyle(color: FinanceProjectColors.orange),
                  ),
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
