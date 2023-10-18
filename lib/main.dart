// ignore_for_file: dead_code

import 'dart:async';
import 'dart:io';
// import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grewal/api/data_list.dart';
import 'package:grewal/screens/add_support.dart';
import 'package:grewal/screens/answer_list.dart';

import 'package:grewal/screens/change_password.dart';
import 'package:grewal/screens/chapter_overview.dart';
import 'package:grewal/screens/chapter_select.dart';
import 'package:grewal/screens/chapters_list.dart';
import 'package:grewal/screens/create_mcq.dart';
import 'package:grewal/screens/create_mcq_new.dart';
import 'package:grewal/screens/create_mcq_subjective.dart';

import 'package:grewal/screens/create_ticket.dart';
import 'package:grewal/screens/crosswordgame.dart';
import 'package:grewal/screens/dashboard.dart';

import 'package:grewal/screens/home_page.dart';
import 'package:grewal/screens/institute_test_list.dart';
import 'package:grewal/screens/intro_screens.dart';
import 'package:grewal/screens/mcq_level_testing/mcq_level_test.dart';
import 'package:grewal/screens/mcq_level_testing/start_subjective_test.dart';
import 'package:grewal/screens/mcq_level_testing/subjective_test.dart';
import 'package:grewal/screens/mcq_level_testing/subjective_test_list.dart';
import 'package:grewal/screens/model_dash.dart';
import 'package:grewal/screens/model_test_paper_new.dart';
import 'package:grewal/screens/mtp_list.dart';
import 'package:grewal/screens/mts.dart';
import 'package:grewal/screens/notifications.dart';
import 'package:grewal/screens/olympiad/oly_test_list.dart';
import 'package:grewal/screens/olympiad/olympiad_performance.dart';
import 'package:grewal/screens/olympiad/review_test.dart';
import 'package:grewal/screens/olympiad/section_list.dart';
import 'package:grewal/screens/olympiad/start_test.dart';
import 'package:grewal/screens/olympiad/start_test_new.dart';
import 'package:grewal/screens/open_pdf.dart';
import 'package:grewal/screens/overall_performance.dart';
import 'package:grewal/screens/overall_performance_details.dart';
import 'package:grewal/screens/project.dart';
import 'package:grewal/screens/sample.dart';

import 'package:grewal/screens/settings.dart';
import 'package:grewal/screens/sign_otp_verification.dart';
import 'package:grewal/screens/sign_up.dart';
import 'package:grewal/screens/splash.dart';
import 'package:grewal/screens/static_screens/privacy_policy.dart';
import 'package:grewal/screens/static_screens/refund_policies.dart';
import 'package:grewal/screens/static_screens/t_c.dart';
import 'package:grewal/screens/subject_list.dart';
import 'package:grewal/screens/support_detail.dart';
import 'package:grewal/screens/support_list.dart';
import 'package:grewal/screens/test_correct.dart';
import 'package:grewal/screens/test_list.dart';
import 'package:grewal/screens/test_series.dart';
import 'package:grewal/screens/ticket_details.dart';
import 'package:grewal/screens/ticket_list.dart';
import 'package:grewal/screens/update_profile.dart';
import 'package:grewal/screens/videos.dart';
import 'package:grewal/screens/videos_screen/create_test.dart';
import 'package:grewal/screens/videos_screen/question_view.dart';
import 'package:grewal/screens/videos_screen/videos.dart';
import 'package:grewal/screens/videos_screen/videos_detail.dart';
import 'package:grewal/screens/view_performance.dart';
import 'package:grewal/screens/view_performance_new.dart';
import 'package:grewal/screens/view_test.dart';
import 'package:grewal/screens/work_flow.dart';
import 'package:grewal/services/Timer_Data.dart';
// import 'package:package_info/package_info.dart';

import 'package:page_transition/page_transition.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/reset_password.dart';
import 'screens/get_otp.dart';
import 'screens/login_with_logo.dart';
import 'screens/otp_verification.dart';
import 'screens/plan.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'screens/test_correct_new.dart';
import 'screens/view_test_new.dart';
// import 'package:responsive_framework/responsive_framework.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = new MyHttpOverrides();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyHttpOverrides extends HttpOverrides {
  // @override
  // HttpClient createHttpClient(SecurityContext context) {
  //   return super.createHttpClient(context)
  //     ..badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  // }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loggedIn = false;
  int id = 0;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  // static final facebookAppEvents = FacebookAppEvents();
  void initState() {
    super.initState();

    //  _checkLoggedIn();
  }

  Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

