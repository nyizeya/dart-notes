# SECURITY DEFINER နှင့် SECURITY INVOKER
Supabase (PostgreSQL) Trigger Function များတွင် SECURITY DEFINER နှင့် SECURITY INVOKER သည် Function တစ်ခု အလုပ်လုပ်သည့်အခါ "မည်သူ့ အခွင့်အရေး (Permissions) ဖြင့် အလုပ်လုပ်မည်နည်း" ဆိုသည်ကို သတ်မှတ်ပေးသည့် လုံခြုံရေး ဆိုင်ရာ သဘောတရားများ ဖြစ်ကြသည်။

### ၁။ SECURITY DEFINER နှင့် SECURITY INVOKER ကွာခြားချက်

```
    SECURITY INVOKER (Default)
    Function ကို လှမ်းခေါ်လိုက်သည့် အသုံးပြုသူ (User/Role) ၏ Permission ဖြင့် အလုပ်လုပ်မည်။

    ခေါ်ယူသူ၏ RLS Policies များနှင့် ငြှိစွန်းမည် (ခေါ်ယူသူတွင် RLS Access မရှိပါက ပျက်စီးမည်)။

    ပုံမှန် Logic များ၊ ခေါ်ယူသည့် User ၏ RLS တားမြစ်ချက်အတိုင်း မကင်းလွတ်စေချင်သည့် အခါ။
```

```
    SECURITY DEFINER
    Function ကို ဖန်တီးထားသူ (Owner/Admin) ၏ Permission ဖြင့် အလုပ်လုပ်မည်။

    Function တည်ဆောက်သူ (Owner) ၏ Access Level အတိုင်း အလုပ်လုပ်မည် ဖြစ်၍ RLS ကို ကျော်လွှား (Bypass) လုပ်နိုင်သည်။

    User အသစ်ဝင်လာ၍ Profile Table ထဲ အလိုအလျောက် Data သွားထည့်ပေးခြင်း သို့မဟုတ် Admin သာ လုပ်နိုင်သည့် လုပ်ဆောင်ချက်များ။
```


### ၂။ RLS ကို ဘယ်လို ကျော်လွှား (Bypass) သလဲ။
ဥပမာအားဖြင့် profiles Table တွင် "မိမိ ပိုင်ဆိုင်သော Profile ကိုသာ Insert / Select / Update လုပ်ခွင့်ရှိသည်" ဆိုသည့် RLS ရေးထားသည် ဆိုပါစို့။

User အသစ်တစ်ယောက် Sign Up လုပ်လိုက်သည့်အခါ auth.users Table သို့ Data ရောက်သွားမည် ဖြစ်သည်။ ထိုအခါ Trigger သည် public.profiles Table ထဲသို့ Data သွားထည့်ရန် ကြိုးစားပါမည်။

SECURITY INVOKER သုံးပါက ဖြစ်လာမည့် ပြဿနာ

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER; -- (သို့မဟုတ် ဘာမှ မရေးပါက Default သည် INVOKER ဖြစ်သည်)
```

```
    အလုပ်လုပ်ပုံ: Trigger သည် Sign Up လုပ်ခါစ User အသစ်၏ Role (anon သို့မဟုတ် authenticated) ဖြင့် profiles Table ထဲသို့ Data သွားထည့်ရန် ကြိုးစားမည်။

    ရလဒ်: profiles Table ၏ RLS စည်းမျဉ်းအရ ထို User ၏ Session မတည်ဆောက်ရသေးသဖြင့် profiles Table တွင် INSERT လုပ်ပိုင်ခွင့်မရှိဘခံရမည်ဖြစ်ပြီး Trigger Failure Error (RLS Violation) တက်သွားပါမည်။
```

SECURITY DEFINER ဖြင့် RLS ကို ကျော်လွှားပုံ

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; -- Owner အခွင့်အရေးဖြင့် ခွင့်ပြုပေးလိုက်သည်
```

```
    အလုပ်လုပ်ပုံ: SECURITY DEFINER ဟု ရေးလိုက်ပါက ထို Function သည် Sign Up လုပ်သူ၏ Permission ဖြင့် မဟုတ်တော့ဘဲ၊ ထို Function ကို ဖန်တီးခဲ့သည့် Database Owner (Superuser / Postgres Role) ၏ အခွင့်အရေးဖြင့် အလုပ်လုပ်သွားမည်။

    ရလဒ်: Superuser တွင် RLS Limitations များ မရှိသည့်အတွက် profiles Table ထဲသို့ RLS ကို ကျော်လွှားကာ Data အောင်မြင်စွာ သွားရောက် သိမ်းဆည်းနိုင်သွားမည် ဖြစ်သည်။
```

### ၃။ SECURITY DEFINER သုံးရာတွင် သတိထားရမည့် လုံခြုံရေး အချက်များ (Best Practices)
SECURITY DEFINER သည် Admin Permission ဖြင့် အလုပ်လုပ်သွားသောကြောင့် သတိမထားပါက Security Hole (လုံခြုံရေး ဟာကွက်) ဖြစ်သွားနိုင်သည်။

၁။ search_path ကို Explicitly ရေးပါ:
Search Path ကို ပုံသေ သတ်မှတ်ခြင်း.
မသမာသူများက Schema နမည်တူ တုပ၍ Query ကို လှည့်စားခြင်းမှ ကာကွယ်ရန် SET search_path = public ကို ထည့်သွင်းပေးရပါမည်။

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;
```