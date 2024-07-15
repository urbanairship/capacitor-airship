package com.example.plugin;

import android.app.Application;

import com.urbanairship.Predicate;
import com.urbanairship.UAirship;
import com.urbanairship.messagecenter.Message;
import com.urbanairship.messagecenter.MessageCenter;

public class CustomApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

        UAirship.shared(airship -> MessageCenter.shared().setPredicate((Predicate<Message>) message -> {
            String messageUser = message.getExtras().getString("named_user");
            if (messageUser == null) {
                return true;
            }
            return messageUser.equals(airship.getContact().getNamedUserId());
        }));
    }
}
