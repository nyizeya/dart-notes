# Supabase Row Level Security
Supabase RLS (Row Level Security) ဆိုတာ Database ထဲက Row (အကြောင်းအရာ) တစ်ခုချင်းစီကို ဘယ်သူတွေ ကြည့်ရှု၊ ပြင်ဆင်၊ သို့မဟုတ် ဖျက်ပစ်နိုင်လဲဆိုတာကို စည်းမျဉ်း (Policy) တွေနဲ့ ထိန်းချုပ်ပေးတဲ့ Postgres ရဲ့ လုံခြုံရေး စနစ်ဖြစ်ပါတယ်။   

Supabase မှာ Backend Code သီးသန့် မရေးဘဲ Frontend ကနေ Database ဆီ တိုက်ရိုက် Query လှမ်းပို့လေ့ရှိတဲ့အတွက် RLS ကို မဖြစ်မနေ အသုံးပြုဖို့ လိုအပ်ပါတယ်။

### Demo Table ပြုလုပ်ခြင်း
ဥပမာအဖြစ် todos Table တစ်ခု တည်ဆောက်ပါမည်။ အသုံးပြုသူ (User) တစ်ယောက်စီသည် မိမိကိုယ်ပိုင် Todo ကိုသာ မြင်ရ/ပြင်နိုင်ရမည်ဖြစ်သည်။   

```sql
CREATE TABLE todos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  task TEXT NOT NULL,
  is_complete BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Step 1: Row Level Security (RLS) ကို ဖွင့်ခြင်း (Enable လုပ်ခြင်း)
Table တည်ဆောက်ပြီးပါက RLS ကို စတင်ဖွင့်ရပါမည်။ RLS ကို ဖွင့်လိုက်သည်နှင့် မူလအတိုင်း ဘာ Access မှ ရတော့မည် မဟုတ်ပါ (Policies ရေးပေးမှသာ ခွင့်ပြုပါမည်)။   

```sql
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;
```

### Step 2: RLS Policies (စည်းမျဉ်းများ) ရေးဆွဲခြင်း
Supabase ၏ auth.uid() Function သည် လက်ရှိ Login ဝင်ထားသော User ၏ ID ကို ထုတ်ပေးပါသည်။ ၎င်းကို သုံး၍ စည်းမျဉ်းများ သတ်မှတ်နိုင်သည်။

#### 1.1. SELECT (စာရင်း ကြည့်ရှုခွင့်):
မိမိပိုင်ဆိုင်သော Task များကိုသာ ကြည့်ရှုခွင့်ပြုခြင်း. Login ဝင်ထားသူသည် မိမိ user_id နှင့် ကိုက်ညီသော todos များကိုသာ ပြသပေးမည်။

```sql
CREATE POLICY "Users can view their own todos"
ON todos
FOR SELECT
TO authenticated
USING ((SELECT auth.uid()) = user_id);
```

#### 2.2. INSERT (အချက်အလက် အသစ်ထည့်ခွင့်):
မိမိ Account ID ဖြင့်သာ Todo အသစ်ဖန်တီးစေခြင်း. WITH CHECK စည်းမျဉ်းကို အသုံးပြု၍ အခြားသူ၏ user_id ဖြင့် Data မသမာ ထည့်သွင်းခြင်းကို တားဆီးသည်။

```sql
CREATE POLICY "Users can create their own todos"
ON todos
FOR INSERT
TO authenticated
WITH CHECK ((SELECT auth.uid()) = user_id);
```

#### 3.3. UPDATE (အချက်အလက် ပြင်ဆင်ခွင့်):
မိမိ၏ Todo များကိုသာ ပြင်ဆင်ခွင့်ပြုခြင်း.USING ဖြင့် ပြင်ဆင်မည့် Row ကို စစ်ဆေးပြီး၊ WITH CHECK ဖြင့် ပြင်ဆင်ပြီးသွားသော Data တွင်လည်း မိမိ ID သာ ဖြစ်နေစေရန် စစ်ဆေးသည်။


```sql
CREATE POLICY "Users can update their own todos"
ON todos
FOR UPDATE
TO authenticated
USING ((SELECT auth.uid()) = user_id)
WITH CHECK ((SELECT auth.uid()) = user_id);
```

#### 4. DELETE (ဖျက်ဆီးခွင့်)
မိမိ Todo ကိုသာ ဖျက်ဆီးခွင့်ပြုခြင်း

```sql
CREATE POLICY "Users can delete their own todos"
ON todos
FOR DELETE
TO authenticated
USING ((SELECT auth.uid()) = user_id);
```

### အဓိက မှတ်သားရန် အချက်များ
```
    Dashboard မှ သုံးစွဲနည်း: Supabase Dashboard ၏ Table Editor > Policies သို့သွား၍ "New Policy" ကို နှိပ်ပြီး Visual UI အဖြစ်လည်း စည်းမျဉ်းများ ဖန်တီးနိုင်သည်။   

    Performance Tip: Policy များ ရေးသားရာတွင် auth.uid() = user_id အစား (SELECT auth.uid()) = user_id ဟု ရေးသားခြင်းက PostgreSQL ကို Function အကြိမ်ကြိမ် ခေါ်ယူခြင်းမှ သက်သာစေပြီး Query ကို ပိုမို လျင်မြန်စေပါသည်။   
    
    Service Role Key: Server-side သို့မဟုတ် Admin အလုပ်များအတွက် သုံးသော service_role key သည် RLS စည်းမျဉ်းများကို ပိုင်ဆိုင်မှုမလိုဘဲ ကျော်လွန် (Bypass) လုပ်နိုင်သည်။   
```