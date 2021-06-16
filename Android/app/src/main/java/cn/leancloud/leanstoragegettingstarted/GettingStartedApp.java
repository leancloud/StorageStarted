package cn.leancloud.leanstoragegettingstarted;

import android.app.Application;

import cn.leancloud.LCLogger;
import cn.leancloud.LeanCloud;


/**
 * Created by BinaryHB on 16/9/13.
 */
public class GettingStartedApp extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
    //开启调试日志
    LeanCloud.setLogLevel(LCLogger.Level.DEBUG);
    LeanCloud.initialize(this,"OLoj899IwHYi787ClrImlr3k-gzGzoHsz", "gkz35mRTqTE2aqwp7dEr5uEE","https://oloj899i.lc-cn-n1-shared.com");

  }
}
