#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap-sprockets
#= require select2
#= require select2_locale_ja
#= require jquery.nested-fields
#= require_tree .

jQuery( ->
  $('[data-toggle="tooltip"]').tooltip()

  $('form').nestedFields(
    itemSelector: '.nested_filed',
    containerSelector: '.nested_fileds',
    addSelector: '.add_nested_filed',
    removeSelector: '.remove_nested_filed'
  )
)
