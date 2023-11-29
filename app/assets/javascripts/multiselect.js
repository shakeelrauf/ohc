document.addEventListener('turbolinks:load', () => {
  $('.multiselect ul li').on('click', function(e) {
    const $this = $(this);
    const $target = $($this.parents('ul').data('target'));
    const $icon = $this.find('svg');

    const clickedValue = $this.data('value').toString();

    let selectedValues = $target.val() || [];

    if (selectedValues.includes(clickedValue)) {
      selectedValues = selectedValues.filter(selectedValue => selectedValue !== clickedValue)

      $this.removeClass('active');
      $icon.replaceWith('<i data-feather="square" />');
    }
    else {
      selectedValues.push(clickedValue);
      $this.addClass('active');
      $icon.replaceWith('<i data-feather="check-square" />');
    }

    $target.val(selectedValues);
    feather.replace();
  });
});
