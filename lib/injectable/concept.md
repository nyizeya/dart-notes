# injectable
injectable ဆိုတာ Flutter App တွေမှာ Dependency Injection (DI) အတွက် အသုံးများတဲ့ get_it package ကို ပိုမိုလွယ်ကူ စနစ်တကျ ရှိစေဖို့ Code Generation နည်းပညာနဲ့ ကူညီပေးတဲ့ Helper Package တစ်ခု ဖြစ်ပါတယ်။

get_it တစ်ခုတည်း သုံးပါက Class တွေ၊ Repositories တွေ၊ Blocs/ViewModels တွေ အများကြီးကို getIt.registerLazySingleton(...) သို့မဟုတ် getIt.registerFactory(...) ဆိုပြီး မိမိဘာသာ Manual လိုက် မှတ်ပုံတင် (Register) ရတာ ပျင်းစရာကောင်းပြီး မကြာခဏ အမှားပါတတ်ပါတယ်။ injectable ကတော့ Class ပေါ်မှာ Annotation (@injectable, @singleton) လေးတွေ ရေးပေးလိုက်ရုံနဲ့ လိုအပ်တဲ့ Registration Code များကို အလိုအလျောက် (Automate) ထုတ်လုပ်ပေးပါတယ်။

### ၁။ pubspec.yaml တွင် Packages များ ထည့်သွင်းခြင်း
injectable ကို သုံးဖို့အတွက် get_it နဲ့အတူ dev_dependencies ထဲမှာ Code Generator တွေကို ထည့်ပေးရပါမယ်။

```yaml
dependencies:
  flutter:
    sdk: flutter
  get_it: ^7.7.0
  injectable: ^2.5.0

dev_dependencies:
  build_runner: ^2.4.9
  injectable_generator: ^2.6.2
```

### ၂။ Initial Setup ပြုလုပ်ခြင်း
lib/injection.dart (သို့မဟုတ် lib/di.dart) ဆိုတဲ့ ဖိုင်တစ်ခု ဆောက်ပြီး get_it နဲ့ injectable ကို ချိတ်ဆက်ပေးရပါမယ်။

```dart
// lib/injection.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// build_runner run လိုက်ရင် ဒီဖိုင် ထွက်လာပါလိမ့်မည်
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();
```

ပြီးရင် main.dart မှာ အက်ပ် မပွင့်ခင် ဒီ function ကို လှမ်းခေါ်ပေးရပါမယ်:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(); // Dependency များကို Init လုပ်ခြင်း
  runApp(const MyApp());
}
```

### ၃။ အဓိက Annotations များ အသုံးပြုပုံ
(A) @injectable (Factory)
ခေါ်ယူလိုက်တိုင်း Instance အသစ် တစ်ခု ပြန်ပေးစေချင်တဲ့ Class တွေ (ဥပမာ - UI ViewModels/Blocs, Form Handlers) မှာ သုံးပါတယ်။

```dart
import 'package:injectable/injectable.dart';

@injectable
class AuthBloc {
  final UserRepository userRepository;

  // Dependency များကို Constructor ကနေ အလိုအလျောက် Inject လုပ်ပေးပါမည်
  AuthBloc(this.userRepository); 
}
```

(B) @lazySingleton သို့မဟုတ် @singleton
App တစ်ခုလုံးမှာ Instance တစ်ခုတည်း ပဲ ရှိစေချင်တဲ့ Class တွေ (ဥပမာ - Repositories, Services, Local Database Helpers) မှာ သုံးပါတယ်။

@lazySingleton: ပထမဆုံးအကြိမ် လှမ်းခေါ်မှသာ Instance ကို ဆောက်ပေးပါတယ် (Memory ပိုသက်သာသဖြင့် အသုံးများပါသည်)။

@singleton: App စပွင့်တာနဲ့ Instance ချက်ချင်း ဆောက်ပေးပါတယ်။

```dart
@lazySingleton
class UserRepository {
  final ApiClient apiClient;

  UserRepository(this.apiClient);
}
```

(C) @module (Third-Party Libraries များကို Register လုပ်ခြင်း)
Dio, SharedPreferences, http.Client စတဲ့ အပြင် Package က ပါလာပြီး ကိုယ်တိုင် ပြင်ဆင်ခွင့်မရှိတဲ့ Class များကို Register လုပ်ချင်ပါက @module ကို အသုံးပြုရပါတယ်။

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  // Async ဖြစ်သော Async Singleton များအတွက် @preResolve ကို သုံးနိုင်ပါသည်
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
```

***မှတ်ချက်: @preResolve ပါနေပါက injection.dart ထဲက configureDependencies() ကို Future<void> အဖြစ် ပြောင်းပေးပြီး await getIt.init(); ဆိုပြီး ပြင်ပေးရပါမည်။***

### ၄။ Code Generation Run ခြင်း
Annotation တွေ ရေးပြီးပါက Terminal တွင် အောက်ပါ Command ကို Run ပေးရပါမည်:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
# သို့မဟုတ်
dart run build_runner build --delete-conflicting-outputs
```

ဒီ Command က lib/injection.config.dart ဖိုင်ကို အလိုအလျောက် ဆောက်ပေးသွားမှာ ဖြစ်ပြီး get_it ထဲမှာ လိုအပ်တဲ့ Registration တွေ အားလုံးကို သူ့ဟာသူ ဖြည့်စွက်ပေးသွားပါလိမ့်မည်။

### ၅။ App ထဲတွင် လှမ်းခေါ် အသုံးပြုပုံ
getIt ကို သုံးပြီး လိုအပ်တဲ့ Instance ကို လွယ်ကူစွာ လှမ်းယူနိုင်ပါပြီ:

```dart
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // getIt ထဲမှ ရယူခြင်း
    final authBloc = getIt<AuthBloc>();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => authBloc.logout(),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
```

#### injectable ကို ဘာကြောင့် သုံးသင့်သလဲ။
```
Boilerplate Code လျှော့ချပေးခြင်း: getIt.registerLazySingleton<Repository>(() => RepositoryImpl(getIt<ApiClient>())) စသဖြင့် ရှည်လျားစွာ ရေးစရာ မလိုတော့ပါ။

Auto Dependency Resolution: Constructor ထဲမှာ Parameter အသစ် တိုးလိုက်တာနဲ့ injectable က အလိုအလျောက် အချင်းချင်း ချိတ်ဆက်ပေးသွားပါတယ်။

Environments & Named Instances ပံ့ပိုးခြင်း: Dev, Staging, Production စတဲ့ Environment ပေါ်မူတည်ပြီး Base URL/Services တွေကို @Environment('dev') နဲ့ ခွဲထုတ်ရလွယ်ကူပါတယ်။
```