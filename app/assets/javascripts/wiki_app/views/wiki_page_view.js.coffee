class WikiApp.Views.WikiPageView extends Backbone.View
  el: ".wiki-pages-view-single"

  events:
    "click .wiki-pages-view-single-actions-item.publish": "submitShadowForm"

  shortcuts:
    '⌘+s': "throttledSaveModel"
    'ctrl+s': "throttledSaveModel"

  initialize: (@model) =>
    _.extend(this, new Backbone.Shortcuts)
    @delegateShortcuts()

    @title = new WikiApp.Views.PageTitleView(@model)
    @text = new WikiApp.Views.PageTextView(@model)

    @savingIndicator = new WikiApp.Views.SavingIndicatorView
    @helpText = new WikiApp.Views.HelpTextView
    @errorView = new WikiApp.Views.ErrorView
    @shadowFormView = new WikiApp.Views.ShadowFormView(@model)

    @model.set('id', @getId(), silent: true)
    @model.setAutoSaveCallbacks(
      success: _.sequence(@savingIndicator.saved, @errorView.hide)
      request: @savingIndicator.saving,
      error: => @errorView.show("An error has occured while saving the page. Please try again.")
    )
    @text.focus()

  getId: =>
    this.$el.data('draft-page-id')

  throttledSaveModel: (event) =>
    @throttledSaveModelFunc ||= _.throttle(@model.autoSave, 1000)
    @throttledSaveModelFunc()
    event.preventDefault()

  submitShadowForm: =>
    @shadowFormView.submit()