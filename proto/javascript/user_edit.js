$(document).ready(function() {
  $('.btn-discard').click(function() {
    window.location.href=window.location.href;
  });

  let profileUrl = $('input[name=picture]').val();
  console.log(profileUrl);
  let profilePic =
    '<img src=' + profileUrl + ' alt="Your Avatar" style="width:160px">';
  $('#picture').fileinput({
    overwriteInitial: true,
    maxFileSize: 1500,
    showClose: false,
    showCaption: false,
    browseLabel: '',
    removeLabel: '',
    browseIcon: '<i class="glyphicon glyphicon-folder-open"></i>',
    removeIcon: '<i class="glyphicon glyphicon-remove"></i>',
    removeTitle: 'Cancel or reset changes',
    elErrorContainer: '#kv-avatar-errors-1',
    msgErrorClass: 'alert alert-block alert-danger',
    defaultPreviewContent: profilePic,
    layoutTemplates: {main2: '{preview} {remove} {browse}'},
    allowedFileExtensions: ['jpg', 'png', 'gif'],
  });
});
