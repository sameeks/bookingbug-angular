angular.module('BB.i18n').service('bbLocale', function(bbi18nOptions, $log, $translate, $window) {
  'ngInject';

  let _localeCompanyUsed = false;

  let determineLocale = function() {

    if (($translate.use() !== 'undefined') && angular.isDefined($translate.use()) && isAvailable($translate.use())) {
      setLocale($translate.use(), '$translate.use() locale');
    } else {
      let browserLocale = $translate.negotiateLocale($translate.resolveClientLocale()); //browserLocale = $window.navigator.language;
      let defaultLocale = bbi18nOptions.default_language;
      let URIParamLocale = $window.getURIparam('locale');

      if (URIParamLocale && isAvailable(URIParamLocale)) {
        setLocale(URIParamLocale, 'URIParam locale');
      } else if (bbi18nOptions.use_browser_language && isAvailable(browserLocale)) {
        setLocale(browserLocale, 'browser locale');
      } else {
        setLocale(defaultLocale, 'default locale');
      }
    }

    $translate.preferredLanguage(getLocale());

  };

  /*
   * @param {String} locale
   * @param {String} setWith
   */
  var setLocale = function(locale, setWith) {
    if (setWith == null) { setWith = ''; }
    if (!isAvailable(locale)) {
      return;
    }

    moment.locale(locale); // TODO we need angular wrapper for moment
    $translate.use(locale);

    //console.info('bbLocale.locale = ', locale, ', set with: ', setWith)

    if ((locale !== moment.locale()) || (locale !== $translate.use())) {
      console.error(`moment locale not available, preferred locale = ${locale}, moment.locale() = `, moment.locale(), '$translate.use() = ', $translate.use());
    }

  };

  /*
   * {String} locale
   */
  var isAvailable = locale => bbi18nOptions.available_languages.indexOf(locale) !== -1;

  /*
   * @returns {String}
   */
  var getLocale = () => $translate.use();

  /*
    * It's a hacky way to map country code to specific locale. Reason is moment default is set to en_US
    * @param {string} countryCode
    */
  let setLocaleUsingCountryCode = function(countryCode) {
    if (_localeCompanyUsed) {
      return; //can be set only once
    }
    _localeCompanyUsed = true;

    if (countryCode && countryCode.match(/^(gb|au)$/)) {
      let locale = `en-${countryCode}`;
      setLocale(locale, 'countryCode');
    }
  };

  return {
    determineLocale,
    getLocale,
    setLocale,
    setLocaleUsingCountryCode
  };});
