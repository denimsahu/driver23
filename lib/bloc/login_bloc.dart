// import 'package:admin/global/Variables.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitEvent>((event, emit) async {
      emit(LoginLoadingState());

      try {
        DocumentSnapshot<Map<String, dynamic>>? doc = await FirebaseFirestore.instance.collection("Drivers").doc(event.Username.toString()).get();
        if (doc.exists) {
          if (doc.get("Password").toString() == sha256.convert(utf8.encode(event.Password.toString())).toString()) {
            try{
              var prefs =  await SharedPreferences.getInstance();
              
                   prefs.setString('username',event.Username.toString());
    
                   if(doc.get('DrivingAllowed')){
               emit(LoginSuccessState());
                   }
                   else{
                    emit(DrivingAllowedfalse());
                   }
            }catch(e){
                   emit(LoginErrorState(Error: e.toString()));
            }
          } 
          else {
            emit(LoginErrorState(Error: "Incrrect password"));
          }
        } 
        else {
            emit(LoginErrorState(Error: "Invalid Username Or User Dose not Exists"));
        
        }
      } 
      catch (error) {
        if (error.toString().contains("The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.")) {
          emit(LoginErrorState(Error: "Can't Reach The Server At The Moment"));
        } 
        else {
          emit(LoginErrorState(Error: error.toString()));
        }
      }
    });

    on<LoginErrorEvent>((event, emit) {
      emit(LoginErrorState(Error: event.Error));
      });
  }
}