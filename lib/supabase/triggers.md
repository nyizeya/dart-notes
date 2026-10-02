# Triggers
PostgreSQL Triggers (Supabase တွင် အသုံးများသော) ဆိုသည်မှာ Database Table တစ်ခုခုတွင် အချက်အလက်များ INSERT, UPDATE, သို့မဟုတ် DELETE ပြုလုပ်သည့်အခါ လုံခြုံရေး သို့မဟုတ် လုပ်ငန်းစဉ်များအလိုက် Automatically စတင် အလုပ်လုပ်ပေးသည့် Function တစ်ခု ဖြစ်ပါသည်။

### Trigger တစ်ခု တည်ဆောက်ပုံ (၂ ဆင့်)
Postgres/Supabase တွင် Trigger ပြုလုပ်ရန် အဆင့် (၂) ဆင့် လိုအပ်ပါသည်။

```
    1. Trigger Function ရေးသားခြင်း - အလိုအလျောက် ခေါ်ယူ လုပ်ဆောင်ပေးမည့် Logic ကို ရေးသားခြင်း။

    2. Trigger ဖန်တီးခြင်း - မည်သည့် Table ၏ မည်သည့် Event (INSERT/UPDATE/DELETE) တွင် ထို Function ကို ခေါ်ယူမည်ဖြစ်ကြောင်း သတ်မှတ်ပေးခြင်း။
```

### Example 1: User အသစ် Login ဝင်လာပါက Profile Table တွင် အလိုအလျောက် Data သွားထည့်ခြင်း
Supabase ၏ auth.users Table တွင် User အသစ်တစ်ယောက် Sign Up လုပ်လိုက်သည်နှင့် မိမိတို့၏ Public profiles Table ထဲသို့ User Profile အလိုအလျောက် စာရင်းဝင်သွားစေရန် ပြုလုပ်သည့် အသုံးအများဆုံး ဥပမာ ဖြစ်ပါသည်။

Demo Tables
```sql
-- Public Profiles Table ဖန်တီးခြင်း
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  avatar_url TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Step 1: Trigger Function ရေးသားခြင်း
***မှတ်ချက်: Trigger function များသည် အမြဲတမ်း RETURNS TRIGGER ဖြစ်ရမည်ဖြစ်ပြီး NEW သို့မဟုတ် OLD ဟူသော Special Variable များကို အသုံးပြုနိုင်ပါသည်။***

```
    NEW: INSERT သို့မဟုတ် UPDATE တွင် ဝင်ရောက်လာသော Row အသစ်၏ Data

    OLD: UPDATE သို့မဟုတ် DELETE တွင် ထိခိုက်သွားသော Row အဟောင်း၏ Data
```

```sql
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Step 2: Trigger binding ပြုလုပ်ခြင်း
```sql
-- auth.users table ထဲသို့ Row အသစ် ရောက်လာတိုင်း Function ကို ခေါ်မည်
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
```

