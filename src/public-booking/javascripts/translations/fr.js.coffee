'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        AVAILABLE: "{number, plural, =0{Aucun disponible} one{1 disponible} other{# disponibles}}"
      }
      ALERTS: {
        ACCOUNT_DISABLED: "Votre compte semble desactivé. Merci de contacter le commerce si le problème persiste"
        ALREADY_REGISTERED: "Il y a déjà un compte pour cette addresse email. Veuillez vous connecter ou changer votre mot de passe."
        APPT_AT_SAME_TIME: "Votre rendez-vous est déja réservé à la même heure"
        ATTENDEES_CHANGED: "Votre réservation a été mise à jour"
        EMAIL_ALREADY_REGISTERED_ADMIN: "Il y a déjà un compte associé à cette addresse mail. Utilisez le champ de research."
        EMPTY_BASKET_FOR_CHECKOUT:"Il n'y a aucun élément dans le panier."
        FB_LOGIN_NOT_A_MEMBER: "Aucun compte associé à ce compte Facebook. Veuillez vous enregistrer avec Facebook d'abord"
        FORM_INVALID: "Saisissez tous les champs obligatoires"
        GENERIC:"Désolé, il semble qu'une erreur s'est produite. Essayez de nouveau et contactez le service client si le problème persiste."
        GEOLOCATION_ERROR: "Désolé, nous n'avons pas pu déterminer votre location. Veuillez entrer une location."
        GIFT_CERTIFICATE_REQUIRED: "Cette réservaction nécessited une carte cadeau"
        INVALID_POSTCODE: "@:COMMON.FORM.POSTCODE_PATTERN"
        ITEM_NO_LONGER_AVAILABLE: "Désolé. L'article que vous souhaitez réserver n'est plus disponible."
        NO_WAITLIST_SPACES_LEFT: "Désolé, la place a été prise, vous êtes sur liste d'attente et nous vous écririons quand plus de places seront disponibles"
        LOCATION_NOT_FOUND: "Désolé, nous ne reconnaissons pas cet adresse"
        LOGIN_FAILED: "Désolé, votre email ou mot de passe n'a pas été reconnu. Merci de réessayer ou de changer votre mot de passe"
        SSO_LOGIN_FAILED: "Il y a eu une erreur de connection. Veuillez réessayer."
        MAXIMUM_TICKETS: "Désolé, le nombre maximum de billets par personne a été dépassé."
        MISSING_LOCATION: "Saisissez votre adresse"
        MISSING_POSTCODE: "Saisissez votre code postal"
        PASSWORD_INVALID: "Désolé, votre mot de passe n'est pas valide"
        PASSWORD_MISMATCH: "Vos mots de passe sont différents"
        PASSWORD_RESET_FAILED: "Désolé, nous n'avons pas pu mettre votre mot de passe à jour. Merci de réessayer"
        PASSWORD_RESET_REQ_FAILED: "Désolé, nous n'avons pas trouvé de compte pour cet email."
        PASSWORD_RESET_REQ_SUCCESS: "Nous avons envoyé un email avec un lien pour changer votre mot de passe."
        PASSWORD_RESET_SUCESS: "Votre mot de passe a été mis à jour."
        PAYMENT_FAILED: "Le paiement a échoué. Veuillez contacter votre banque ou essayer une autre carte"
        PHONE_NUMBER_ALREADY_REGISTERED_ADMIN: "Il y a déjà un compte associé à ce numéro de téléphone. Utilisez le champ de research."
        REQ_TIME_NOT_AVAIL: "Ce créneau est pris, merci d'en choisir un autre."
        TIME_SLOT_NOT_SELECTED: "Veuillez choisir un créneau"
        STORE_NOT_SELECTED: "Veuillz choisir un magasin."
        TOPUP_FAILED: "Désolé, votre porte-feuille n'a pas pu être rechargé, veuillez réessayer."
        TOPUP_SUCCESS: "Votre portefeuille a été rechargé"
        UPDATE_FAILED: "Mise à jour ratée. Merci de réessayer"
        UPDATE_SUCCESS: "Mis à jour"
        WAITLIST_ACCEPTED: "Votre réservation est confirmée !"
        BOOKING_CANCELLED: "Votre réservation a été annulée."
        NOT_BOOKABLE_PERSON: "Désolé, cette personne n'offre pas ce service, veuillez choisir quelqu'un d'autre"
        NOT_BOOKABLE_RESOURCE: "Désolé, cette resource n'offre pas ce service, veuillez en choisir une autre"
        SPEND_AT_LEAST: "Le montant minimal pour une réservation est de {{min_spend | pretty_price}}."
      }
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_MSG: "Votre réservation a été déplacée au {{datetime | datetime: 'LLLL'}}"
        MOVE_BOOKING_FAIL_MSG: "La réservation n'a pas pu être déplacée. Merci de réessayer"
      }
      ADD_RECIPIENT: {
        MODAL_TITLE: "@:COMMON.TERMINOLOGY.RECIPIENT"
        WHO_TO_QUESTION: "Pour qui est le cadeau ?"
        WHO_TO_OPTION_ME: "Moi"
        WHO_TO_OPTION_NOT_ME: "Quelqu'un d'autre"
        NAME_LABEL: "Nom"
        NAME_VALIDATION_MSG: "Veuillez entrer le nom complet du destinataire"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
        ADD_LABEL: "Ajouter un destinataire"
        CANCEL_LABEL: "@:COMMON.BTN.CANCEL"
      }
      BASKET_DETAILS: {
        BASKET_DETAILS_TITLE: "Détails du panier"
        BASKET_DETAILS_NO: "Aucun élément dans votre panier."
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        BASKET_ITEM_APPOINTMENT: "@:COMMON.TERMINOLOGY.APPOINTMENT"
        TIME_AND_DURATION: "{{ time | datetime: 'LLLL':false}} pour {{ duration | time_period }}"
        PROGRESS_CANCEL: "@:COMMON.BTN.CANCEL"
        BASKET_CHECKOUT: "@:COMMON.BTN.CHECKOUT"
        BASKET_STATUS: "{N, plural, =0 {vide}, one {Un article dans votre panier}, others {# articles dans votre panier}}"
      }
      BASKET_ITEM_SUMMARY: {
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DURATION: "@:COMMON.TERMINOLOGY.DURATION"
        ITEM_RESOURCE: "@:COMMON.TERMINOLOGY.RESOURCE"
        ITEM_PERSON: "@:COMMON.TERMINOLOGY.PERSON"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:COMMON.TERMINOLOGY.TIME"
      }
      CALENDAR: {
        PROGRESS_NEXT: "@:CORE.BTN.NEXT"
        PROGRESS_MOVE_BOOKING: "@:CORE.BTN.BOOK"
        BACK_BTN: "@:CORE.BTN.BACK"
      }
      CATEGORY : {
        APPOINTMENT_TYPE: "Type de rdv"
        PROGRESS_BOOK: "@:COMMON.BTN.BOOK"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CANCEL_MODAL: {
        CANCEL_QUESTION: "Êtes-vous sûr que vous voulez annuler cette réservation?"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_WHEN: "@:COMMON.TERMINOLOGY.WHEN"
        PROGRESS_CANCEL_BOOKING: "@:COMMON.BTN.CANCEL_BOOKING"
        PROGRESS_CANCEL_CANCEL: "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
      }
      CHECK_ITEMS : {
        REVIEW: "Examen"
        DETAILS_TITLE: "Détail de votre rendez-vous"
        DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_REQURIED"
        DETAILS_PHONE_MOBILE: "@:COMMON.FORM.MOBILE"
        DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        ITEM_DETAILS: {
          DETAILS_OTHER_INFO: "Autre Information"
          DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
          REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED_LABEL fields"
        }
        PROGRESS_CONFIRM: "@:COMMON.BTN.CONFIRM"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CHECKOUT: {
        PAYMENT_WORD: "Paiement"
        PAYMENT_DETAILS_TITLE: "Détails de paiement"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CHECKOUT_EVENT: {
        EVENT_PAYMENT: "Merci de finir le paiement pour confirmer votre réservation"
        EVENT_TICKETS: "@:COMMON.TERMINOLOGY.TICKETS"
        ITEM_TYPE: "Type"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Quantité"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        COUNT_AS: "for {{count_as}}"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CLIENT: {
        DETAILS_TITLE: "Vos coordonnées"
        CLIENT_DETAILS_TITLE: "Détails du client"
        REQUIRED_FIELDS: "@:COMMON.FORM.FIELD_REQUIRED"
        DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
        DETAILS_PHONE_MOBILE: "@:COMMON.FORM.MOBILE"
        DETAILS_OTHER_INFO: "Autre Information"
        DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        PROGRESS_CONTINUE: "@:COMMON.BTN.NEXT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        PROGRESS_CLEAR: "@:COMMON.BTN.CLEAR"
      }
      COMPANY_CARDS: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      COMPANY_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CONFIRMATION: {
        CONFIRMATION_BOOKING_TITLE: "Confirmation de réservation"
        CONFIRMATION_BOOKING_SUBHEADER: "Merci {{member_name}}. Votre réservation est à présent confirmée. Nous vous avons envoyé par email les informations ci-dessous."
        ITEM_CONFIRMATION: "Confirmation"
        CONFIRMATION_BOOKING_SUBHEADER_WITH_WAITLIST: "Merci {{ member_name }}. Votre réservation a été effectuée avec succès. Nous vous avons envoyé par email les informations ci-dessous."
        PRINT: "@:COMMON.TERMINOLOGY.PRINT"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:COMMON.TERMINOLOGY.TIME"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
      }
      MEMBER_LOGIN_FORM: {
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_VALIDATION_REQUIRED_MESSAGE: "@:COMMON.FORM.EMAIL_REQUIRED"
        EMAIL_VALIDATION_PATTERN_MESSAGE: "@:COMMON.FORM.EMAIL_PATTERN"
        PASSWORD_LABEL: "@:COMMON.FORM.PASSWORD"
        PLEASE_ENTER_PASSWORD: "Veuillez entrer le mot de passe"
        REMEMBER_ME: "Rester connecter"
        LOGIN: "@:COMMON.FORM.LOGIN"
      }
      MONTH_PICKER: {
        PROGRESS_PREVIOUS: "Précédent"
        PROGRESS_NEXT: "Suivant"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LABEL: "Exporter vers un calendrier"
        SHORT_EXPORT_LABEL: "@:COMMON.TERMINOLOGY.EXPORT"
      }
      PRICE_FILTER: {
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
      }
      SERVICE_LIST_FILTER: {
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_SERVICE_PLACEHOLDER: "@:COMMON.TERMINOLOGY.SERVICE"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
      }
      WEEK_CALENDAR: {
        ALL_TIMES_IN: "Le fuseau horaire est {{time_zone_name}}."
        NO_AVAILABILITY: "{time_range_length, plural, Aucune disponibilité pour one{le prochain jour} other{les prochains {time_range_length} jours}}"
        NEXT_AVAIL: "Aller au prochain jour réservable"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        ANY_DATE: "- Date -"
      }
      BASKET: {
        BASKET_TITLE: "Votre Panier"
        BASKET_ITEM_NO: "Aucun élément dans votre panier."
        BASKET_ITEM_ADD_INSTRUCT: "Cliquez sur le bouton 'Ajouter un autre article' si vous souhaitez ajouter un autre produit ou service."
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        BASKET_RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        BASKET_CERTIFICATE_PAID: "Chèques-cadeaux payés"
        BASKET_GIFT_CERTIFICATES: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_PRICE_ORIGINAL: "Prix d'origine"
        BASKET_BOOKING_FEE: "@:COMMON.TERMINOLOGY.BOOKING_FEE"
        BASKET_GIFT_CERTIFICATES_TOTAL: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_GIFT_CERTIFICATE_BALANCE: "La valeur restante de vos chèques-cadeaux"
        BASKET_COUPON_DISCOUNT: "Coupon"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_BALANCE: "Balance du Portefeuille"
        BASKET_WALLET_BALANCE_INSUFFICIENT: "Oh non! Vous n'avez pas assez d'argent dans votre Portefeuille. Vous pouvez soit payer le montant intégral, soit recharger votre Portefeuille."
        BASKET_WALLET_REMAINDER_PART_ONE: "Vous aurez encore "
        BASKET_WALLET_REMAINDER_PART_TWO: " dans votre Portefeuille après cet achat"
        BASKET_WALLET_TOP_UP: "@:COMMON.BTN.TOP_UP"
        BASKET_COUPON_APPLY: "Appliquer un coupon"
        PROGRESS_APPLY: "@:COMMON.BTN.APPLY"
        VOUCHER_BOX: {
          BASKET_GIFT_CERTIFICATE_QUESTION: "Avez-vous un chèque-cadeau?"
          BASKET_GIFT_CERTIFICATE_APPLY: "Utiliser un chèque-cadeau"
          BASKET_GIFT_CERTIFICATE_APPLY_ANOTHER: "Utiliser une autre chèque-cadeau"
          VOUCHER_CODE_PLACEHOLDER: "Enter a voucher code"
          PROGRESS_APPLY: "@:COMMON.BTN.APPLY"
        }
        PROGRESS_CANCEL: "@:COMMON.BTN.CANCEL"
        BASKET_ITEM_ADD: "Ajouter un autre élément"
        BASKET_CHECKOUT: "@:COMMON.BTN.CHECKOUT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BASKET_SUMMARY: {
        STEP_TITLE: "Résumé"
        STEP_DESCRIPTION: "Merci de vérifier ces détails"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.DATE/Time"
        DURATION_LABEL: "@:COMMON.TERMINOLOGY.DURATION"
        FULL_NAME_LABEL: "@:COMMON.FORM.FULL_NAME"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        ADDRESS_LABEL: "@:COMMON.FORM.ADDRESS"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        CONFIRM_BTN: "@:COMMON.BTN.CONFIRM"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      BASKET_WAITLIST: {
        WAITLIST_BOOKING_TITLE: "Votre réservation est sur liste d'attente"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.DATE/Time"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        PROGRESS_BOOK: "@:COMMON.BTN.BOOK"
        CONFIRMATION_SUMMARY: {
          BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
          BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        }
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        CONFIRMATION_WAITLIST_SUBHEADER: "Merci d'avoir réservé {{ purchase_item }}, {{ member_name }}."
        PRINT: "@:COMMON.TERMINOLOGY.PRINT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      ERROR_MODAL: {
        PROGRESS_OK: "@:COMMON.BTN.OK"
      }
      MEMBER_FORM: {
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        PHONE_LABEL: "@:COMMON.FORM.PHONE"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        SAVE_BTN: "@:COMMON.BTN.SAVE"
      }
      BASKET_WALLET: {
        BASKET_WALLET_MAKE_PAYMENT: "effectuer le paiement"
        BASKET_WALLET_SHOW_TOP_UP_BOX: "@:COMMON.BTN.TOP_UP"
        BASKET_WALLET_TOP_UP: "@:COMMON.BTN.TOP_UP"
        BASKET_WALLET_AMOUNT: "Montant"
        BASKET_WALLET: "@:COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_AMOUNT_MINIMUM: "Le montant de recharge minimum doit être supérieur"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      DASH: {
        DASHBOARD: "Tableau de bord"
        DASHBOARD_TITLE: "Choisissez un emplacement / @:COMMON.TERMINOLOGY.SERVICE"
      }
      DAY: {
        AVAIL_MONTH_PREVIOUS: "Mois Précédent"
        AVAIL_MONTH_NEXT: "Mois suivant"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DATE_NOT_SELECTED: "Veuillez choisir une date"
      }
      DEAL_LIST: {
        BASKET_GIFT_CERTIFICATE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BASKET_GIFT_CERTIFICATE_BUY: "Acheter un chèque-cadeau"
        BASKET_GIFT_CERTIFICATE_SELECTED: "Chèques-cadeaux sélectionnés"
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        FORM: {
          RECIPIENT_ADD: "Ajouter un destinataire"
          RECIPIENT_NAME: "Recipient Name"
          DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
          PROGRESS_ADD: "Ajouter"
          RECIPIENT_NAME_VALIDATION_MSG: "Ecrivez le nom complet du destinataire"
          RECIPIENT_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_REQUIRED"
        }
        RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        RECIPIENT_NAME: "@:COMMON.FORM.LAST_NAME"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        PROGRESS_BUY: "Acheter"
        BACK_BTN: "@:COMMON.BTN.BACK"
        CERTIFICATE_NOT_SELECTED_ALERT: "Il vous faut au moins un chèque-cadeau pour continuer"
      }
      DURATION_LIST: {
        ITEM_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DURATON_NOT_SELECTED_ALERT: "Merci de choisir une durée"
      }
      EVENT: {
        EVENT_DETAILS_TITLE: "Détails de l'événement"
        ITEM_TYPE: "Type"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Qty"
        ITEM_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        EVENT_SOLD_OUT: "Sold Out"
        ADD_ONS: "Add-ons"
        SUBTOTAL: "Subtotal"
        BASKET_GIFT_CERTIFICATE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATE"
        BASKET_DISCOUNT: "Discount"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_DUE_TOTAL: "Due Total"
        BASKET_GIFT_CERTIFICATE_QUESTION: "Have a gift certificate?"
        BASKET_GIFT_CERTIFICATE_APPLY: "Apply a gift Certificate"
        GIFT_CERTIFICATE_CODE_PLACEHOLDER: "Enter your certificate code"
        PROGRESS_APPLY: "@:COMMON.BTN.APPLY"
        BASKET_GIFT_CERTIFICATES_APPLIED: "Gift Certificates applied"
        BASKET_REMOVE_DEAL: "Remove"
        BASKET_GIFT_CERTIFICATE_BALANCE: "Remaining Gift Certificate balance"
        DETAILS_TITLE: "Vos coordonnées"
        DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
        STORE_PHONE: "@:COMMON.FORM.PHONE"
        DETAILS_PHONE_MOBILE_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        DETAILS_ADDRESS: "@:COMMON.FORM.ADDRESS"
        DETAILS_ADDRESS_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        DETAILS_TOWN: "@:COMMON.FORM.ADDRESS3"
        DETAILS_COUNTY: "@:COMMON.FORM.ADDRESS4"
        DETAILS_POSTCODE: "@:COMMON.FORM.POSTCODE"
        INVALID_POSTCODE: "@:COMMON.FORM.POSTCODE_PATTERN"
        DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        UIB_ACCORDION: {
          TICKET_WORD: "Ticket"
          DETAILS_WORD: "details"
          ATTENDEE_IS_YOU_QUESTION: "Êtes-vous le participant?"
          ATTENDEE_USE_MY_DETAILS: " Utiliser mes coordonnées"
          DETAILS_FIRST_NAME: "@:COMMON.FORM.FIRST_NAME"
          DETAILS_LAST_NAME: "@:COMMON.FORM.LAST_NAME"
          DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
          DETAILS_EMAIL_VALIDATION_MSG: "@:COMMON.FORM.EMAIL_PATTERN"
          DETAILS_VALIDATION_MSG: "@:COMMON.FORM.FIELD_REQUIRED"
        }
        DETAILS_TERMS: "@:COMMON.FORM.TERMS_AND_CONDITIONS"
        DETAILS_TERMS_VALIDATION_MSG: "@:COMMON.FORM.TERMS_AND_CONDITIONS_REQUIRED"
        TICKET_WORD: "Ticket"
        DETAILS_WORD: "details"
        RESERVE_TICKET: "Reserve Ticket"
        LETTER_S: "s"
        EVENT_JOIN_WAITLIST: "Join Waitlist"
        BOOK_TICKET: "@:COMMON.BTN.BOOK Ticket"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      EVENT_GROUP_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
      }
      EVENT_LIST: {
        EVENT_LOCATION: "Evénements à"
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY_CATEGORY: "@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        FILTER_ANY_PRICE: '@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.PRICE'
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        EVENT_SOLD_OUT_HIDE: "Cacher les événements indisponibles"
        EVENT_SOLD_OUT_SHOW: "Afficher les événements indisponibles"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
        FILTER_NONE: "Tous les événements"
        FILTER_FILTERED: "Afficher les événements filtrés"
        EVENT_WORD: "@:COMMON.TERMINOLOGY.EVENTS"
        EVENT_NO: "Aucun événement trouvé"
        EVENT_SPACE_WORD: "place"
        EVENT_LEFT_WORD: "restant"
        ITEM_FROM: "À partir de"
        PROGRESS_BOOK_EVENT: "@:COMMON.BTN.BOOK @:COMMON.TERMINOLOGY.EVENT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        EVENT_SOLD_OUT: "Épuisé"
        EVENT_JOIN_WAITLIST: "S'inscrire sur la liste d'attente"
      }
      MAIN: {
        POWERED_BY: "Réservations par"
      }
      MAP: {
        PROGRESS_SEARCH: "Rechercher"
        SEARCH_BTN_TITLE: "Rechercher"
        INPUT_PLACEHOLDER: "Saisissez une ville, un code postal ou un magasin"
        GEOLOCATE_TITLE: "Utilisez votre emplacement actuel"
        STORE_RESULT_TITLE: "{results, plural, =0{Aucun réultat trouvé} one{1 résultat trouvé} other{# résultats trouvés}} pour les magasins à proximité de {address}"
        HIDE_STORES: "Masquer les magasins sans disponibilité"
        SERVICE_UNAVAILABLE: "Désolé mais {{name}} n'est pas disponible dans ce magasin"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        UIB_ACCORDION: {
          PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
          SERVICE_UNAVAILABLE: "Désolé mais {{name}} n'est pas disponible dans ce magasin"
        }
      }
      MEMBERSHIP_LEVELS: {
        MEMBERSHIP_TYPES: "Types d'adhésion"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
      }
      TIME: {
        AVAIL_DAY_PREVIOUS: "Jour Précédent"
        AVAIL_DAY_NEXT: "Jour suivant"
        AVAIL_NO: "Aucun @:COMMON.TERMINOLOGY.SERVICE disponible"
        BACK_BTN: "@:COMMON.BTN.BACK"
        TIME_NOT_SELECTED_ALERT: "Veuillez choisir un créneau"
        AVAIL_MORNING: "Matin"
        AVAIL_AFTERNOON: "Après-midi"
        AVAIL_EVENING: "Soir"
      }
      SURVEY: {
        SURVEY_THANK_YOU: "Merci d'avoir rempli le questionnaire !"
        ITEM_SESSION: "@:COMMON.TERMINOLOGY.SESSION"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        SURVEY_WORD: "Enquête"
        DETAILS_QUESTIONS: "@:COMMON.TERMINOLOGY.QUESTIONS"
        SURVEY_SUBMIT: "@:COMMON.BTN.SUBMIT"
        SURVEY_NO: "Aucune question de l'enquête pour cette session."
      }
      SERVICE_LIST: {
        ITEM_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        SERVICE_LIST_NO: "Aucun service ne répond à vos critères de filtrage."
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESOURCE_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESCHEDULE_REASONS:{
        MOVE_TITLE: "Déplacer le rendez-vous"
        MOVE_REASON: "Veuillez choisir une raison :"
        MOVE_BTN: "Déplacer"
        }
      PURCHASE: {
        CANCEL_CONFIRMATION: "Votre réservation a été annulée."
        CONFIRMATION_PURCHASE_TITLE: "Votre {{ service_name }} réservation"
        RECIPIENT_NAME: "@:COMMON.FORM.LAST_NAME"
        PRINT: "@:COMMON.TERMINOLOGY.PRINT"
        DETAILS_EMAIL: "@:COMMON.FORM.EMAIL"
        ITEM_SERVICE: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_WHEN: "@:COMMON.TERMINOLOGY.WHEN"
        ITEM_PRICE: "@:COMMON.TERMINOLOGY.PRICE"
        PROGRESS_CANCEL_BOOKING: "@:COMMON.BTN.CANCEL_BOOKING"
        PROGRESS_MOVE_BOOKING: "Modifier la réservation"
        PROGRESS_BOOK_WAITLIST_ITEMS: "Réserver des articles en liste d'attente"
      }
      PRINT_PURCHASE: {
        CONFIRMATION_BOOKING_TITLE: "Confirmation de réservation"
        CONFIRMATION_BOOKING_SUBHEADER: "Merci {{member_name}}. Votre réservation est à présent confirmée. Nous vous avons envoyé par email les informations ci-dessous."
        CALENDAR_EXPORT_TITLE: "@:COMMON.TERMINOLOGY.EXPORT"
        PRINT: "@:COMMON.TERMINOLOGY.PRINT"
        AND: "@:COMMON.TERMINOLOGY.AND"
        ITEM: "@:COMMON.TERMINOLOGY.ITEM"
        ITEM_DATE: "@:COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:COMMON.TERMINOLOGY.TIME"
        ITEM_QUANTITY: "Quantité"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        POWERED_BY: "Réservations par"
      }
      PERSON_LIST: {
        PROGRESS_SELECT: "@:COMMON.BTN.SELECT"
        BACK_BTN:   "@:COMMON.BTN.BACK"
      }
      MONTHLY_CALENDAR: {
        SELECT_DAY:       "Choisir jour"
        WEEK_BEGINNING:   "La semaine commençant le"
        PICK_A_DATE:      "Choisir une date"
        PREVIOUS_5_WEEKS: "5 semaines précédentes"
        NEXT_5_WEEKS:     "5 semaines suivantes"
        KEY:              "Clé"
        AVAILABLE:        "{number, plural, =0{Aucun disponible} one{1 disponible} other{# disponibles}}"
        UNAVAILABLE:      "@:COMMON.TERMINOLOGY.UNAVAILABLE"
        BACK_BTN:    "@:COMMON.BTN.BACK"
      }
    }
  }

  $translateProvider.translations('fr', translations)

  return
