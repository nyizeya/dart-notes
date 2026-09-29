# Deep Link ဆိုတာ ဘာလဲ။
Deep Link ဆိုတာ မိုဘိုင်းဖုန်းထဲက App တစ်ခုကို ဖွင့်ရုံတင် မဟုတ်ဘဲ App ရဲ့ အတွင်းဘက်မှာ ရှိတဲ့ သီးသန့် စာမျက်နှာ (Specific Screen) ဆီ တိုက်ရိုက် ရောက်ရှိသွားအောင် ချိတ်ဆက်ပေးတဲ့ လင့်ခ်ဖြစ်ပါတယ်။

ဥပမာ: မိတ်ဆွေက Viber/Telegram ထဲမှာ သူငယ်ချင်းတစ်ယောက် ပို့လိုက်တဲ့ Shopping Link ကို နှိပ်လိုက်တဲ့အခါ Browser သို့ မသွားဘဲ Shopee သို့မဟုတ် Lazada App ပွင့်လာပြီး အဲဒီ ပစ္စည်းအရောင်း စာမျက်နှာဆီ တိုက်ရိုက် ရောက်သွားခြင်းမျိုး ဖြစ်ပါတယ်။

### Deep Link အမျိုးအစား (၃) မျိုး
#### 1. Custom Scheme Deep Links (URI Schemes)
App တီထွင်သူက ကိုယ်ပိုင် Protocol သတ်မှတ်ထားသော လင့်ခ်ဖြစ်ပါတယ်။

Format: myapp://products/123 သို့မဟုတ် wealthtrack://liability/5

အားနည်းချက်: ဖုန်းထဲမှာ App သွင်းမထားပါက လင့်ခ်က ဘာမှ အလုပ်လုပ်မည် မဟုတ်ဘဲ Error တက်သွားပါမည်။

#### 2. App Links (Android) / Universal Links (iOS)
Standard Web URL (https://) ပုံစံကိုပဲ သုံးထားပြီး Operating System က အက်ပ်ရှိမရှိ စစ်ဆေးပေးသော စနစ်ဖြစ်ပါတယ်။

Format: [https://example.com/products/123](https://example.com/products/123)

အလုပ်လုပ်ပုံ:

App ရှိရင် -> App အတွင်းမှ စာမျက်နှာ သို့ တိုက်ရိုက် ရောက်မည်။

App မရှိရင် -> Web Browser တွင် ဝဘ်ဆိုက်အဖြစ် ပွင့်မည်။

#### 4. Deferred Deep Links
App မရှိသေးပါက Play Store / App Store သို့ လမ်းညွှန်ပေးပြီး၊ အသုံးပြုသူက App ကို Download ဆွဲပြီး စတင်ဖွင့်လိုက်သည်နှင့် မူလ နှိပ်ခဲ့သော စာမျက်နှာဆီ တိုက်ရိုက် ပို့ဆောင်ပေးသည့် နည်းပညာဖြစ်ပါတယ်။


## Flutter App တွင် Deep Link အသုံးပြုပုံ
Flutter Project များတွင် Deep Link စီမံရန် go_router သို့မဟုတ် app_links package ကို အသုံးများပါတယ်။

```dart
// go_router သုံးပြီး URL Path များကို App Screen နှင့် Mapping လုပ်ပုံ
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/liability/:id', // https://example.com/liability/102
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return LiabilityDetailScreen(id: id);
      },
    ),
  ],
);
```