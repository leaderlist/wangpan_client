import 'package:flutter/material.dart';
import 'package:wangpan_client/interface/login.dart';
import 'package:wangpan_client/request/index.dart';
import 'package:wangpan_client/store/login/index.dart';
import 'package:wangpan_client/store/user/index.dart';
import 'package:wangpan_client/utils/encrypt.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<MyLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginStore = LoginStore();
  final _userStore = UserStore();
  // 存储表单输入值
  String _username = '';
  String _password = '';

  bool _isObscure = true;

  HttpUtil http = HttpUtil();

  void _submitForm() async {
    final currentState = _formKey.currentState;
    if (currentState != null && currentState.validate()) {
      _formKey.currentState!.save();
      // TODO: 调用登录接口
      LoginRequestData data = LoginRequestData(
        username: _username,
        password: sha256Encrypt(
          '${_password}-https://github.com/alist-org/alist',
        ),
      );

      _loginStore.login(
        data,
        loginCallback: (data) {
          _userStore.fetchUserInfo();
          Navigator.pushNamed(context, '/');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 237, 237, 235), // 浅蓝（起始色）
              Color.fromARGB(235, 151, 160, 159), // 深蓝（结束色）
            ],
            stops: [0.0, 1.0],
          ),
        ),
        alignment: Alignment.center,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            width: 360,
            height: 400,
            decoration: BoxDecoration(
              color: Color.fromARGB(21, 23, 24, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUnfocus,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '密码登录',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '请输入用户名',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名';
                      }

                      if (!RegExp(r'^[a-zA-Z0-9_-]{4,16}$').hasMatch(value)) {
                        return '用户名格式不正确';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _username = value;
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '请输入密码',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    obscureText: _isObscure,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }

                      if (value.length < 6) {
                        return '密码长度不能少于6位';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _password = value;
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    width: 160,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(197, 104, 83, 9),
                        ),
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        '登录',
                        style: TextStyle(
                          color: Color.fromARGB(196, 241, 242, 242),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '忘记密码请联系管理员！',
                      style: TextStyle(color: Colors.black45, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
