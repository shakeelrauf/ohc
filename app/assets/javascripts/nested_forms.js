document.addEventListener('turbolinks:load', () => {
  function setInsertionTarget() {
    $('.add_fields').data('association-insertion-method', 'append')
                    .data('association-insertion-node', function(link) {
      return link.closest('.nested-form').children('.nested-items');
    });
  }

  $('form').on('cocoon:after-insert', function() {
    setInsertionTarget();
  });

  setInsertionTarget();
});
