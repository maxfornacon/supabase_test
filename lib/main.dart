import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stacked/stacked.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/services/service_locator.dart';
import 'package:supabase_test/view_models/home_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  /// Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  // Email and password login
  AuthResponse response = await Supabase.instance.client.auth.signInWithPassword(
    email: dotenv.env['EMAIL']!,
    password: dotenv.env['PASSWORD']!,
  );
  // print(response);
  setupGetIt();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var channel = Supabase.instance.client
        .channel('notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'a_testtenant',
          table: 'notifications',
          callback: (payload) {
            print('Change received: ${payload.toString()}');
            if (payload.errors != null && payload.errors.isNotEmpty) {
              payload.errors.forEach((element) {
                print('Error: ${element.message}');
              });
            }
          },
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder(
                  stream: Supabase.instance.client
                      .schema('a_testtenant')
                      .from('notifications')
                      .stream(primaryKey: ['id'])
                      .eq('employee_id', '9418ce33-6349-45aa-895e-78e4423155dc'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.length.toString());
                    } else {
                      if (snapshot.error != null) {
                        print('ERRROR: ${snapshot.error.toString()}');
                      }
                      return const Text('No data');
                    }
                  }
                ),
                const Text(
                  'Number of Notifications:',
                ),
                Text(
                  '${model.notifications.length}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
