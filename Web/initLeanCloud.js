// LeanCloud - 初始化 - 将这里的 appId 、 appKey 和 serverURL 替换成自己的应用数据
// https://leancloud.cn/docs/sdk_setup-js.html#hash14962003
const appId = 'OLoj899IwHYi787ClrImlr3k-gzGzoHsz';
const appKey = 'gkz35mRTqTE2aqwp7dEr5uEE';
const serverURL = 'https://OLoj899I.lc-cn-n1-shared.com';

const app = new LC.App({ appId, appKey, serverURL });
const db = new LC.Storage(app);
const User = db.class('_User');
