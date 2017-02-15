/*
 * @ngdoc overview
 * @name BBAdminDashboard.login.translations
 *
 * @description
 * Translations for the admin login module
 */
angular.module('BBAdminDashboard.login.translations')
    .config(['$translateProvider', $translateProvider =>
        $translateProvider.translations('en', {
            'ADMIN_DASHBOARD': {
                'LOGIN_PAGE': {
                    'COMPANIES': 'Companies',
                    'DEPARTMENTS': 'Departments',
                    'FORGOT_PASSWORD': 'Forgot your password?',
                    'HEADING': 'Login to view your account',
                    'LOGIN': ' Login',
                    'PASSWORD': 'Password',
                    'SITE': 'Site',
                    'SEARCH_COMPANY_PLACEHOLDER': 'Select or search a company in the list...',
                    'SEARCH_DEPARTMENT_PLACEHOLDER': 'Select or search a department in the list...',
                    'SELECT': 'Select',
                    'SELECT_COMPANY': 'Select company',
                    'USERNAME': 'Username',
                    'ERROR_ISSUE_WITH_COMPANY': 'Sorry, there seems to be a problem with the company associated with this account',
                    'ERROR_INCORRECT_CREDS': 'Sorry, either your email or password was incorrect',
                    'ERROR_ACCOUNT_ISSUES': 'Sorry, there seems to be a problem with this account',
                    'ERROR_REQUIRED': 'This field is required.'
                }
            }
        })

    ]);
