document.addEventListener('turbolinks:load', () => {
  $('*[data-href]').on('click', function(e) {
    const $target = $(e.target);
    const insideLink = $target.parents('a').length > 0;
    const dropdown = $target.parents('.dropdown').length > 0;

    if (!insideLink && !dropdown) {
      window.location = $(this).data('href');
    }
  });
});
