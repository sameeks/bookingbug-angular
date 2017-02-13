// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
* @ngdoc overview
* @name BBAdminDashboard.reset-password.translations
*
* @description
* Translations for the admin reset-password module
*/
angular.module('BBAdminDashboard.reset-password')
.config(['$translateProvider', $translateProvider =>
  $translateProvider.translations('en', {
    'ADMIN_DASHBOARD': {
      'RESET_PASSWORD_PAGE': {
        'BACK_BTN'                   : 'Back',
        'CONFIRM_NEW_PASSWORD_LBL'   : 'Confirm New Password',
        'EMAIL_LBL'                  : 'Email',
        'ENTER_NEW_PASSWORD'         : 'Enter your new password',
        'ENTER_EMAIL'                : 'Enter your email address',
        'ERROR_API_MISSING'          : 'API url has not been set correctly.',
        'ERROR_EMAIL_INVALID'        : 'Please enter a valid email.',
        'ERROR_PASSWORD_MATCH'       : 'This needs to be the same as the new password.',
        'ERROR_PASSWORD_PATTERN'     : 'Password must be between 7 and 25 characters and contain at least one letter and one number.',
        'ERROR_REQUIRED'             : 'This field is required.',
        'FORGOT_PASSWORD'            : 'Forgot your password?',
        'FORM_SUBMIT_FAIL'           : 'Password Reset request failed',
        'FORM_SUBMIT_SUCCESS'        : 'Password Reset request submitted',
        'FORM_SUBMIT_FAIL_MSG'       : "Sorry we couldn't update your password successfully. Please try again or contact our support team.",
        'FORM_SUBMIT_SUCCESS_MSG'    : 'Thank you for resetting your password. You will receive an email shortly with instructions to complete this process.',
        'NEW_PASSWORD_LBL'           : 'New Password',
        'PASSWORD'                   : 'Password',
        'PASSWORD_RESET_SUCCESS'     : 'Password Reset complete',
        'PASSWORD_RESET_SUCCESS_MSG' : 'Your password has now been successfully updated.',
        'RESET_PASSWORD_BTN'         : 'Reset Password',
        'SITE_LBL'                   : 'Site'
      }
    }
  })

]);
