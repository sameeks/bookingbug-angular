describe "Standard booking journey:", ->
  waitFor = (selector) ->
    browser.wait protractor.ExpectedConditions.presenceOf($(selector)), 8000

  browser.ignoreSynchronization = false
  browser.driver.manage().window().setSize(1024, 768)

  beforeEach ->
    return

  it "Widget should load", ->
    browser.get 'http://localhost:8000/new_booking.html'
    waitFor '[bb-widget] .content'

  describe "Companies", ->
    panel = null
    it "should be loaded and displayed", ->
      waitFor "[bb-companies] .panel"
      panels = element.all(By.css "[bb-companies] .panel")
      expect(panels.count()).toEqual 5
      panel = panels.first()
      expect(panel.element(By.tagName('h2')).getText()).toEqual 'BB Golf - London'

    it "should move to events", ->
      panel.element(By.tagName('button')).click()
      waitFor "[bb-events]"

  describe "Events", ->
    eventCard = null
    it "should be loaded and displayed", ->
      waitFor "[bb-events] .bb-event-card"
      eventCards = element.all(By.css "[bb-events] .bb-event-card")
      expect(eventCards.count()).toEqual 10
      eventCard = eventCards.first()
      expect(eventCards.first().element(By.tagName 'h3').getText()).toEqual 'Improve your handicap'

    it "should have formatted duration", ->
      expect(eventCard.element(By.binding('item.duration')).getText()).toEqual '1 hour'

    it "should have formatted duration", ->
      expect(eventCard.element(By.binding('item.duration')).getText()).toEqual '1 hour'

    it "should move to Event", ->
      eventCard.element(By.tagName('button')).click()
      waitFor "[bb-event]"
