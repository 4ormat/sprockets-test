Settings = {
  init : function(){
    $("#settings button").click(Settings.show_panel);
    $('a.hide_domain_settings').click(Settings.cancel)
  },
  show_panel : function(){
    c = $(this).attr('class');
    $('div.edit_settings:not(.'+c+')').slideUp();
    $('div.' + c).slideDown();

    return false;    
  },
  cancel : function(){
    $('div.edit_settings').slideUp();
    return false;    
  }
};

if(location.pathname == '/site/settings'){
  $(document).ready(function(){
    Settings.init();
  });  
}