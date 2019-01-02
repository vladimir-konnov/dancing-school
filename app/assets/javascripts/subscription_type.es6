function toggleSubscriptionTypeVisible(subscriptionTypeId) {
  $.ajax({
    url : '/subscription_types/' + subscriptionTypeId + '/toggle_visible',
    type : 'PATCH',
    contentType : 'application/json',
    dataType: 'json'
  }).done((response) => {
    $('#subscription_type_' + subscriptionTypeId).prop('checked', response.visible)
  })
}
