describe "Standard booking journey:", ->
  waitFor = (selector) ->
    browser.wait protractor.ExpectedConditions.presenceOf($(selector)), 8000

  browser.ignoreSynchronization = false
  browser.driver.manage().window().setSize(1024, 768)

  mockModule = require './mocks/checkout.js'

  beforeEach ->
    browser.addMockModule 'bbCheckoutMock', mockModule.bbCheckoutMock
    return

  it "Widget should load", ->
    browser.get 'http://localhost:8888/new_booking.html'
    browser.pause()
    waitFor '[bb-widget] .content'


  describe "Services", ->
    panel = null
    it "should be loaded and displayed", ->
      waitFor "[bb-services] .panel"

      panels = element.all(By.css "[bb-services] .panel")
      expect(panels.count()).toEqual 4
      panel = panels.first()
      expect(panel.element(By.tagName('h2')).getText()).toEqual 'Club Fitting'

    it "should have formatted prices", ->
      expect(panel.element(By.css ".bb-service-price").getText()).toEqual '£50.00'

    it "should move to people", ->
      panel.element(By.tagName('button')).click()
      waitFor "[bb-people]"

  describe "People", ->
    it "should be loaded and displayed", ->
      waitFor "[bb-people] .panel"
      items = element.all(By.css "[bb-people] .panel")
      expect(items.count()).toEqual 2
      expect(items.first().element(By.tagName 'h2').getText()).toEqual 'Derrick C'

    it "should have formatted duration", ->
      expect(element.all(By.css "ul.bb-item-summary-list .bb-summary-value").first().getText()).toEqual '1 hour'

    it "should move to calendar", ->
      element.all(By.css '[bb-people] .panel button').first().click()
      waitFor "[bb-time-ranges]"
      browser.driver.manage().window().setSize(1024, 769) #for some reason not showing available dates if not getting resized

  describe "Calendar", ->
    it "should load 7 days on big screens", ->
      waitFor 'li.day[ng-repeat]'
      days = element.all(By.css "li.day[ng-repeat]")
      expect(days.count()).toEqual(5)

    accordion = null
    it "should expand accordions", ->
      accordion = element.all(By.css "[bb-accordion-range-group]>.panel:not([disabled]").first()
      accordion.click()

    it "should select a time slot and move to questions", ->
      accordion.element(By.css 'li.time-slot:first-child').click()
      element(By.buttonText 'Continue').click()
      waitFor '[bb-client-details]'

  describe "Client details", ->
    it "should be filled to move to next step", ->
      fields = [
        ['client.first_name', 'test']
        ['client.last_name', 'example']
        ['client.email', 'test@example.com']
      ]
      for [model, answer] in fields
        element(By.model model).sendKeys(answer)
      element(By.buttonText 'Continue').click()

      waitFor 'input[name=q19516]'
      element(By.css 'input[name=q19516]').sendKeys('none')
      element(By.css 'input[name=q19515]').sendKeys('180cm')
      element(By.cssContainingText('option', 'Both')).click()
      element(By.buttonText 'Confirm').click()
      waitFor '[bb-basket-summary]'
      element(By.buttonText 'Confirm').click()

  describe "Confirmation", ->
    it "Should show the address on a map", ->
      waitFor 'ui-gmap-google-map'
