class @DynamicFieldsBuilder
  remove_fields: (element) ->
    $(element).closest('.fields').hide()
    $(element).prev('input[type=hidden]').val('1')

  add_fields: (element, association, content) ->
    new_id = new Date().getTime()
    regexp = new RegExp('new_' + association, 'g')
    $(element).before(content.replace(regexp, new_id))
