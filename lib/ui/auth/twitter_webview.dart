import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oauth1/oauth1.dart';
import 'package:overheard/constants/colorset.dart';
import 'package:overheard/constants/stringset.dart';
import 'package:overheard/ui/auth/bloc/auth_bloc.dart';
import 'package:overheard/ui/auth/repository/auth.repository.dart';
import 'package:overheard/ui/auth/signin.dart';
import 'package:overheard/ui/components/custom_cupertino_alert.dart';
import 'package:overheard/utils/ui_elements.dart';
import 'package:webview_flutter/webview_flutter.dart';


class TwitterWebview extends StatefulWidget {
  final twitterPlatform = Platform(
    'https://api.twitter.com/oauth/request_token', 
    'https://api.twitter.com/oauth/authorize', 
    'https://api.twitter.com/oauth/access_token',
    SignatureMethods.hmacSha1,
  );
  late final ClientCredentials clientCredentials;
  late final String oauthCallbackHandler;

  TwitterWebview({
    Key? key, 
    required final String  consumerKey, 
    required final String consumerSecret, 
    required this.oauthCallbackHandler
  }) : clientCredentials = ClientCredentials(consumerKey, consumerSecret), super(key: key);

  @override
  _TwitterWebviewState createState() => _TwitterWebviewState();
}

class _TwitterWebviewState extends State<TwitterWebview> {
  Authorization? _oauth;
  late final WebViewController _controller;
  
  @override
  void initState() {
    super.initState();
    _oauth = Authorization(widget.clientCredentials, widget.twitterPlatform);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _twitterLoginStart(WebViewController webViewController) async {
    print(SignatureMethods.hmacSha1);
    assert(null != _oauth);
    late final requestTokenResponse;
    try {
      requestTokenResponse = await _oauth!.requestTemporaryCredentials(widget.oauthCallbackHandler);
    } catch (exception) {
      print(exception);
    }
    
    final authoriztionPage = _oauth!.getResourceOwnerAuthorizationURI(
      requestTokenResponse.credentials.token
    );
    webViewController.loadUrl(authoriztionPage);
  }
  
  Future<void> _twitterLoginFinish(String oauthToken, String oauthVerifier) async {
    final tokenCredentialsResponse = await _oauth!.requestTokenCredentials(Credentials(oauthToken, ''), oauthVerifier);
    final result = TwitterAuthProvider.credential(
      accessToken: tokenCredentialsResponse.credentials.token, 
      secret: tokenCredentialsResponse.credentials.tokenSecret
    );

    // Passing AccessToken and secretToken to FirebaseAuth to login the user


    
    AuthRepository().signInWithTwitterWithWebView(
      context: context, 
      accessToken: tokenCredentialsResponse.credentials.token, 
      secret: tokenCredentialsResponse.credentials.tokenSecret
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster', 
      onMessageReceived: (JavascriptMessage message) {
        showToast(message.message, gradientStart);
      });
  }

  Future<bool> _onBackPressed() async {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CustomCupertinoAlert(
          title: confirmationText, 
          content: authBackAlertContent, 
          noBtnText: CancelButtonText, 
          yesBtnText: confirmButtonText,
          onNoAction: (){Navigator.pop(context);},
          onYesAction: () async {
            Navigator.pop(context);
            if (await _controller.canGoBack()) _controller.goBack();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlocProvider(
              create: (context) => AuthBloc(authRepository: AuthRepository()),
              child: const SignInScreen(),
            )));
          },
        )
    );
    // stay on app
    return false;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: WebView(
            initialUrl: 'https://mobile.twitter.com',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewcontroller) {
              _controller = webViewcontroller;
              // _twitterLoginStart(webViewcontroller);
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context)
            },
            navigationDelegate: (NavigationRequest req) {
              print("request= ${req.url}");
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              print(url);
              if (url.startsWith(widget.oauthCallbackHandler)) {
                final queryParameters = Uri.parse(url).queryParameters;
                final oauthToken = queryParameters['oauth_token'];
                final oauthVerifier = queryParameters['oauth_verifier'];
                if (null != oauthToken && null != oauthVerifier) {
                  _twitterLoginFinish(oauthToken, oauthVerifier);
                }
              }
            },
            gestureNavigationEnabled: true,
          ),
        ),
      ),
    );
  }
}