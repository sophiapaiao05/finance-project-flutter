import 'package:finance_project_sophia_flutter/home/presentation/pages/home_page.dart';
import 'package:finance_project_sophia_flutter/login/presentation/controllers/login_auth_provider.dart';
import 'package:finance_project_sophia_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    await Provider.of<LoginAuthProvider>(context, listen: false).login(
      _emailController.text,
      _passwordController.text,
    );

    if (context.mounted &&
        Provider.of<LoginAuthProvider>(context, listen: false).successLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<void> _register(BuildContext context) async {
    await Provider.of<LoginAuthProvider>(context, listen: false).register(
      _emailController.text,
      _passwordController.text,
    );

    if (context.mounted &&
        Provider.of<LoginAuthProvider>(context, listen: false).successLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginAuthProvider>(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildLoginPage(context, authProvider),
          _buildRegisterPage(context, authProvider),
        ],
      ),
    );
  }

  Widget _buildLoginPage(BuildContext context, LoginAuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFieldLogin(
            controller: _emailController,
            errorMessage: authProvider.errorMessage,
            hintText: 'Email',
          ),
          const SizedBox(height: 20),
          TextFieldLogin(
            controller: _passwordController,
            errorMessage: authProvider.errorMessage,
            hintText: 'Senha',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _login(context),
            child: const Text('Login',
                style: TextStyle(color: FinanceProjectColors.orange)),
          ),
          TextButton(
            onPressed: () => _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Text(
              'Não tem uma conta? Registre-se',
              style: TextStyle(color: FinanceProjectColors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPage(
      BuildContext context, LoginAuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFieldLogin(
            controller: _emailController,
            errorMessage: authProvider.errorMessage,
            hintText: 'Email',
          ),
          const SizedBox(height: 20),
          TextFieldLogin(
            controller: _passwordController,
            errorMessage: authProvider.errorMessage,
            hintText: 'Senha',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _register(context),
            child: const Text('Registrar',
                style: TextStyle(color: FinanceProjectColors.orange)),
          ),
          TextButton(
            onPressed: () => _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Text('Já tem uma conta? Faça login',
                style: TextStyle(color: FinanceProjectColors.orange)),
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
