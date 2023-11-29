document.addEventListener('turbolinks:load', () => {
  $('.custom-file-input').change(({ target }) => {
    const filename = target.value.split('\\').pop();

    $(target).next('.custom-file-label').text(filename);
  });

  $('form').on('cocoon:after-insert', function() {
    feather.replace();
  });
});
