var Admin = {
  init : function(){
    $('.admin.user .nav-tabs li').click(Admin.clicked_tab);

    $('.show_user_css').click(function(){
      $(this).hide();
      $(this).next('form').slideDown();
    });
  },

  // Used on AdminController#user view
  clicked_tab : function(e) {
    var id = e.target.id;
    if(id == 'user') {
      $('.user_tab').show();
      $('.site_tab').hide();
    } else {
      $('.user_tab').hide();
      $('.site_tab').each(function(index, elem) {
        if(elem.id == id) {
          $(elem).show();
        } else {
          $(elem).hide();
        }
      });
    }
    $('.nav-tabs li').each(function(index, elem){
      if(elem.children[0].id == id) {
        $(elem).addClass('active');
      } else {
        $(elem).removeClass('active');
      }
    });
    return false;
  }
};

$(document).ready(function(){
  Admin.init()

  // AdminController#site redirects with an anchor to indicate the
  // AdminController#user tab to be selected (if any)
  if(location.pathname.match(/^\/admin\/user\//)){
    id = location.hash;
    if (location.hash) {
      $('.admin.user .nav-tabs li ' + location.hash).click();
    }
  }
});