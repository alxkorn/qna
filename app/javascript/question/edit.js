document.addEventListener('turbolinks:load', function() {
    $('.question_box').on('click', '.edit-question-link', function(e) {
      e.preventDefault()
      $('form#edit-question').toggle()
  })
})
