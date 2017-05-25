$(document).ready(function() {
  getInitialPreview();
});

/**
 * Gets the product images
 */
function getInitialPreview() {
  let productId = $('#product_id').val();
  let request = $.ajax({
    type: 'POST',
    url: BASE_URL + 'api/auction/get_product_images.php',
    data: {
      'productId': productId,
      'userId': userId,
      'token': token,
    },
    dataType: 'json',
  });

  request.done(function(data, textStatus, jqXHR) {
    let message = data['message'];
    let response = data['response'];
    if(response.includes('Success')) {
      initFileInput(data);
    }
  });

  request.fail(function(jqXHR, textStatus, errorThrown) {
    console.error('The following error occurred: ' +
      textStatus + ': ' + errorThrown);
  });
}

/**
 * Initializes the file input
 * @param {json} response
 */
function initFileInput(response) {
  let footerTemplate = '<div class="file-thumbnail-footer" style ="height:94px">\n' +
    '   <div style="margin:5px 0">\n' +
    '       <input class="kv-input kv-new form-control input-sm text-center {TAG_CSS_NEW}" value="{caption}" placeholder="Enter caption...">\n' +
    '       <input class="kv-input kv-init form-control input-sm text-center {TAG_CSS_INIT}" value="{TAG_VALUE}" placeholder="Enter caption...">\n' +
    '   </div>\n' +
    '   {size} {progress} {actions}\n' +
    '</div>';

  let initialPreview = response['initialPreview'];
  let initialPreviewConfig = response['initialPreviewConfig'];
  let initialPreviewThumbTags = response['initialPreviewThumbTags'];

  $('#input-24').fileinput({
    uploadUrl: BASE_URL + 'api/auction/upload_images.php',
    uploadAsync: false,
    overwriteInitial: false,
    initialPreviewAsData: true,
    maxFileSize: 5000,
    allowedFileExtensions: ['png', 'jpg', 'bmp', 'jpeg'],
    previewClass: 'bg-warning',
    layoutTemplates: {footer: footerTemplate,
      size: '<samp><small>({sizeText})</small></samp>'},
    minFileCount: 1,
    maxFileCount: 10,
    validateInitialCount: true,
    previewThumbTags: {
      '{TAG_VALUE}': '',        // no value
      '{TAG_CSS_NEW}': '',      // new thumbnail input
      '{TAG_CSS_INIT}': 'hide',  // hide the initial input
    },
    initialPreview: initialPreview,
    initialPreviewConfig: initialPreviewConfig,
    initialPreviewThumbTags: initialPreviewThumbTags,
    uploadExtraData: function() {  // callback example
      let images = [];
      let i = 0;
      console.log(this);
      $('.kv-input:visible').each(function() {
        $el = $(this);
        if(!$el.hasClass('kv-new'))
          return;
        images[i] = $el.val();
        i++;
      });
      let out = {};
      out['captions'] = images;
      out['productId'] = $('#product_id').val();
      out['token'] = token;
      out['userId'] = userId;
      return out;
    },
  });
}
