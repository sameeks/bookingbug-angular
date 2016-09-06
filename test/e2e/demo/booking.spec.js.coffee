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
    return

  xdescribe "Can load stores", ->
    it "in London", ->
      waitFor "[bb-map] form"

      form = element(By.css("[bb-map] form"))
      stores = element.all(By.css("[accordion-group]"))

      expect(stores.count()).toBe 0

      form.element(By.model('address')).sendKeys 'London'
      form.element(By.tagName('button')).click()

      expect(stores.count()).toBe 5
      expect(stores.first().element(By.tagName 'h4').getText()).toEqual "1. BB Golf - London"
      return

    return

  return
