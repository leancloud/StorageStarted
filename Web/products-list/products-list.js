function isCurrentUser () {
  var currentUser = AV.User.current();
  if (currentUser) {
    return true;
  }
  return false;
};

function setupData() {
  // LeanCloud - 查询
  // https://leancloud.cn/docs/leanstorage_guide-js.html#查询
  var query = new AV.Query('Product');
  query.include('owner');
  query.include('image');
  query.descending('createdAt');
  query.find().then(function (products) {
    for (var i = 0; i <= products.length - 1; i++) {
      try {
        var product = products[i]
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
        var productHtml = '<div class="col-sm-6 col-md-4 product-detail"> \
            <div class="thumbnail"> \
              <img src="'+ productImageUrl + '" alt=""> \
              <div class="caption"> \
                <h3>' + productTitle + '</h3> \
                <p>'+ productDescription +'</p> \
                <p>来自：' + ownerUsername +'</p> \
                <p>发布时间：'+ releaseTime + '</p>\
              </div> \
            </div> \
          </div>';
        $('.products-detail').append(productHtml);
      } catch (error) {
        console.log(error);
      }
    }
  }, function (error) {
    console.log(error);
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
