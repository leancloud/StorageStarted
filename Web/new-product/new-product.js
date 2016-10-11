var Product = AV.Object.extend('Product');

function releaseNewProduct() {
  var title = $('#inputTitle').val();
  var price = parseFloat($('#inputPrice').val());
  var description = $('#inputDescription').val();
  
  // LeanCloud - 当前用户
  // https://leancloud.cn/docs/leanstorage_guide-js.html#当前用户
  var currentUser = AV.User.current();

  // LeanCloud - 文件
  // https://leancloud.cn/docs/leanstorage_guide-js.html#文件
  var file = $('#inputFile')[0].files[0];
  var name = file.name;
  var avFile = new AV.File(name, file);
  
  // LeanCloud - 对象
  // https://leancloud.cn/docs/leanstorage_guide-js.html#数据类型
  var product = new Product();
  product.set('title', title);
  product.set('price', price);
  product.set('description', description);
  product.set('owner', AV.User.current());
  product.set('image', avFile);
  product.save().then(function() {
    window.location.href = "./../products-list/products-list.html";
  }, function(error) {
    alert(JSON.stringify(error));
  });
};

$(function() {
  if (isCurrentUser()) {
    $(".new-product").on('submit', function(e) {
      e.preventDefault();
      releaseNewProduct();
    });
  } else {
    window.location.href = "./../login/login.html";
  }
});
