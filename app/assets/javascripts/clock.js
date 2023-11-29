document.addEventListener('turbolinks:load', () => {
  clockTick();
});

function clockTick() {
  const dateField = document.getElementById('current-time');
  const currentDate = new Date(dateField.textContent);
  const newDate = new Date(currentDate.getTime() + 1000);
  const newValue = strftime('%a, %e %b %Y %H:%M:%S %z', newDate);

  dateField.textContent = newValue;

  setTimeout(clockTick, 1000);
}
