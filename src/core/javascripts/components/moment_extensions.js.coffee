###

toISODate
Extended momnent with toISODate method to format dates for API date parameter assignment. Locale is enforced as `en` to ensure date is formated correctly.

###
moment.fn.toISODate ||= -> this.locale('en').format('YYYY-MM-DD')