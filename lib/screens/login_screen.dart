import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:driver/bloc/login_bloc.dart';
import 'package:driver/screens/CustomBigElevatedButton.dart';
import 'package:driver/screens/CustomTextFieldWithIcon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  
  TextEditingController Username = TextEditingController();
  TextEditingController Password = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Lottie.asset(
            "assets/Animation - 1708931411314.json",
          ),),
           SizedBox(
                  height: 30.0,
                ),
                Text("Login",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                ),),
                SizedBox(
                  height: 10.0,
                ),
               
                 SizedBox(
                  height: 30.0,
                ),

                  ],
                ),
                Column(
                  children: [
                    CustomTextFieldWithIcon(context: context, Icons: Icons.person, controller: Username,HintText: "Username"),
                SizedBox(height: 20.0,),
                CustomTextFieldWithIcon(context: context, Icons: Icons.key, controller: Password, HintText: "Password", obscureText: true,),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if(state is LoginLoadingState){
                      return Container();
                    }
                    else{
                      return Text.rich(
                        style:TextStyle(fontSize: 15.0),
                        TextSpan(children: [
                         
                        ])
                      );
                    }
                  },
                ),
                
              ],
            ),
                SizedBox(
                  height: 0,
                ),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccessState) {
                    Navigator.popAndPushNamed(context, '/home');
                  } 
                  else if(state is DrivingAllowedfalse){
                      
                  }
                  else if (state is LoginErrorState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.Error)));
                  }
            },    builder: (context, state) {
                    if (state is LoginLoadingState) {
                      return CircularProgressIndicator();
                    } else {
                      return CustomBigElevatedButton(
                        context: context,
                         onPressed: () async {
                    String username = Username.value.text.toUpperCase();
                    String password = Password.value.text;
                   
                    if (username.isEmpty || password.isEmpty) {
                      context
                          .read<LoginBloc>()
                          .add(LoginErrorEvent(Error: "Empty Username Or password"));
                    } else {
                      context.read<LoginBloc>().add(
                          LoginSubmitEvent(Username: username, Password: password));
                    }
                  },
                  color: Color.fromARGB(255, 243, 121, 121),
                        text: "Login",
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
  }
}