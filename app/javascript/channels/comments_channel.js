import consumer from "./consumer"

consumer.subscriptions.create('CommentsChannel', {
  connected () {
    var cur_path = window.location.pathname;
    if (cur_path.match(/questions\/\d/)) {
      var questionId = [...cur_path.split('/')].pop()
      this.perform('follow', { id: questionId });
    }
  },
  received (data) {
    var comment_html = '<li>' + '<strong>' + data.email + '</strong>' + '<br>' + data.comment_body + '</li>'
    var selector = '#' + data.commentable_type + '-' + data.commentable_id + ' .comments ul'
    $(selector).append(comment_html)
  }
})
