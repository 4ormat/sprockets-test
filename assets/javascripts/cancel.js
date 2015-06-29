Cancel = {
  init : function(){
    $('input[type=radio]').click(function(){
      $(this).parent().append($('#feedback').show());
    });
    
    $('input[type=submit]').click(function(){
      if($('input[type=radio]:checked').length < 1){
        $('.validate').show();
        return false;        
      } else {
        $('.validate').hide();
      }
      return true;
    });
  }
};

if(location.pathname == '/subscription/cancel'){
  $(document).ready(function(){
    Cancel.init();
  });  
}