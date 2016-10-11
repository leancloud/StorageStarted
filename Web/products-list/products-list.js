// handlebars context
var context = {
  products: []
};

function setupData() {
  // LeanCloud - 查询
  // https://leancloud.cn/docs/leanstorage_guide-js.html#查询
  var query = new AV.Query('Product');
  query.include('owner');
  query.include('image');
  query.descending('createdAt');
  query.find().then(function (products) {
    products.forEach(function(product) {
      var productTitle = product.get('title');
      var productDescription = product.get('description');
      var releaseTime = (product.createdAt.getMonth() + 1) + '/' + product.createdAt.getDate() + '/' +  product.createdAt.getFullYear();
      var ownerUsername = product.get('owner').get('username');
      var productImage = product.get('image');
      var productImageUrl;
      if (productImage) {
        productImageUrl = productImage.get('url');
      } else {
        productImageUrl = './../storage.png'
      }
      // handlebars context
      context.products.push({
        productImageUrl,
        productTitle,
        productDescription,
        ownerUsername,
        releaseTime
      });
    });

    // use handlebars to update html
    var source = $("#products-list").html();
    var template = Handlebars.compile(source);
    var html = template(context);
    $('.products-detail').html(html);

  }).catch(function(error) {
    alert(JSON.stringify(error));
  });
};

function logout() {
  AV.User.logOut();
  window.location.href = "./../login/login.html";
};

$(function() {
  if (isCurrentUser()) {
    setupData();
  } else {
    window.location.href = "./../login/login.html";
  }
});
