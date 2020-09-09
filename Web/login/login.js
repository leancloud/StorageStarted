function login() {
  const username = $('#inputUsername').val();
  const password = $('#inputPassword').val();

  // LeanCloud - 登录
  // https://leancloud.cn/docs/leanstorage_guide-js.html#hash964666
  User.logIn(username, password).then(function () {
    window.location.href = "./../products-list/products-list.html";
  }, function (error) {
    alert(error.error);
  });
};

$(function() {
  $(".form-signin").on('submit', function(e) {
    e.preventDefault();
    login();
  });
});
