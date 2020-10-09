package cn.leancloud.leanstoragegettingstarted;

import android.app.Application;

import cn.leancloud.AVLogger;
import cn.leancloud.AVOSCloud;


/**
 * Created by BinaryHB on 16/9/13.
 */
public class GettingStartedApp extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
    //开启调试日志
    AVOSCloud.setLogLevel(AVLogger.Level.DEBUG);
    AVOSCloud.initialize(this,"OLoj899IwHYi787ClrImlr3k-gzGzoHsz", "gkz35mRTqTE2aqwp7dEr5uEE","https://oloj899i.lc-cn-n1-shared.com");

  }
}
