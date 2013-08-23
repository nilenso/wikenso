#= require spec_helper

describe "PageTextView", ->
  beforeEach =>
    $('body').html(JST['templates/page_text_view'])
    @model = new WikiApp.Models.PageModel

  describe "text", =>
    it "gets the text HTML out of the DOM", =>
      pageTextView = new WikiApp.Views.PageTextView(@model)
      pageTextView.getText().should.equal "<p>Foo</p>"

    it "gets rid of all empty <p> tags in the text", =>
      $(".wiki-pages-view-single-text").html("<p></p><p>Foo</p><p></p>")
      pageTextView = new WikiApp.Views.PageTextView(@model)
      pageTextView.getText().should.equal "<p>Foo</p>"

  describe "on initialize", =>
    it "updates the model with text from the DOM", =>
      new WikiApp.Views.PageTextView(@model)
      @model.get('text').should.equal "<p>Foo</p>"

    it "doesn't trigger a 'change' event", =>
      spy = sinon.spy()
      @model.on('change', spy)
      new WikiApp.Views.PageTextView(@model)
      spy.callCount.should.equal 0

  describe "when adding a link", =>
    event = null
    beforeEach =>
      $("#add-link-modal").hide()
      event = document.createEvent("KeyboardEvent")

    it "brings up the modal dialog", =>
      view = new WikiApp.Views.PageTextView(@model)
      (-> $("#add-link-modal").is(":hidden")).should.change.
      from(true).to(false).
      when -> view.showAddLinkDialog(event)

    it "restores the selected text after the modal has been closed", =>
      view = new WikiApp.Views.PageTextView(@model)
      spy = sinon.spy(rangy, 'restoreSelection')

      view.showAddLinkDialog(event)
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1

    it "adds a link for the selection", =>
      view = new WikiApp.Views.PageTextView(@model)
      spy = sinon.spy(view, 'addLinkForSelection')

      view.showAddLinkDialog(event)
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1

    it "refreshses the link view", =>
      view = new WikiApp.Views.PageTextView(@model)
      spy = sinon.spy(view, 'refreshLinkView')

      view.showAddLinkDialog(event)
      $(".add-link-modal-done").click()
      spy.callCount.should.equal 1

  describe "text selection", =>
    it "checks if the selection has changed", =>
      view = new WikiApp.Views.PageTextView(@model)
      toStringStub = sinon.stub()
      sinon.stub(rangy, 'getSelection').returns(toStringStub)

      stub = sinon.stub(toStringStub, 'toString').returns("Foo")
      view.hasSelectionChanged().should.be.true
      stub.returns("Foo")
      view.hasSelectionChanged().should.be.false
