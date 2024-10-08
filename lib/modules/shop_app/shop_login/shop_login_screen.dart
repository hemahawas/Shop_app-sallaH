import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_project/layout/shop_app/cubit/cubit.dart';
import 'package:my_project/layout/shop_app/cubit/states.dart';
import 'package:my_project/layout/shop_app/shop_layout.dart';
import 'package:my_project/modules/shop_app/register/shop_register_screen.dart';
import 'package:my_project/shared/components/components.dart';
import 'package:my_project/shared/components/constants.dart';
import 'package:my_project/shared/network/local/cache/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  var textController = TextEditingController();
  var passController = TextEditingController();



  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) => {
        if (state is ShopLoginSuccessStates)
          {
            if (ShopCubit.get(context).loginModel.status)
              {
                showToast(
                  message: ShopCubit.get(context).loginModel.message!,
                  state: ToastColor.success,
                ),
                CacheHelper.saveData(
                  key: 'token',
                  value: ShopCubit.get(context).loginModel.data?.token,
                ).then((value) {
                  token = ShopCubit.get(context).loginModel.data?.token;
                  ShopCubit.get(context).currentIndex = 0;
                  ShopCubit.get(context).getUserData();
                  navigateAndFinish(context, ShopLayout());
                }),
              }
            else
              {
                showToast(
                    message: ShopCubit.get(context).loginModel.message!,
                    state: ToastColor.error)
              }
          }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'LOGIN',

                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                    'Login to earn some offers',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    defaultFormField(
                      controller: textController,
                      type: TextInputType.emailAddress,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'The email must not be empty';
                        }
                        return null;
                      },
                      label: 'Email address',
                      prefix: Icons.email_outlined,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    defaultFormField(
                      controller: passController,
                      type: TextInputType.visiblePassword,
                      isClickable: true,
                      isPassword: ShopCubit.get(context).isNotShown,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return 'Password is too short';
                        }
                        return null;
                      },
                      label: 'Password',
                      prefix: Icons.lock,
                      suffix: Icons.remove_red_eye,
                      suffixPressed: () {
                        ShopCubit.get(context).changePasswordVisibility();
                      }
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! ShopLoginLoadingStates,
                      builder: (context) => defaultButton(
                        text: 'login',
                        function: () {
                          if (formKey.currentState!.validate()) {
                            ShopCubit.get(context).userLogin(
                              email: textController.text,
                              password: passController.text,
                            );
                          }
                        },
                      ),
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator(color: Colors.deepOrange,)),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Don\'t have account ?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        defaultTextButton(
                          onPressed: () {
                            navigateTo(context, ShopRegisterScreen());
                          },
                          text: 'register',
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
