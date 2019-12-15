
$(document).on('ajax:success', '.vote_links', function(e) {handleVote(e)})
$(document).on('ajax:success', '.cancel_vote_link', function(e) {handleVote(e)})


function handleVote(e) {
  let arr = ['Upvote', 'Downvote', 'Cancel vote'];
    if (arr.includes(e.target.text)) {
      
      var data = e.detail[0]
      var rating = data.rating
      var selector = '#' + data.type + '-' + data.id

      $(selector + ' .rating').html('Rating: ' + rating)
      $(selector + ' .vote_links').toggle()
      $(selector + ' .cancel_vote_link').toggle()
    }
}