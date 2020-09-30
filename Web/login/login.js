function login() {
  const username = $("#inputUsername").val();
  const password = $("#inputPassword").val();

  // LeanCloud - 登录
  // https://leancloud.cn/docs/leanstorage_guide-js.html#hash964666
  LC.User.login(username, password)
    .then(() => {
      window.location.href = "./../products-list/products-list.html";
    })
    .catch(({ error }) => alert(error));
}

$(function () {
  $(".form-signin").on("submit", function (e) {
    e.preventDefault();
    login();
  });
});
