'use strict';

###
* @ngdoc overview
* @name BBAdminDashboard.login.translations
#
* @description
* Translations for the admin login module
###
angular.module('BBAdminDashboard.login.translations')
.config ['$translateProvider', ($translateProvider)->
  $translateProvider.translations('en', {
    'ADMIN_DASHBOARD': {
      'LOGIN_PAGE': {
        'BACK_BTN': 'Back',
        'COMPANIES'                    : 'Companies',
        'DEPARTMENTS'                  : 'Departments',
        'EMAIL_LABEL'                  : 'Email',
        'ENTER_EMAIL'                  : 'Enter your email address',
        'FORGOT_PASSWORD'              : 'Forgot your password?',
        'FORM_SUBMIT_FAIL'             : 'Password Reset request failed',
        'FORM_SUBMIT_SUCCESS'          : 'Password Reset request submitted',
        'FORM_SUBMIT_FAIL_MSG'         : "Sorry we couldn't update your password successfully. Please try again or contact our support team.",
        'FORM_SUBMIT_SUCCESS_MSG'      : 'Thank you for resetting your password. You will receive an email shortly with instructions to complete this process.',
        'HEADING'                      : 'Login to view your account',
        'LOGIN'                        : ' Login',
        'PASSWORD'                     : 'Password',
        'RESET_PASSWORD_BTN'           : 'Reset Password',
        'SITE'                         : 'Site',
        'SEARCH_COMPANY_PLACEHOLDER'   : 'Select or search a company in the list...',
        'SEARCH_DEPARTMENT_PLACEHOLDER': 'Select or search a department in the list...',
        'SELECT'                       : 'Select',
        'SELECT_COMPANY'               : 'Select company',
        'USERNAME'                     : 'Username'
        'ERROR_ISSUE_WITH_COMPANY'     : 'Sorry, there seems to be a problem with the company associated with this account',
        'ERROR_INCORRECT_CREDS'        : 'Sorry, either your email or password was incorrect',
        'ERROR_ACCOUNT_ISSUES'         : 'Sorry, there seems to be a problem with this account',
      }
    }
  })
]