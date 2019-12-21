document.addEventListener('ajax:error', function(event) {
  if(event.detail[2].status == 403) {
    $('.alert').text('You are not authorized for this action')
  }
})




