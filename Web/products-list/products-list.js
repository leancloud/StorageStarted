// handlebars context
const context = {
  products: []
};

function setupData() {
  // LeanCloud - 查询
  // https://leancloud.cn/docs/leanstorage_guide-js.html#hash860317
  const query = db.class('Product').include('owner', 'image').orderBy('createdAt', 'desc');
  query.find().then(function (products) {
    products.forEach(function (product) {
      const productTitle = product.data.title;
      const productDescription = product.data.description;
      const price = product.data.price;
      const releaseTime = (product.createdAt.getMonth() + 1) + '/' + product.createdAt.getDate() + '/' +  product.createdAt.getFullYear();
      const owner = product.data.owner;
      const ownerUsername = owner ? owner.data.username : 'unknown';
      const productImage = product.data.image;
      let productImageUrl;
      if (productImage) {
        productImageUrl = productImage.url;
      } else {
        productImageUrl = './../storage.png'
      }
      // handlebars context
      context.products.push({
        productImageUrl,
        productTitle,
        productDescription,
        price,
        ownerUsername,
        releaseTime
      });
    });

    // use handlebars to update html
    const source = $("#products-list").html();
    const template = Handlebars.compile(source);
    const html = template(context);
    $('.products-detail').html(html);

  }).catch (function(error) {
    alert(error.error);
  });
};

function logout() {
  User.logOut();
  window.location.href = "./../login/login.html";
};

$(function() {
  if (User.current()) {
    setupData();
  } else {
    window.location.href = "./../login/login.html";
  }
});
