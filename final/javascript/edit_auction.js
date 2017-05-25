$(document).ready(function() {

  $('#step-1').on('click', '.input-group span.addCharacteristic', function() {
    let input = $(this).closest('.input-group').find('input[name=newCharacteristic]');
    let value = input.val();

    if(value === '' || value.length > 128)
      return;

    let select = $('#characteristics');
    let option = '<option>' + value + '</option>';
    select.append(option);
    select.selectpicker('refresh');
    input.val('');
  });

  $(function() {
    $('#startDatePicker').datetimepicker({
      minDate: $('#start_date').val(),
      locale: 'pt',
    });

    $('#endDatePicker').datetimepicker({
      minDate: moment(),
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
});
