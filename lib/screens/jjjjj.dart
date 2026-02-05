//  BlocConsumer<LoginBloc, LoginState>(
//                 listener: (BuildContext context, state) {
//                   if (state is LoginSuccessState) {
//                     Navigator.popAndPushNamed(context, '/home');
//                   } 
//                   else if (state is LoginErrorState) {
//                     ScaffoldMessenger.of(context)
//                         .showSnackBar(SnackBar(content: Text(state.Error)));
//                   }
//             }, builder: (BuildContext context, state) {
//               if (state is LoginLoadingState) {
//                 return CircularProgressIndicator();
//               }
//               return ElevatedButton(
//                   onPressed: () async {
//                     String username = Username.value.text;
//                     String password = Password.value.text;
                   
//                     if (username.isEmpty || password.isEmpty) {
//                       context
//                           .read<LoginBloc>()
//                           .add(LoginErrorEvent(Error: "Empty Username Or password"));
//                     } else {
//                       context.read<LoginBloc>().add(
//                           LoginSubmitEvent(Username: username, Password: password));
//                     }
//                   },
//                   child: Text("Submit"));
//             })




//  onPressed: () async {
//                     String username = Username.value.text;
//                     String password = Password.value.text;
                   
//                     if (username.isEmpty || password.isEmpty) {
//                       context
//                           .read<LoginBloc>()
//                           .add(LoginErrorEvent(Error: "Empty Username Or password"));
//                     } else {
//                       context.read<LoginBloc>().add(
//                           LoginSubmitEvent(Username: username, Password: password));
//                     }
//                   },







// var prefs = await SharedPreferences.getInstance();
//                           var getusername = prefs.getString('username');



//  if (getusername == markerid){
                  
//        if (startpoint.isNotEmpty) {
//           List<Marker> udaipurstart = [
//             Marker(
//               markerId: MarkerId('start point1'),
//               position:
//                   LatLng(startpoint.first.latitude, startpoint.first.longitude),
//               icon: BitmapDescriptor.defaultMarkerWithHue(50),
//             ),
//           ];
//           _marker.addAll(udaipurstart);
//           if (Geolocator.distanceBetween(double.parse(latitide), double.parse(langitude),
//                       startpoint.first.latitude, startpoint.first.longitude) <=
//                   300 &&
//               IsGoingToTheEnd == false) {
//             IsGoingToTheEnd = true;
//             stops.doc(getusername.toString()).update({
//               'IsGoingToTheEnd': IsGoingToTheEnd,
//             });
//           }
//         }
//         if (endpoint.isNotEmpty) {
//            var prefs = await SharedPreferences.getInstance();
//                           var getusername = prefs.getString('username');
//           List<Marker> dabokend = [
//             Marker(
//               markerId: MarkerId('end point1'),
//               position:
//                   LatLng(endpoint.first.latitude, endpoint.first.longitude),
//               icon: BitmapDescriptor.defaultMarkerWithHue(30),
//             ),
//           ];
//           _marker.addAll(dabokend);
//           if (Geolocator.distanceBetween(double.parse(latitide), double.parse(langitude),
//                       endpoint.first.latitude, endpoint.first.longitude) <=
//                   300 &&
//               IsGoingToTheEnd == true) {
//             IsGoingToTheEnd = false;
//             stops.doc(getusername.toString()).update({
//               'IsGoingToTheEnd': IsGoingToTheEnd,
//             });
//           }
//         }
//            }