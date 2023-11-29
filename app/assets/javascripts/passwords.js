document.addEventListener('turbolinks:load', () => {
  $('.toggle-password-field').on('click', function(event) {
    event.preventDefault();

    const $target = $($(this).data('toggle'));

    if ($target.attr('type') == 'text') {
      $target.attr('type', 'password');
      $(this).html('<i data-feather="eye-off"/>');
    }
    else if ($target.attr('type') == 'password') {
      $target.attr('type', 'text');
      $(this).html('<i data-feather="eye"/>');
    }

    feather.replace();
  });
});
