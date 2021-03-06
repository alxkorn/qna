import consumer from "./consumer"

consumer.subscriptions.create('AnswersChannel', {
  connected () {
    var cur_path = window.location.pathname;
    if (cur_path.match(/questions\/\d/)) {
      var questionId = [...cur_path.split('/')].pop()
      this.perform('follow', { id: questionId });
    }
  },
  received (data) {
    if(data.event == 'answer created') {
      this.perform('get_answer_html', {answer_id: data.answer_id, question_id: data.question_id, user_id: getCookie('user_id')})
    }
    if(data.event == 'created answer html') {
      $('.answers_list').append(data.answer_html)
    }
  }
})

function getCookie(name) {
  var value = "; " + document.cookie;
  var parts = value.split("; " + name + "=");
  if (parts.length == 2) return parts.pop().split(";").shift();
}