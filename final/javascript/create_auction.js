$(document).ready(function() {
  let amazonASIN;
  $('input[type=radio][name=optradio]').change(function() {
    if(this.value === 'api') {
      $('#amazonSearch').fadeIn('slow');
    }else if(this.value === 'personalized') {
      $('#amazonSearch').fadeOut('slow');
      amazonASIN = null;
    }
  });

  $('#amazonSearch').on('change', '#keyword', function() {
    $(this).css('border', '');
  });

  $('#amazonSearch').on('click', '.searchAmazon', function(event) {
    event.stopPropagation();
    let keyword = $('#keyword').val();
    if(keyword == '') {
      $('#keyword').css('border', '1px solid red');
      return;
    }
    let category = $('#search_index').val();
    $(this).prop('disabled', true);

    $.ajax({
      type: 'GET',
      url: BASE_URL + 'api/auction/amazon_search.php',
      dataType: 'json',
      data: {
        'keyword': keyword,
        'category': category,
      },
      success: function(data) {
        if (data['message'].includes('Success')) {
          let amazonDiv = $('#amazonSearch');
          amazonDiv.empty();
          amazonDiv.append(data['amazonDiv']);
          amazonDiv.show();
        }
        $(this).prop('disabled', false);
      },
      error: function(data) {
        console.log(data);
        $(this).prop('disabled', false);
      },
    });
  });

  $('#step-1').on('click', '.input-group span.addCharacteristic', function() {
    let input = $(this).closest('.input-group').find('input[name=newCharacteristic]');
    let value = input.val();

    if(value === '' || value.length > 128)
      return;

    let select = $('#characteristics');
    let nrElements = select.find('> option').length;
    if(nrElements >= 20)
      return;

    let option = '<option>' + value + '</option>';
    select.append(option);
    select.selectpicker('refresh');
    input.val('');
  });

  $(function() {
    $('#startDatePicker').datetimepicker({
      minDate: moment().add(12, 'hours'),
      defaultDate: moment().add(12, 'hours'),
      locale: 'pt',
    });

    $('#endDatePicker').datetimepicker({
      minDate: moment().add(12, 'hours'),
      defaultDate: moment().add(2, 'days'),
      locale: 'pt',
      useCurrent: false,
    });

    $('#startDatePicker').on('dp.change', function(e) {
      $('#endDatePicker').data('DateTimePicker').minDate(e.date);
    });
    $('#endDatePicker').on('dp.change', function(e) {
      $('#startDatePicker').data('DateTimePicker').maxDate(e.date);
    });
  });

  $.validator.addMethod('productCategoriesSelected',
    function(value, element, arg) {
      return (value.length > 0 && value.length < 3);
  }, 'At least one category must be selected.');

  $.validator.addMethod('auctionTypeSelected',
    function(value, element, arg) {
      return (value !== ''&& (value === 'Sealed Bid'
        || value === 'Default' || value === 'Dutch'));
  }, 'The auction type must be selected');

  $('#createAuctionForm').validate({
    rules:
      {
        'product_name': {
          required: true,
          maxlength: 64,
        },
        'quantity': {
          required: true,
          digits: true,
        },
        'description': {
          required: true,
          maxlength: 512,
        },
        'condition': {
          required: true,
          maxlength: 512,
        },
        'category[]': {
          productCategoriesSelected: true,
        },
        'base_price': {
          required: true,
          digits: true,
        },
        'start_date': {
          required: true,
        },
        'end_date': {
          required: true,
        },
        'auction_type': {
          auctionTypeSelected: true,
        },
      },
    messages:
      {
        product_name: {
          required: 'Please, enter the product name.',
          maxlength: 'The product name must be no more than 64 characters.',
        },
        quantity: {
          required: 'Please, enter the number of products that are up to sell.',
          digits: 'Only digits are allowed.',
        },
        base_price: {
          required: 'Please, enter the auction initial price.',
          digits: 'Only digits are allowed.',
        },
        condition: {
          required: 'Please, enter the product condition.',
          maxlength: 'The product condition' +
          'must be no more than 255 characters.',
        },
        description: {
          required: 'Please, enter the product description.',
          maxlength: 'The product condition' +
          'must be no more than 255 characters.',
        },
        category: {
          productCategoriesSelected: 'Please, select a category.',
        },
        auction_type: {
          auctionTypeSelected: 'Please, select the auction type.',
        },
      },
    errorPlacement: function(error, element) {
      if($(element).attr('name') === 'description'
          || $(element).attr('name') === 'condition')
        error.insertAfter(element);
      else{
        let parentDiv = $(element).closest('.input-group');
        error.insertAfter(parentDiv);
      }
    },
  });

  let navListItems = $('ul.setup-panel li a');
  let allWells = $('.setup-content');
  allWells.hide();

  navListItems.click(function(e) {
    e.preventDefault();
    let $target = $($(this).attr('href'));
    let $item = $(this).closest('li');

    if (!$item.hasClass('disabled')) {
      navListItems.closest('li').removeClass('active');
      $item.addClass('active');
      allWells.hide();
      $target.show();
    }
  });

  $('ul.setup-panel li.active a').trigger('click');

  $('#activate-step-2').on('click', function() {
    if($('#product_name').valid() && $('#category').valid()
        && $('#description').valid() && $('#condition').valid()) {
      $('ul.setup-panel li:eq(1)').removeClass('disabled');
      $('ul.setup-panel li a[href="#step-2"]').trigger('click');
      $(this).remove();
    }
  });

  $('#activate-step-3').on('click', function(e) {
    if($('#end_date').valid() && $('#start_date').valid() &&
        $('#auction_type').valid() && $('#base_price').valid()) {
      $('#createAuction-btn').removeClass('hidden');
      $('ul.setup-panel li:eq(2)').removeClass('disabled');
      $('ul.setup-panel li a[href="#step-3"]').trigger('click');
      $(this).remove();
    }
  });
});
