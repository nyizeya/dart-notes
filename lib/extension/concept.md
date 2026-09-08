# Extension
Dart မှာ Extension Methods (သို့မဟုတ် Extension) ဆိုတာ မိမိတို့ မပိုင်ဆိုင်တဲ့ သို့မဟုတ် ပြင်ဆင်ခွင့်မရှိတဲ့ Existing Library/Class တွေထဲကို Code (Function သို့မဟုတ် Property) အသစ်တွေ အပြင်ကနေ အလွယ်တကူ ထပ်ပေါင်းထည့်ပေးတဲ့ နည်းလမ်း ဖြစ်ပါတယ်။

### 1. What (Extension ဆိုတာဘာလဲ)
Dart 2.7 မှာ စတင်မိတ်ဆက်ခဲ့တဲ့ Feature တစ်ခုဖြစ်ပါတယ်။ String, int, List သို့မဟုတ် Flutter ရဲ့ BuildContext, Widget စတဲ့ Class တွေကို Subclass (Inheritance) မလုပ်ဘဲ၊ မူရင်း Class ရဲ့ Code ကိုလည်း ဝင်မပြင်ဘဲ Function အသစ်တွေ သွားရောက် ကပ်ပေးလိုက်တာ ဖြစ်ပါတယ်။

### 2. Why (ဘာကြောင့် သုံးရတာလဲ)
Helper Method များကို သန့်ရှင်းစေရန်: StringUtils.capitalize(str) လို့ Helper Class တွေဆောက်ပြီး ခေါ်မယ့်အစား str.capitalize() လို့ တိုက်ရိုက်ခေါ်သုံးနိုင်အောင် ကူညီပေးပါတယ်။

Code Readability ကောင်းမွန်စေရန်: Code ရေးရတာ ပိုမိုရှင်းလင်းပြီး သဘာဝကျကျ ခေါ်ယူအသုံးပြုနိုင်စေပါတယ်။

3rd-Party Library များကို Function ပေါင်းထည့်ရန်: External Package တွေထဲက ပြင်လို့မရတဲ့ Class တွေကို မိမိ App နဲ့ ကိုက်ညီမယ့် Helper Function တွေ ထပ်တိုးပေးနိုင်ပါတယ်။

### 3. How (ဘယ်လို ရေးသား/အသုံးပြုမလဲ)
Extension ကို extension <Name> on <Type> ဆိုတဲ့ Syntax နာမည်နဲ့ ရေးသားပါတယ်။

#### Example 1: String မှာ စာလုံးကြီး ပထမစာလုံး ပြောင်းပေးသည့် Extension

```dart
// ၁။ Extension ကို ကြေညာခြင်း
extension StringExtension on String {
  // String တန်ဖိုးရဲ့ ပထမဆုံး စာလုံးကို စာလုံးကြီး (Capital) ပြောင်းပေးမည့် Function
  String toCapitalized() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}

void main() {
  String name = "mg mg";

  // ၂။ မူရင်း String Class ရဲ့ Function လိုမျိုး တိုက်ရိုက် ခေါ်သုံးခြင်း
  print(name.toCapitalized()); // Output: Mg mg
}
```

#### Example 2: Getter Property အနေဖြင့် ရေးသားခြင်း
```dart
extension NumberParsing on String {
  // String ကနေ int အဖြစ် ပြောင်းရလွယ်အောင် Getter ရေးခြင်း
  int get toInt => int.parse(this);
}

void main() {
  String age = "25";
  
  // Getter အနေဖြင့် ခေါ်သုံးခြင်း
  int number = age.toInt; 
  print(number + 5); // Output: 30
}
```

### 4. Where (ဘယ်လိုနေရာတွေမှာ သုံးတာများလဲ)
Flutter Context Utilities များတွင်:
Navigator သို့မဟုတ် MediaQuery ရေးရတာ ရှည်လျားလွန်းသည့်အခါ BuildContext ပေါ်မှာ Extension ရေးလေ့ရှိပါတယ်။

```dart
extension ContextUtils on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  void push(Widget page) => Navigator.push(this, MaterialPageRoute(builder: (_) => page));
}

// အသုံးပြုပုံ: context.width သို့မဟုတ် context.push(NextPage())
```

