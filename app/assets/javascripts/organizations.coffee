jQuery( ->
  $('.search-user').each( ->
    $this = $(this)
    $this.select2(
      ajax:
        url: $this.data('source')
        dataType: 'json'
        quietMillis: 1000
        data: (term, page) -> { q: term, page: page, per: 10 }
        results: (data, page) -> { results: data }
        cache: true
      minimumInputLength: 1
    )
  )
)