/*  _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _isLoggedIn = prefs.getBool('logged_in');
    if (_isLoggedIn == true) {
      setState(() {
        _loggedIn = _isLoggedIn;
      });
    } else {
      setState(() {
        _loggedIn = false;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xff017EFF, color);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Timer_Data>(
          create: (BuildContext context) {
            return Timer_Data();
          },
        ),
      ],
      child: MaterialApp(
          title: 'Grewal Conceptual Learning',
          navigatorObservers: <NavigatorObserver>[observer],
          theme: ThemeData(
            primarySwatch: colorCustom,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // builder: (context, widget) => ResponsiveWrapper.builder(
          //     BouncingScrollWrapper.builder(context, widget),
          //     maxWidth: 800,
          //     minWidth: 450,
          //     defaultScale: true,
          //     breakpoints: [
          //       ResponsiveBreakpoint.resize(450, name: MOBILE),
          //       // ResponsiveBreakpoint.autoScale(450, name: TABLET),
          //       // ResponsiveBreakpoint.resize(450, name: DESKTOP),
          //     ],
          //     background: Container(color: Color(0xFFF5F5F5))),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) {
            print("new " + settings.toString());
            switch (settings.name) {
              case '/splash':
                return PageTransition(
                  child: SplashScreen(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/intro-screens':
                return PageTransition(
                  child: IntroScreens(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/login-with-logo':
                return PageTransition(
                  child: LoginWithLogo(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/reset-password':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: RestPassword(
                    argument: obj,
                  ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/change-password':
                return PageTransition(
                  child: ChangePassword(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/get-otp':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: GetOTP(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/otp-verification':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: OTPVerification(
                    argument: obj,
                  ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/sign-otp-verification':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: SignOTPVerification(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/plan':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: MyPlan(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/sign-up':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: SignIn(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/dashboard':
                return PageTransition(
                  child: Dashboard(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/home-page':
                return PageTransition(
                  child: HomePage(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/settings':
                return PageTransition(
                  child: Settings(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/update-profile':
                return PageTransition(
                  child: UpdateProfile("yes"),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/chapters-list':
                return PageTransition(
                  child: ChapterList("yes", {}),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/chapter-overview':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ChapterOverview(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/create-mcq':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: CreateMCQ(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/create-mcq-new':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: CreateMCQ2(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/create-ticket':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: CreateTicket(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/test-list':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: TestList(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/ticket-list':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: TicketList(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/ticket-details':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: TicketDetails(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/test-correct-new':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: StartMCQ2(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/test-correct':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: StartMCQ(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/view-test-new':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ViewMCQ2(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/view-performance-new':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ViewPerformance2(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/test-correct':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: StartMCQ(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/view-test':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ViewMCQ(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/view-performance':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ViewPerformance(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/open-pdf':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: Viewer(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/sample':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ViewPerformanceChart(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/chapter-select':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ChapterListScreen(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/support-list':
                //  var obj = settings.arguments as Object;
                return PageTransition(
                  child: SupportList("yes"),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/support-detail':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: SupportOverview(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/add-support':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: AddSupport(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/overall-performance':
                return PageTransition(
                  child: OverAllPerformance(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/overall-performance-details':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: OverAllDetails(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/videos':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: VideosList(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/videos-detail':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: VideoDetail(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/privacy-policy':
                return PageTransition(
                  child: Privacy(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/refund-policies':
                return PageTransition(
                  child: Refund(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/t-c':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: TAndC(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/t-c':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: TAndC(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/mts':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: MTS(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/model-dash':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ModelDash(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/notifications':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: NotificationsPage(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/work-flow':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: AppFlow(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/institute-test-list':
                //var obj = settings.arguments as Object;
                return PageTransition(
                  child: InstituteTestList(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/oly-test-list':
                return PageTransition(
                  child: OlyTestList(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/section-list':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: SectionList(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/start-test-new':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: StartOlyMCQNEW(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/review-test':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: ReViewMCQ(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/project':
                // var obj = settings.arguments as Object;
                return PageTransition(
                  child: Project(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/mtp-list':
                // var obj = settings.arguments as Object;
                return PageTransition(
                  child: MTPList(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/answer-list':
                // var obj = settings.arguments as Object;
                return PageTransition(
                  child: AnswerList(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/olympiad-performance':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: OlympiadViewPerformance(argument: obj),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/question-view':
                return PageTransition(
                  child: QuestionView(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              case '/create-test':
                return PageTransition(
                  child: CreateQuestion(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/mcq-level-testing':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: MCQLevelTest(
                    argument: obj,
                  ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/subjective_test':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: StartSubjectiveTest(
                    argument: obj,
                  ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/create-subjective':
                // var obj = settings.arguments as Object;
                return PageTransition(
                  child: CreateSubjective(
                      // argument: obj,
                      ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/start-subjective-test':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: StartSubjective(
                    argument: obj,
                  ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/start-subjective-list':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: SubjectiveTestListGiven(
                    argument: obj,
                  ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/subject-list':
                return PageTransition(
                  child: SubjectList(
                      email_id: "",
                      mobile: '',
                      order_id: '',
                      payment: '',
                      total_test: '',
                      user_id: ''),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/cross-word-game':
                return PageTransition(
                  child: CrossWordGame(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/test-series':
                var obj = settings.arguments as Object;
                return PageTransition(
                  child: TestSeries(
                    argument: obj,
                  ),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/model-test-paper-new':
                // var obj = settings.arguments as Object;
                return PageTransition(
                  child: ModelTestPaperNewList(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;
              case '/videos-link':
                // var obj = settings.arguments as Object;
                return PageTransition(
                  child: VideosLink(),
                  type: PageTransitionType.leftToRight,
                  settings: settings,
                );
                break;

              default:
                return null;
            }
          },
          home: Scaffold(
            body: homeOrLog(),
          )),
    );
  }

  Widget homeOrLog() {
    // return FutureBuilder(
    // future: facebookAppEvents.getAnonymousId(),
    // builder: (context, snapshot) {
    //   final id = jsonDecode(snapshot.data.toString()) ?? '???';
    //   print('Anonymous ID: $id');
    return SplashScreen();
    // },
    // );
  }
}
