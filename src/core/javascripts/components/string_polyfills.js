// String::includes polyfill
if (!String.prototype.includes) {

  String.prototype.includes = function(search, start) {
    if (typeof start !== 'number') {
      start = 0;
    }
    if ((start + search.length) > this.length) {
      return false;
    } else {
      return this.indexOf(search, start) !== -1;
    }
  };
}

// Extend String with parameterise method
String.prototype.parameterise = function(seperator) {
  if (seperator == null) { seperator = '-'; }
  return this.trim().replace(/\s/g,seperator).toLowerCase();
};

