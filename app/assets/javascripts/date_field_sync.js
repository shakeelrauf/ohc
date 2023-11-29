document.addEventListener('turbolinks:load', () => {
  /**
   * Syncs the start and end date fields (retaining existing times) to prevent needing to select the same date twice,
   * dependending on a sync input being checked.
   */

  syncDateInput = document.getElementById('event_sync_dates');
  startsAtField = document.getElementById('event_starts_at');
  endsAtField = document.getElementById('event_ends_at');

  /**
   * Manipulate a ISO date string to use the date values from another date
   */
  const updateDateValue = (originalDateISOString, newDate) => {
    const originalDateTime = originalDateISOString.split('T')[1];
    const newDateISODate = newDate.toISOString().split('T')[0];

    return `${newDateISODate}T${originalDateTime}`;
  }

  const addListenerToInput = (referenceInput, dependantInput) => {
    referenceInput.addEventListener('change', ({ target: { value }}) => {
      if (syncDateInput.checked) {
        const startDate = new Date(value);

        dependantInput.value = updateDateValue(dependantInput.value, startDate);
      }
    });
  }

  if (startsAtField && endsAtField) {
    addListenerToInput(startsAtField, endsAtField);
    addListenerToInput(endsAtField, startsAtField);
  }
});
