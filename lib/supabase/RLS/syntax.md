# Supabase RLS Policy Syntax

### 1. TO authenticated
လုပ်ဆောင်ချက်: Policy မည်သည့် Database Role (သုံးစွဲသူ အုပ်စု) နှင့် သက်ဆိုင်သည်ကို သတ်မှတ်ပေးခြင်း ဖြစ်သည်။

```
    authenticated Role: Supabase Auth မှတစ်ဆင့် Login ဝင်ထားသော User များကို ဆိုလိုသည်။

    anon Role: Login မဝင်ရသေးသော Public / Anonymous User များကို ဆိုလိုသည်။

    public Role: Login ဝင်ထားသည်ဖြစ်စေ၊ မဝင်ထားသည်ဖြစ်စေ User အားလုံးနှင့် သက်ဆိုင်သည်။ (TO မရေးပါက Default အနေဖြင့် public ဖြစ်သွားပါမည်)။
```

```sql
-- Login ဝင်ထားသူများသာ ခွင့်ပြုမည်
CREATE POLICY "Allow authenticated users"
ON todos 
FOR SELECT
TO authenticated
USING (true);
```

### 2. USING
လုပ်ဆောင်ချက်: Database ထဲတွင် ရှိနှင့်ပြီးသား Row (အချက်အလက်) များကို ဖတ်ရှုခွင့်၊ ပြင်ဆင်ခွင့် သို့မဟုတ် ဖျက်ဆီးခွင့် ရှိမရှိ စစ်ဆေးသည့် အခြေအနေ (Condition) ဖြစ်သည်။

```
    မည်သည့်နေရာတွင် သုံးသနည်း: SELECT, UPDATE, DELETE operations များတွင် သုံးသည်။

    အလုပ်လုပ်ပုံ: Query မပစ်မီ/အချက်အလက် မထုတ်မီ Database ထဲမှ Row တစ်ခုချင်းစီ၏ Data ကို စစ်ဆေးသည်။ true ထွက်မှသာ ထို Row ကို ကြည့်/ပြင်/ဖျက် ခွင့်ပြုသည်။
```

```sql
-- တောင်းဆိုထားသော Row ၏ user_id သည် လက်ရှိ Login ဝင်ထားသူ၏ ID နှင့် တူမှသာ ပြသမည်
CREATE POLICY "View own data"
ON todos 
FOR SELECT
TO authenticated
USING ((SELECT auth.uid()) = user_id);
```

***မှတ်ချက်: USING သည် Database ထဲတွင် လက်ရှိ ရှိနေပြီးသား Data ကို စစ်ဆေးခြင်း ဖြစ်သည်။***


### 3. WITH CHECK
လုပ်ဆောင်ချက်: Database ထဲသို့ အသစ် ဝင်ရောက်လာမည့် သို့မဟုတ် ပြင်ဆင်လိုက်သည့် Data သည် သတ်မှတ်ထားသော စည်းမျဉ်းနှင့် ကိုက်ညီမှု ရှိမရှိ စစ်ဆေးခြင်း ဖြစ်သည်။

```
    မည်သည့်နေရာတွင် သုံးသနည်း: INSERT နှင့် UPDATE operations များတွင် သုံးသည်။

    အလုပ်လုပ်ပုံ: User ပို့လိုက်သော Data အသစ်ကို Database ထဲသို့ မသိမ်းဆည်းမီ စစ်ဆေးသည်။ false ထွက်ပါက Data ထည့်သွင်းခြင်း/ပြင်ဆင်ခြင်းကို ငြင်းပယ် (Reject) လိုက်မည် ဖြစ်သည်။
```

```sql
-- အသစ်ထည့်မည့် Todo ၏ user_id သည် မိမိ၏ ID အမှန်ဖြစ်မှသာ Insert လုပ်ခွင့်ပြုမည်
CREATE POLICY "Insert own data"
ON todos FOR INSERT
TO authenticated
WITH CHECK ((SELECT auth.uid()) = user_id);
```

### USING နှင့် WITH CHECK ၏ ကွာခြားချက် (UPDATE Example)
UPDATE လုပ်သည့်အခါ နှစ်မျိုးလုံးကို တွဲ၍ အသုံးပြုလေ့ရှိပါသည်။

```sql
CREATE POLICY "Update own todos"
ON todos FOR UPDATE
TO authenticated
USING ((SELECT auth.uid()) = user_id)        -- ၁။ ပြင်ချင်သော Row သည် မိမိပိုင် Row ဟုတ်မဟုတ် စစ်သည်
WITH CHECK ((SELECT auth.uid()) = user_id);  -- ၂။ ပြင်ပြီးသွားသော Data တွင်လည်း မိမိ ID ကို အခြားသူ ID သို့ မပြောင်းလဲစေရန် စစ်သည်
```

```
____________________________________________________________________________________________________________________
|Syntax       |                   ဘယ်အချိန်မှာ အလုပ်လုပ်လဲ                       |          အဓိက သုံးသည့် Operation  | 
|USING,       |   Database ထဲရှိ လက်ရှိ Data ကို မထိခိုက်မီ/မထုတ်မီ စစ်ဆေးသည်       |       "SELECT, UPDATE, DELETE"    | 
|WITH CHECK,  |   Database ထဲသို့ ရောက်လာမည့် Data အသစ် ကို စစ်ဆေးသည်          |            "INSERT, UPDATE"       |
____________________________________________________________________________________________________________________
```