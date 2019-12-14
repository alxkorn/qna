document.addEventListener('turbolinks:load', function() {
  $(document).on('ajax:success', function(e) {handleVote(e)})
})

function handleVote(e) {
  let arr = ['Upvote', 'Downvote', 'Cancel vote'];
    if (arr.includes(e.target.text)) {
      var rating = e.detail[0].rating
      var selector = e.detail[0].selector

      $(selector + ' .rating').html('Rating: ' + rating)
      $(selector + ' .vote_links').toggle()
      $(selector + ' .cancel_vote_link').toggle()
    }
}