package cn.leancloud.leanstoragegettingstarted;

import android.app.Application;

import com.avos.avoscloud.AVOSCloud;

/**
 * Created by BinaryHB on 16/9/13.
 */
public class GettingStartedApp extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
    AVOSCloud.initialize(this,"你的 App ID", "你的 App Key");
    AVOSCloud.setDebugLogEnabled(true);
  }
}
