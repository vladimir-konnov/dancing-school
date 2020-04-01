document.addEventListener('turbolinks:load', () => {
  let timeout = null;
  let onSelect = (event, item) => {
    currentStudentId = item.value;
    $('#add-btn').prop('disabled', '')
  };
  $('#students-lookup').typeahead({
    autoselect: true,
    hint: true,
    highlight: true,
    minLength: 2,
    items: 6
  }, {
    displayKey: 'label',
    async: true,
    source: (query, processSync, processAsync) => {
      clearTimeout(timeout);
      timeout = setTimeout(() => {
        return $.get('/students/autocomplete', {
          q: query, date: lessonDate, is_party: isPartyLesson
        }, (response) => {
          return processAsync(response);
        });
      }, 300)
    }
  }).on('typeahead:select', onSelect).on('typeahead:autocomplete', onSelect);

  $('.js-style').click((event) => { location.href = styleUrl + '?style_id=' + $(event.target).val(); });
});

function addStudent(event, lessonId, studentId) {
  if (!event.target.disabled) {
    $.post('/lessons/' + lessonId + '/add_student', { student_id: studentId }, (response) => {
      $('.students-list tbody').html(response);
      $('#add-btn').prop('disabled', 'disabled');
    });
    $('#students-lookup').val('')
  }
}

function removeStudent(lessonId, studentId) {
  $.ajax({
    url: '/lessons/' + lessonId + '/remove_student/' + studentId,
    type: 'DELETE',
    success: function(response) {
      $('.students-list tbody').html(response);
    }
  });
}
