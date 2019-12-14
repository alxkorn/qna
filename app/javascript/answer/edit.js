document.addEventListener('turbolinks:load', function() {
    $('.answers_list').on('click', '.edit-answer-link', function(e) {
      e.preventDefault()
      // console.log(this)
      var answerId = $(this).data('answerId')
      $('form#edit-answer-'+answerId).toggle()
  })

  // $('form.new-answer').on('ajax:success', function(e) {
  //   var answer = e.detail[0]

  //   $('.answers_list').append('<p>' + answer.body + '</p>')
  // })
  //   .on('ajax:error', function(e) {
  //     var errors = e.detail[0]
  //     $('.new-answer-errors').html('')
  //     $.each(errors, function(index, value) {
  //       $('.new-answer-errors').append('<p>' + value + '</p>')
  //     })
    
  //   })
})
