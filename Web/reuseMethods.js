function isCurrentUser () {
  var currentUser = AV.User.current();
  if (currentUser) {
    return true;
  }
  return false;
};
