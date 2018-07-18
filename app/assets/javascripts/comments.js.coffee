$ ->
  $('.new-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    commentable_id = $(this).data('commentableId')
    $('form#new-comment-' + commentable_id).show()