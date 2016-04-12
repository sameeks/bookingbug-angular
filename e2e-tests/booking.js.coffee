describe "Standard booking journey:", ->
  waitFor = (selector) ->
    browser.wait protractor.ExpectedConditions.presenceOf($(selector)), 8000

  browser.ignoreSynchronization = true
  browser.driver.manage().window().setSize(1024, 768)

  ###
  #TODO: work out why mock modules never get injected even when ignoreSynchronization = false.
  #Temporary fix: examples/checkout_mock.js
  browser.ignoreSynchronization = false
  checkoutResponse = require './mocks/checkout.json'
  checkoutMock = ->
    checkoutResponse = arguments[0]
    angular.module('checkoutMock', ['ngMockE2E']).run ($httpBackend) ->
      $httpBackend.whenPOST(/.*checkout/).respond(checkoutResponse)
      $httpBackend.whenPOST(/.* /).passThrough()
      $httpBackend.whenGET(/.* /).passThrough()

    angular.module('BB').requires.push('checkoutMock')
  browser.addMockModule 'checkoutMock', checkoutMock
  ###
  it "Widget should load", ->
    browser.get 'http://localhost:8888/new_booking.html'
    waitFor '[bb-widget] .content'

  describe "Services", ->
    item = null
    it "should be loaded and displayed", ->
      waitFor "[bb-services] .item"
      items = element.all(By.css "[bb-services] .item")
      expect(items.count()).toEqual 4
      item = items.first()
      expect(item.element(By.tagName('h2')).getText()).toEqual 'Club Fitting'

    it "should have formatted prices", ->
      expect(item.element(By.css ".bb-service-price").getText()).toEqual '£50.00'

    it "should move to people", ->
      item.element(By.tagName('button')).click()
      waitFor "[bb-people]"

  describe "People", ->
    it "should be loaded and displayed", ->
      waitFor "[bb-people] .panel"
      items = element.all(By.css "[bb-people] .panel")
      expect(items.count()).toEqual 2
      expect(items.first().element(By.tagName 'h2').getText()).toEqual 'Derrick C'

    it "should have formatted duration", ->
      expect(element.all(By.css "ul.bb-summary-list .bb-summary-value").first().getText()).toEqual '1 hour'
  
    it "should move to calendar", ->
      element.all(By.css '[bb-people] .panel button').first().click()
      waitFor "[bb-time-ranges]"

  describe "Calendar", ->
    it "should load 7 days on big screens", ->
      waitFor 'li.day[ng-repeat]'
      days = element.all(By.css "li.day[ng-repeat]")
      expect(days.count()).toEqual(7)

    accordion = null
    it "should expand accordions", ->
      accordion = element.all(By.css "[bb-accordian-range-group]>.panel:not([disabled]").first()
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
      waitFor '[bb-total]'

  describe "Confirmation", ->
    it "Should show the address on a map", ->
      waitFor 'ui-gmap-google-map'
