$(document).ready(function() {
  let footerTemplate =
    '<div class="file-thumbnail-footer" style ="height:94px">\n' +
    '   <div style="margin:5px 0">\n' +
    '       <input class="kv-input kv-new form-control input-sm text-center ' +
    '{TAG_CSS_NEW}" value="{caption}" placeholder="Enter caption...">\n' +
    '       <input class="kv-input kv-init form-control input-sm text-center ' +
    '{TAG_CSS_INIT}" value="{TAG_VALUE}" placeholder="Enter caption...">\n' +
    '   </div>\n' +
    '   {size} {actions}\n' +
    '</div>';

  $('#input-24').fileinput({
    uploadUrl: BASE_URL + 'api/auction/upload_images.php',
    uploadAsync: false,
    overwriteInitial: false,
    maxFileSize: 10000,
    allowedFileExtensions: ['png', 'jpg', 'bmp', 'jpeg'],
    previewClass: 'bg-warning',
    layoutTemplates: {footer: footerTemplate,
      size: '<samp><small>({sizeText})</small></samp>'},
    minFileCount: 1,
    maxFileCount: 10,
    previewThumbTags: {
      '{TAG_VALUE}': '',        // no value
      '{TAG_CSS_NEW}': '',      // new thumbnail input
      '{TAG_CSS_INIT}': 'hide',  // hide the initial input
    },
    uploadExtraData: function() {  // callback example
      let images = [];
      let i = 0;
      $('.kv-input:visible').each(function() {
        $el = $(this);
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
});