
window.context = window.describe
window.before = window.beforeEach

before ->
  @addMatchers
    toHave: (expected, item_name = 'items') ->
      try
        maybe_collection = eval("this.actual.#{item_name}")
        maybe_collection ||= maybe_collection?() || maybe_collection
        length = maybe_collection?.length
      catch error
      length ||= @actual if @actual.length?
      if length?
        @message = -> "Expected #{expected} #{item_name}, found #{length}"
        length is expected
      else
        @message = -> "no collection '#{item_name}' found"
        false



