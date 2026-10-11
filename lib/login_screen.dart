
import 'package:flutter/material.dart';

import 'app_data.dart';
import 'home_screen.dart';
import 'hod_dashboard_screen.dart';
import 'vp_dashboard_screen.dart';
import 'principal_dashboard_screen.dart';
import 'services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;
  String? loginError;

  String selectedRole = 'Staff';
  String selectedDepartment = 'CSE';
  String selectedYear = '2nd Year';
  String selectedSection = 'B';

  final Color teal = const Color(0xFF164A4A);
  final Color lightTeal = const Color(0xFFE8F7F7);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        loginError = 'Please enter email and password';
      });
      return;
    }

    setState(() {
      isLoading = true;
      loginError = null;
    });

    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (!mounted) return;

      if (result['success'] != true) {
        setState(() {
          loginError =
              result['message']?.toString() ??
              'Invalid email or password';
        });
        return;
      }

      final backendRole =
          result['role']?.toString().toUpperCase();

      final userId = int.tryParse(
        result['user_id']?.toString() ?? '',
      );

      if (backendRole == null || userId == null) {
        setState(() {
          loginError =
              'Invalid login response. Please check the backend.';
        });
        return;
      }

      String appRole;

      switch (backendRole) {
        case 'STAFF':
          appRole = 'Staff';
          break;
        case 'HOD':
          appRole = 'HOD';
          break;
        case 'VICE_PRINCIPAL':
          appRole = 'Vice Principal';
          break;
        case 'PRINCIPAL':
          appRole = 'Principal';
          break;
        default:
          setState(() {
            loginError = 'Your account role is not supported';
          });
          return;
      }

      if (appRole != selectedRole) {
        setState(() {
          loginError =
              'Please select the role assigned to your account';
        });
        return;
      }

      final scope = RoleScope(
        role: appRole,
        department: selectedDepartment,
        year: appRole == 'Staff' ? selectedYear : null,
        section: appRole == 'Staff' ? selectedSection : null,
        userId: userId,
      );

      final Widget nextScreen;

      switch (appRole) {
        case 'HOD':
          nextScreen = HodDashboardScreen(scope: scope);
          break;
        case 'Vice Principal':
          nextScreen = VpDashboardScreen(scope: scope);
          break;
        case 'Principal':
          nextScreen = PrincipalDashboardScreen(scope: scope);
          break;
        default:
          nextScreen = HomeScreen(scope: scope);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => nextScreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loginError =
            'Unable to connect. Please check that the backend is running.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showStaffClass = selectedRole == 'Staff';
    final showDepartment =
        selectedRole == 'Staff' || selectedRole == 'HOD';

    return Scaffold(
      backgroundColor: lightTeal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 28,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/pingloop_logo.png',
                  width: 155,
                  height: 155,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 22),

              Text(
                'Welcome Back 👋',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: teal,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Login to continue to PINGLOOP',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              _field(
                controller: emailController,
                hint: 'Email',
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: teal,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: teal,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              _dropdown(
                label: 'Login as',
                value: selectedRole,
                items: const [
                  'Staff',
                  'HOD',
                  'Vice Principal',
                  'Principal',
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    selectedRole = value;
                    loginError = null;
                  });
                },
              ),

              if (showDepartment) ...[
                const SizedBox(height: 15),
                _dropdown(
                  label: selectedRole == 'HOD'
                      ? 'HOD Department'
                      : 'Staff Department',
                  value: selectedDepartment,
                  items: AppData.departments,
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                ),
              ],

              if (showStaffClass) ...[
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        label: 'Year',
                        value: selectedYear,
                        items: const [
                          '1st Year',
                          '2nd Year',
                          '3rd Year',
                          '4th Year',
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            selectedYear = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _dropdown(
                        label: 'Section',
                        value: selectedSection,
                        items: const ['A', 'B', 'C', 'D'],
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            selectedSection = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 53,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Login →',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              if (loginError != null) ...[
                const SizedBox(height: 12),
                Text(
                  loginError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              const Text(
                'Simple • Smart • Connected',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: teal),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          Icons.person_outline,
          color: teal,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}