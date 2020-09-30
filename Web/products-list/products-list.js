// handlebars context
const context = {
  products: [],
};

function getReleaseTime(date) {
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return `${year}/${month}/${day}`;
}

function setupData() {
  // LeanCloud - 查询
  // https://leancloud.cn/docs/leanstorage_guide-js.html#hash860317
  LC.CLASS("Product")
    .include("owner", "image")
    .orderBy("createdAt", "desc")
    .find()
    .then((products) => {
      products.forEach((product) => {
        const owner = product.data.owner;
        const productImage = product.data.image;

        // handlebars context
        context.products.push({
          productImageUrl: productImage ? productImage.url : "./../storage.png",
          productTitle: product.data.title,
          productDescription: product.data.description,
          price: product.data.price,
          ownerUsername: owner ? owner.data.username : "unknown",
          releaseTime: getReleaseTime(product.createdAt),
        });
      });

      // use handlebars to update html
      const source = $("#products-list").html();
      const template = Handlebars.compile(source);
      const html = template(context);
      $(".products-detail").html(html);
    })
    .catch((error) => alert(error.error));
}

function logout() {
  LC.User.logOut();
  window.location.href = "./../login/login.html";
}

$(function () {
  if (LC.User.current()) {
    setupData();
  } else {
    window.location.href = "./../login/login.html";
  }
});
