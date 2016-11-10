'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.reset-password.translations
#
* @description
* Translations for the admin reset-password module
###
angular.module('BBAdminDashboard.reset-password.translations')
.config ['$translateProvider', ($translateProvider)->
  $translateProvider.translations('en', {
    'ADMIN_DASHBOARD': {
      'RESET_PASSWORD_PAGE': {
        'BACK_BTN'                : 'Back',
        'EMAIL_LABEL'             : 'Email',
        'ENTER_EMAIL'             : 'Enter your email address',
        'FORGOT_PASSWORD'         : 'Forgot your password?',
        'FORM_SUBMIT_FAIL'        : 'Password Reset request failed',
        'FORM_SUBMIT_SUCCESS'     : 'Password Reset request submitted',
        'FORM_SUBMIT_FAIL_MSG'    : "Sorry we couldn't update your password successfully. Please try again or contact our support team.",
        'FORM_SUBMIT_SUCCESS_MSG' : 'Thank you for resetting your password. You will receive an email shortly with instructions to complete this process.',
        'PASSWORD'                : 'Password',
        'RESET_PASSWORD_BTN'      : 'Reset Password'
      }
    }
  })
]
