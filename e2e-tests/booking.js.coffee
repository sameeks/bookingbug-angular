describe "Standard booking journey:", ->
  waitFor = (selector) ->
    browser.wait protractor.ExpectedConditions.presenceOf($(selector)), 5000
  browser.ignoreSynchronization = true

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
      expect(element(By.css "ul.bb-summary-list .bb-summary-value").getText()).toEqual '1 hour'
  
    it "should move to calendar", ->
      element(By.css '[bb-people] .panel button').click()
      waitFor "[bb-time-ranges]"

  describe "Calendar", ->
    it "should load 7 days on big screens", ->
      waitFor 'li.day[ng-repeat]'
      days = element.all(By.css "li.day[ng-repeat]")
      expect(days.count()).toEqual(7)

    accordion = null
    it "should expand accordions", ->
      accordion = element(By.css "[bb-accordian-range-group]>.panel:not([disabled]")
      accordion.click()

    it "should select a time slot and move to questions", ->
      accordion.element(By.css 'li.time-slot').click()
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
