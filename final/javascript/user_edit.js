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

  $('#form-general').validate({
    rules:
      {
        realName: {
            required: true,
            maxlength: 64,
        },
        smallBio: {
            required: true,
            maxlength: 255,
        },
        fullBio: {
          maxlength: 512,
        },
        email: {
            required: true,
        },
      },
    messages:
      {
        realName: {
            required: 'Please, enter your real name.',
            maxlength: 'Your name can\'t have more than 64 characters.',
        },
        smallBio: {
            required: 'Please, enter a small description.',
            maxlength: 'Your description must be no more than 255 characters.',
        },
        email: {
            required: 'Please, enter your email.',
        },
      },
    errorPlacement: function(error, element) {
      $(element).parent().append(error);
    },
  });

  $('#form-password').validate({
    rules:
      {
        currPass: {
          required: true,
          minlength: 8,
          maxlength: 64,
        },
        newPass: {
          required: true,
          minlength: 8,
          maxlength: 64,
        },
        newPassRepeat: {
          required: true,
          equalTo: $(this).find('#new-pass-1'),
        },
      },
    messages:
      {
        currPass: {
          required: 'Please, enter your new password.',
          minlength: 'Your password should be between 8 and 64 characters.',
          maxlength: 'Your password should be between 8 and 64 characters.',
        },
        newPass: {
          required: 'Please, enter your new password.',
          minlength: 'Your password should be between 8 and 64 characters.',
          maxlength: 'Your password should be between 8 and 64 characters.',
        },
        newPassRepeat: {
          required: 'Please, enter your new password.',
          equalTo: 'The password doesn\'t match.',
        },
      },
    errorPlacement: function(error, element) {
      $(element).parent().append(error);
    },
  });
});
