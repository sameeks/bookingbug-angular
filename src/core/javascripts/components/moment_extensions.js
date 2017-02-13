/*

toISODate
Extended moment with toISODate method to format dates for API date parameter assignment. Locale is enforced as `en` to ensure date is formatted correctly.

*/
if (!moment.fn.toISODate) { moment.fn.toISODate = function() { return this.locale('en').format('YYYY-MM-DD'); }; }