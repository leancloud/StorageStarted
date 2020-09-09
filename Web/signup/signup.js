function signup() {
  // LeanCloud - 注册
  // https://leancloud.cn/docs/leanstorage_guide-js.html#hash885156
  User.signUp({
    username: $('#inputUsername').val(),
    password: $('#inputPassword').val(),
    email: $('inputEmail').val(),
  })
    .then(() => {
      window.location.href = './../products-list/products-list.html';
    })
    .catch(err => alert(err.error));
};

$(function() {
  $(".form-signup").on('submit', function(e) {
    e.preventDefault();
    signup();
  });
});
