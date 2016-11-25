###

toISODate
Extended moment with toISODate method to format dates for API date parameter assignment. Locale is enforced as `en` to ensure date is formatted correctly.

###
moment.fn.toISODate ||= -> this.locale('en').format('YYYY-MM-DD')