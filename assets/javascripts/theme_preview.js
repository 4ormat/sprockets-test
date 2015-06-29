var ThemePreview = {
  init : function() {
    $('.small_preview a.thumb').click(ThemePreview.thumbClicked);
    $('#skin_select').change(function() {
      var skin_id = $(this).val();
      document.location = '/site/themes/' + skin_id + '/preview';
    });
  },
  thumbClicked : function() {
    var currently_selected_index = $('.small_preview a.thumb').index($('.small_preview a.thumb.selected'));
    var new_index = $('.small_preview a.thumb').index(this);
    if (new_index != currently_selected_index) {
      $('.small_preview a.thumb').removeClass('selected');
      $(this).addClass('selected');
      $($('.large_preview a')[currently_selected_index]).fadeOut('fast', function() {$($('.large_preview a')[new_index]).fadeIn('fast');});
    }
    return false;
  }
};

if(location.pathname.match(/^\/site\/themes/)){
  $(document).ready(function(){
    ThemePreview.init();
  });
}