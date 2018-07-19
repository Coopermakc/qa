$ ->
  commentsList = $('.comments')
  $('.new-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    commentable_id = $(this).data('commentableId')
    $('form#new-comment-' + commentable_id).show()
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      console.log(gon.answers)
      answersList.append gon.answers
})