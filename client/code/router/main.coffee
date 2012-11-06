window.MainRouter = class MainRouter extends Backbone.Router
  routes:
    "": "main"
    "tool/:tool": "tool"

  header: null
  content: null

  main: ->
    $.get 'apikey', (data) ->
      window.apikey = data
      model = new ToolModel { id: 1, name: 'highrise' }
      $('body').attr 'class', ''
      @header = new HomeHeaderView()
      @content = new HomeContentView {model: model}

  tool: (tool) ->
    num = String(Math.random()).replace '.',''
    model = new ToolModel
      name: 'highrise'
      box_name: 'highrise-' + num.substring(num.length, num.length - 4)
    window.user = 'cotest'
    window.box = model.get 'box_name'
    $('body').attr 'class', 'tool'
    @header = new ToolHeaderView {model: model}
    @content = new ToolContentView {model: model}
