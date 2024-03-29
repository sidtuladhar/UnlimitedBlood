import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:blood_nepal/api.dart';
import 'home/home.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Box _boxLogin = Hive.box("login");

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerPhoneNumber = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    _boxLogin.put("loginStatus", false);

    if (_boxLogin.get("loginStatus") ?? false) {
      return const Home();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0056FF),
                Color(0xFF80ACFF),
                Color(0xFF80ACFF),
                Color(0xFF0050F3),
                Color(0xFFFFF5FB),
                Color(0xFFFFF5FB),
                Color(0xFFFFF5FB),
              ],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 10, right: 15),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 220,
                    width: 400,
                  )),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _controllerPhoneNumber,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: "Phone Number",
                                  labelStyle: const TextStyle(fontSize: 18),
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onEditingComplete: () =>
                                    _focusNodePassword.requestFocus(),
                                validator: (String? value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length != 10) {
                                    return "Please enter a valid phone number.";
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _controllerPassword,
                                focusNode: _focusNodePassword,
                                obscureText: _obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon:
                                      const Icon(Icons.password_outlined),
                                  labelStyle: const TextStyle(fontSize: 18),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: _obscurePassword
                                          ? const Icon(
                                              Icons.visibility_off_outlined)
                                          : const Icon(
                                              Icons.visibility_outlined)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter password.";
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              Text(errorMessage,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  textAlign: TextAlign.left),
                              const SizedBox(height: 40),
                              Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      minimumSize: const Size.fromHeight(50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        Map loginInfo =
                                            await ApiService().checkLogin(
                                          _controllerPhoneNumber.text,
                                          _controllerPassword.text,
                                        );
                                        if (loginInfo["success"] == true) {
                                          _boxLogin.put("loginStatus", true);
                                          _boxLogin.put("phoneNumber",
                                              _controllerPhoneNumber.text);
                                          _boxLogin.put("password",
                                              _controllerPassword.text);
                                          _boxLogin.put(
                                              "fname", loginInfo["fname"]);
                                          _boxLogin.put(
                                              "mname", loginInfo["mname"]);
                                          _boxLogin.put(
                                              "address", loginInfo["address"]);
                                          _boxLogin.put(
                                              "lname", loginInfo["lname"]);
                                          _boxLogin.put(
                                              "gender", loginInfo["gender"]);
                                          _boxLogin.put("bloodGroup",
                                              loginInfo["bloodGroup"]);
                                          _boxLogin.put(
                                              "email", loginInfo["email"]);
                                          _boxLogin.put("birthDate",
                                              loginInfo["birthDate"]);
                                          _boxLogin.put("totalDonations",
                                              loginInfo["totalDonations"]);
                                          if (!mounted) return;
                                          navigateToHome(context);
                                        } else {
                                          setState(() {
                                            errorMessage = "Phone number or "
                                                "password is incorrect.";
                                          });
                                        }
                                      }
                                    },
                                    child: const Text("Login",
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Don't have an account?",
                                          style: TextStyle(fontSize: 15)),
                                      TextButton(
                                        onPressed: () {
                                          _formKey.currentState?.reset();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const Signup();
                                              },
                                            ),
                                          );
                                        },
                                        child: const Text("Signup",
                                            style: TextStyle(fontSize: 17)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToHome(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerPhoneNumber.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
