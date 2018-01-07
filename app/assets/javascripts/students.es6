document.addEventListener('turbolinks:load', () => {
  let timeout = null;
  $('#filter').on('keyup', (event) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
      $.get('/students/filter?q=' + encodeURIComponent(event.target.value), (response) => {
        $('table.students tbody').html(response);
      });
    }, 300);
  });
});
