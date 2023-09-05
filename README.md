# supabase_test
This is a minimal flutter (desktop) app to reproduce an issue with supabase realtime.
https://github.com/supabase/supabase-flutter/issues/579

## Setup
To run this project, you need to create a `.env` file in the root directory with the following content:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_key

EMAIL=your_email_for_user_auth
PASSWORD=your_password_for_user_auth
```

You might need to edit the `supabase_api.dart` file to match your supabase table structure.

## Reproduce issue
To reproduce issue, run the app on MacOS desktop(others not tested yet) and let MacOS sleep for 
a while (at least 30 min) wake it up again. After that the logs should show several exceptions and 
the stream is not working anymore.

