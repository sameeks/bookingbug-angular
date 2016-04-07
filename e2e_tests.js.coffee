describe "Standard booking journey", ->
  item = null
  it "Should display services", ->
    browser.ignoreSynchronization = true
    browser.get 'http://localhost:8888/new_booking.html'
    browser.sleep(1000)
    items = element.all(By.css "[bb-services] .item")
    expect(items.count()).toEqual 4
    item = items.first()
    expect(item.element(By.tagName('h2')).getText()).toEqual 'Club Fitting'
