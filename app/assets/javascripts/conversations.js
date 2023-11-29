document.addEventListener('turbolinks:load', () => {
  const $chatBody = $('.conversation--chat-window > .card-body');

  $chatBody.scrollTop($chatBody.prop('scrollHeight'));
});
