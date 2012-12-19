num = String(Math.random()).replace '.',''


window.datasets = new Cu.Collection.DatasetList()
window.tools = new Cu.Collection.Tools()

tools.push new Cu.Model.Tool
  name: 'highrise'
  displayName: 'Highrise'
  box_name: 'highrise-' + num.substring(num.length, num.length - 4)
  importer: true

tools.push new Cu.Model.Tool
  name: 'newdataset'
  displayName: 'New Dataset'
  box_name: 'newdataset-' + num.substring(num.length, num.length - 4)
  importer: true

Backbone.View::close = ->
  @$el.off()
  @off()

class Cu.Router.Main extends Backbone.Router

  initialize: ->
    @route RegExp('^/?$'), 'main'
    @route RegExp('tool/([^/]+)/?'), 'tool'
    @route RegExp('dataset/([^/]+)/?'), 'dataset'
    @route RegExp('new-profile/?'), 'newProfile'
    @route RegExp('set-password/([^/]+)/?'), 'setPassword'

  main: ->
    # TODO: Move into AppView
    # TODO: Move into nav view
    window.sidebar = new Cu.View.SideBar()
    $('nav').append window.sidebar.render().el

    window.sitelinks = new Cu.View.SiteLinks()
    $('nav').append window.sitelinks.render().el

    window.userlinks = new Cu.View.UserLinks()
    $('nav').append window.userlinks.render().el

    window.datasets.fetch
      success: ->
        window.dataset_list = new Cu.View.DatasetList {collection: window.datasets}
        $('#content').html window.dataset_list.render().el

  tool: (tool) ->
    window.header?.close?()
    model = window.tools.get tool
    window.box = model.get 'box_name'
    $('body').attr 'class', 'tool'
    window.header = new Cu.View.ToolHeader {model: model}
    window.content = new Cu.View.ToolContent {model: model}

  dataset: (id) ->
    window.header?.close?()
    mod = null
    mod = new Cu.Model.Dataset
      user: window.user.effective.shortName
      _id: id
    mod.fetch
      success: (model, resp, options) ->
        window.header = new Cu.View.DatasetHeader {model: model}
        window.content = new Cu.View.DatasetContent { model: model }
      error: (model, xhr, options) ->
        console.warn xhr


  newProfile: ->
    $('body').attr 'class', 'admin'
    window.header = new Cu.View.AdminHeader title: 'Create a new profile'
    window.content = new Cu.View.AdminContent()

  setPassword: ->
    window.header = new Cu.View.HomeHeader()
    window.content = new Cu.View.SetPassword()
