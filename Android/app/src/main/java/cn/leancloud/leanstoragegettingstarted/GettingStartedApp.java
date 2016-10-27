package cn.leancloud.leanstoragegettingstarted;

import android.app.Application;

import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.AVAnalytics;

/**
 * Created by BinaryHB on 16/9/13.
 */
public class GettingStartedApp extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
    AVOSCloud.initialize(this,"OLoj899IwHYi787ClrImlr3k-gzGzoHsz", "gkz35mRTqTE2aqwp7dEr5uEE");
    AVOSCloud.setDebugLogEnabled(true);
    AVAnalytics.enableCrashReport(this, true);
  }
}
