async function releaseNewProduct() {
  // LeanCloud - 当前用户
  // https://leancloud.cn/docs/leanstorage_guide-js.html#hash748191977
  const currentUser = User.current();

  // LeanCloud - 文件
  // https://leancloud.cn/docs/leanstorage_guide-js.html#hash825935
  const file = $('#inputFile')[0].files[0];
  const name = file.name;
  db.class('_File').upload(name, file).then(lcFile => {
    // LeanCloud - 对象
    // https://leancloud.cn/docs/leanstorage_guide-js.html#hash799084270
    db.class('Product')
      .add({
        title: $('#inputTitle').val(),
        price: parseFloat($('#inputPrice').val()),
        description: $('#inputDescription').val(),
        owner: currentUser,
        image: lcFile,
      })
      .then(() => {
        window.location.href = './../products-list/products-list.html'
      })
      .catch(err => alert(err.error));
  });
};

$(function() {
  if (User.current()) {
    $(".new-product").on('submit', function(e) {
      e.preventDefault();
      releaseNewProduct();
    });
  } else {
    window.location.href = "./../login/login.html";
  }
});
