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
