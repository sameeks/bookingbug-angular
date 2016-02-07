angular.module('BB.Services').factory "PrintService", ($bbug) ->

  ###**
  * @ngdoc method
  * @name printElement
  * @methodOf BB.Services:PrintService
  * @description
  * Print element by creating popup containing the contents of the specified element
  *
  * @param {string} id The id of the specified element
  * @param {string} stylesheet The stylesheet of popup
  ###
  printElement: (id, stylesheet) ->
    data = $bbug('#'+ id).html()
    # window.open(URL,name,specs,replace)
    # IE8 fix: URL and name params are deliberately left as blank
    # http://stackoverflow.com/questions/710756/ie8-var-w-window-open-message-invalid-argument
    mywindow = $window.open('', '', 'height=600,width=800')

    $timeout () ->
      mywindow.document.write '<html><head><title>Booking Confirmation</title>'

      mywindow.document.write('<link rel="stylesheet" href="' + stylesheet + '" type="text/css" />') if stylesheet
      mywindow.document.write '</head><body>'
      mywindow.document.write data
      mywindow.document.write '</body></html>'
      #mywindow.document.close()

      $timeout () ->
        mywindow.document.close()
        # necessary for IE >= 10
        mywindow.focus()
        # necessary for IE >= 10
        mywindow.print()
        mywindow.close()
      , 100
    , 2000
