var ThemeVariable = {
  init : function(){
    $(".theme_variables").sortable({axis: 'y', handle: ".handle", update: ThemeVariable.reorder});
    $(".theme_variables" ).disableSelection();
    $('.create_theme_variable').submit(ThemeVariable.create);
    $(".theme_variables").delegate(".update_theme_variable", "submit", ThemeVariable.update);
    $(".theme_variables").delegate(".destroy_theme_variable", "click", ThemeVariable.destroy);
  },
  reorder : function(){
    $.ajax({
      type: "POST",
      data: $(this).sortable("serialize"),
      url:  "/themes/" + theme_id + "/reorder",
      success: function(){Notices.notice('Updated Variable Order');}
    });    
  },
  create : function(){
    $.ajax({
      type:     "POST",
      form:     this,
      list:     $(this).prev('ul'),
      data:     $(this).serialize(),
      url:      $(this).attr('action'),
      dataType: "html",
      success:  ThemeVariable.create_success
    });    
    return false;
  },
  create_success : function(data){
    if(data.indexOf("ERROR:") > -1) {
      Notices.error(data);
    } else {
      this.list.append(data);
      this.form.reset();
      Notices.notice('Created Variable');
    }
  },
  update : function(){
    $.ajax({
      type:     "POST",
      data:     $(this).serialize(),
      url:      $(this).attr('action'),
      dataType: "text",
      success:  ThemeVariable.update_success
    });    
    return false;    
  },
  update_success : function(data){
    if(data.indexOf("ERROR:") > -1) {
      Notices.error(data);
    } else {
      Notices.notice('Updated Variable');
    }    
  },
  destroy : function(){
    data = {'_method':'delete'};
    confirmed = confirm("Are you sure?");
    if(confirmed){
      $.ajax({
        type:           "POST",
        data:           data,
        url:            $(this).attr('href'),
        theme_variable: $(this).parents('li'),
        success: function(){
          this.theme_variable.remove();
          Notices.notice("Theme Variable Deleted");
        }
      });        
    }
    return false;
  }
};

if(location.pathname.match(/\/themes\/.+\/edit/)){
  $(document).ready(function(){
    ThemeVariable.init();
  }); 
}