document.addEventListener('turbolinks:load', function() {
    $('.answers_list').on('click', '.edit-answer-link', function(e) {
      e.preventDefault()
      var answerId = $(this).data('answerId')
      $('form#edit-answer-'+answerId).toggle()
  })
})
