import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Account/account_screen.dart';
import '../features/auth/presentation/view/login_screen.dart';
import '../provider/user_provider.dart';

class MainTemplate extends StatelessWidget {
  final Widget templateBody;
  final String? subtitle;
  final Color bgColor;

  const MainTemplate({
    Key? key,
    this.subtitle,
    required this.templateBody,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<UserProvider>(builder: (ctx, userProvider, child) {
        return userProvider.user == null ? _loading(context) : templateBody;
      }),
    );
  }

  Widget _head(UserProvider userProvider, Size size, BuildContext context) {
    return ListTile(
      title: Text('Hi ${userProvider.user!.name}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24.0,
          )),
      subtitle: Text(
        subtitle ?? greeting(),
        style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.cake_rounded)),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AccountScreen()),
              );
            },
            child: Container(
              height: size.width * .1,
              width: size.width * .1,
              margin: const EdgeInsets.only(left: 5.0),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: userProvider.user!.profilePic.isEmpty
                  ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                  : CachedNetworkImage(
                      imageUrl: userProvider.user!.profilePic,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loading(BuildContext context) {
    ValueNotifier<bool> isShown = ValueNotifier(false);
    Future.delayed(const Duration(seconds: 10), () => isShown.value = true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/new_loading.json'),
        ValueListenableBuilder(
          valueListenable: isShown,
          builder: (ctx, isVisible, child) {
            return isVisible ? child! : const SizedBox.shrink();
          },
          child: ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              await FirebaseAuth.instance.signOut();
              final pref = await SharedPreferences.getInstance();
              await pref.clear();
              Provider.of<UserProvider>(context, listen: false).clearUser();
              navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset session'),
          ),
        ),
      ],
    );
  }
}

//TIME OF DAY GREETING IN HOME SCREEN
String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return "Good morning, Today's ur day🤗";
  } else if (hour < 16) {
    return "Good noon, Stay focused😍";
  } else {
    return "Good evening, Let's do it🤩";
  }
}
