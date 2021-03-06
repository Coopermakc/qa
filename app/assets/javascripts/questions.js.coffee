# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  questionsList = $('.questions-list')
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $('.question').hide();
    $('.edit_question').show()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append data
})
