document.addEventListener('turbolinks:load', () => {
  $('.js-role-click').on('change', (event) => {
    let form = $(event.target).closest('form');
    $.ajax({
      url: form.prop('action'),
      method: form.find('input[name=_method]').val(),
      data: form.serialize()
    }).then(() => {});
    return false;
  });
});
$(function() {
  $('input[type=checkbox].user-hidden').on('change', (event) => {
    let checkboxInput = $(event.target)
    let userId = checkboxInput.data('id');
    if (checkboxInput && userId) {
      $.ajax({
        url: '/administration/hide_user', method: 'PATCH',
        data: { id: userId, hidden: checkboxInput.prop('checked') }
      }).then((response) => {
        if (response.hasOwnProperty('hidden')) {
          checkboxInput.prop('checked', response.hidden);
        }
      });
    }
    return false;
  })
})