- Data Formatting / Validation များတွင်:
Email/Phone format စစ်တာတွေ (email.isValidEmail) သို့မဟုတ် DateTime တန်ဖိုးတွေကို Format လုပ်တာတွေ (dateTime.toHumanReadable()) မှာ သုံးပါတယ်။

- Type Conversion များတွင်:
String ကနေ Color/DateTime ပြောင်းတာ၊ int ကနေ Duration ပြောင်းတာ စတဲ့ ပြောင်းလဲမှုတွေမှာ သုံးပါတယ်။ (5.seconds -> Duration(seconds: 5))


### More Examples
Flutter ရဲ့ BuildContext မှာ Extension ရေးထားရင် UI ရေးတဲ့အခါ MediaQuery နဲ့ Navigator စတာတွေကို ရှည်ရှည်ဝေးဝေး ရေးစရာမလိုဘဲ Code ကို ပိုမိုတိုတောင်း သန့်ရှင်းသွားစေပါတယ်။

အသုံးများတဲ့ BuildContext Extensions နမူနာများကို အောက်ပါအတိုင်း လေ့လာနိုင်ပါတယ် -

1. Navigation Utilities (စာမျက်နှာ ကူးပြောင်းခြင်း)
မကြာခဏ ရေးရလေ့ရှိတဲ့ Navigator.of(context).push(...) နေရာမှာ Extension သုံးပြီး တိုတိုတိုတောင်းတောင်း ရေးသားနိုင်ပါတယ်။

```dart
extension NavigationUtils on BuildContext {
  // စာမျက်နှာ အသစ်သို့ သွားရန်
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // လက်ရှိ စာမျက်နှာကို ပိတ်ပြီး စာမျက်နှာ အသစ်သို့ သွားရန်
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // စာမျက်နှာမှ ပြန်ထွက်ရန် (Back ပြန်လှည့်ရန်)
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
```

2. Screen Size & Responsiveness (မျက်နှာပြင် အရွယ်အစား စစ်ဆေးခြင်း)
MediaQuery.of(context).size.width လို့ အမြဲတမ်း ရှည်ရှည်ခေါ်နေရတာကို မလိုတော့ဘဲ context.width ဆိုပြီး တိုက်ရိုက် ခေါ်သုံးနိုင်ပါတယ်။

```dart
extension ResponsiveUtils on BuildContext {
  // Screen Width နဲ့ Height
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  // Screen Orientation (ဒေါင်လိုက်/အလျားလိုက်)
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  // Screen Responsive အမျိုးအစား စစ်ဆေးရန်
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;
}
```

3. Theme & Colors (ဒီဇိုင်းနှင့် အရောင်များ ရယူခြင်း)
App ရဲ့ Dark Mode / Light Mode သို့မဟုတ် Primary Color များကို အလွယ်တကူ ခေါ်ယူနိုင်ပါတယ်။

```dart
extension ThemeUtils on BuildContext {
  // Theme Data များကို ရယူခြင်း
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Dark Mode ဟုတ်မဟုတ် စစ်ဆေးခြင်း
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
```

4. SnackBar (အကြောင်းကြားစာ ပြသခြင်း)
Snackbar ပြသချင်တဲ့အခါ ScaffoldMessenger.of(context).showSnackBar(...) ကို အလွယ်ခေါ်သုံးနိုင်ပါတယ်။

```dart
extension SnackBarUtils on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

**အသုံးပြုပုံ နှိုင်းယှဉ်ချက် (Usage Comparison)**
*Extension မသုံးမီ (Before Extension):*

```dart
// Navigation
Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailsPage()));

// Screen Size & Theme
double screenWidth = MediaQuery.of(context).size.width;
Color primaryColor = Theme.of(context).colorScheme.primary;

// SnackBar
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Saved successfully!')),
);
```

*Extension သုံးပြီးနောက် (After Extension):*

```dart
// Navigation
context.push(DetailsPage());

// Screen Size & Theme
double screenWidth = context.width;
Color primaryColor = context.colorScheme.primary;

// SnackBar
context.showSnackBar('Saved successfully!');
```