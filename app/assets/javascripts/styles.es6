function toggleStyleVisible(styleId) {
  $.ajax({
    url : '/styles/' + styleId + '/toggle_visible',
    type : 'PATCH',
    contentType : 'application/json',
    dataType: 'json'
  }).done((response) => {
    $('#style_' + styleId).prop('checked', response.visible)
  })
}
