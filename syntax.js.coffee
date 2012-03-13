
window.context = window.describe
window.before = window.beforeEach

before ->
  @addMatchers
    # Usage:
    #
    # Plain arrays:
    #   expect(["one", "two"]).toHave 2, "strings"
    #
    # Sub collections:
    #   expect({ list_items: ["one", "two"] }).toHave 2, "list_items"
    #
    # Method invocation:
    #   expect({ models: -> ["one", "two"] }).toHave 2, "models"
    toHave: (expected, item_name = 'items') ->
      try
        maybe_collection = eval("this.actual.#{item_name}")
        maybe_collection ||= maybe_collection?() || maybe_collection
        length = maybe_collection?.length
      catch error
      length ||= @actual if @actual.length?
      if length?
        @message = ->
          if @isNot
            "Expected not #{expected} #{item_name}"
          else
            "Expected #{expected} #{item_name}, found #{length}"
        length is expected
      else
        @message = -> "no collection '#{item_name}' found"
        false

    # Usage:
    #   expect(-> model.set({ stuff: "value"})).toTrigger(model, "change:stuff")
    toTrigger: (object, trigger_name) ->
      callback = sinon.spy()
      object.bind(trigger_name, callback)
      @actual()
      @message = -> "Expected '#{trigger_name}' #{if @isNot then "not "} to be fired"
      callback.callCount is 1



