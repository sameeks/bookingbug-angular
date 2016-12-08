'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    PUBLIC_BOOKING: {
      ACCORDION_RANGE_GROUP: {
        AVAILABLE: "{number, plural, =0{Aucun disponible} one{1 disponible} other{# disponibles}}"
      }
      ITEM_DETAILS: {
        MOVE_BOOKING_SUCCESS_ALERT: "Votre réservation a été déplacée au {{datetime}}"
        MOVE_BOOKING_FAIL_ALERT: "La réservation n'a pas pu être déplacée. Merci de réessayer"
      }
      ADD_RECIPIENT: {
        MODAL_TITLE: "@:COMMON.TERMINOLOGY.RECIPIENT"
        WHO_TO_QUESTION: "Pour qui est le cadeau ?"
        WHO_TO_OPTION_ME: "Moi"
        WHO_TO_OPTION_NOT_ME: "Quelqu'un d'autre"
        NAME_LABEL: "Nom"
        NAME_VALIDATION_MSG: "Veuillez entrer le nom complet du destinataire"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        ADD_LABEL: "Ajouter un destinataire"
        CANCEL_LABEL: "@:COMMON.BTN.CANCEL"
      }
      BASKET_DETAILS: {
        STEP_TITLE: "Détails du panier"
        BASKET_DETAILS_NO: "Aucun élément dans votre panier."
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        BASKET_ITEM_APPOINTMENT: "@:COMMON.TERMINOLOGY.APPOINTMENT"
        TIME_AND_DURATION: "{{ time | datetime: 'LLLL':false}} pour {{ duration | time_period }}"
        CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT"
        BASKET_STATUS: "{N, plural, =0 {vide}, one {Un article dans votre panier}, others {# articles dans votre panier}}"
      }
      BASKET_ITEM_SUMMARY: {
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        DURATION_LABEL: "@:COMMON.TERMINOLOGY.DURATION"
        RESOURCE_LABEL: "@:COMMON.TERMINOLOGY.RESOURCE"
        PERSON_LABEL: "@:COMMON.TERMINOLOGY.PERSON"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LABEL: "@:COMMON.TERMINOLOGY.TIME"
      }
      CALENDAR: {
        NEXT_BTN: "@:COMMON.BTN.NEXT"
        MOVE_BOOKING_BTN: "@:COMMON.BTN.BOOK"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CATEGORY : {
        APPOINTMENT_TYPE: "Type de rdv"
        BOOK_BTN: "@:COMMON.BTN.BOOK"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CANCEL_MODAL: {
        CANCEL_QUESTION: "Êtes-vous sûr que vous voulez annuler cette réservation?"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LABEL: "@:COMMON.TERMINOLOGY.WHEN"
        CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING"
        DONT_CANCEL_BOOKING_BTN: "@:COMMON.BTN.DO_NOT_CANCEL_BOOKING"
      }
      CHECK_ITEMS : {
        REVIEW: "Examen"
        DETAILS_TITLE: "Détail de votre rendez-vous"
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_REQUIRED"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        ITEM_DETAILS: {
          BOOKING_QUESTIONS_HEADING: "Autre Information"
          FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
          REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED"
        }
        NEXT_BTN: "@:COMMON.BTN.CONFIRM"
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
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Quantité"
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        COUNT_AS: "for {{count_as}}"
        PAY_BTN: "@:COMMON.BTN.PAY"
      }
      CLIENT: {
        DETAILS_TITLE: "Vos coordonnées"
        CLIENT_DETAILS_TITLE: "Détails du client"
        REQUIRED_FIELDS: "@:COMMON.FORM.REQUIRED"
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        MOBILE_LABEL: "@:COMMON.FORM.MOBILE"
        BOOKING_QUESTIONS_HEADING: "Autre Information"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        PROGRESS_CONTINUE: "@:COMMON.BTN.NEXT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        PROGRESS_CLEAR: "@:COMMON.BTN.CLEAR"
      }
      COMPANY_CARDS: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      COMPANY_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      CONFIRMATION: {
        TITLE: "Confirmation de réservation"
        BOOKING_CONFIRMATION: "Merci {{member_name}}. Votre réservation est à présent confirmée. Nous vous avons envoyé par email les informations ci-dessous."
        ITEM_CONFIRMATION: "Confirmation"
        WAITLIST_CONFIRMATION: "Merci {{ member_name }}. Votre réservation a été effectuée avec succès. Nous vous avons envoyé par email les informations ci-dessous."
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LABEL: "@:COMMON.TERMINOLOGY.TIME"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
      }
      MEMBER_LOGIN_FORM: {
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_REQUIRED: "@:COMMON.FORM.EMAIL_REQUIRED"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        PASSWORD_LABEL: "@:COMMON.FORM.PASSWORD"
        PASSWORD_REQURIED: "Veuillez entrer le mot de passe"
        REMEMBER_ME: "Rester connecter"
        LOGIN: "@:COMMON.BTN.LOGIN"
      }
      MONTH_PICKER: {
        PROGRESS_PREVIOUS: "Précédent"
        NEXT_BTN: "Suivant"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LABEL: "Exporter vers un calendrier"
        SHORT_EXPORT_LABEL: "@:COMMON.TERMINOLOGY.EXPORT"
      }
      PRICE_FILTER: {
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
      }
      SERVICE_LIST_FILTER: {
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_SERVICE_PLACEHOLDER: "@:COMMON.TERMINOLOGY.SERVICE"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
      }
      WEEK_CALENDAR: {
        ALL_TIMES_IN: "Le fuseau horaire est {{time_zone_name}}."
        NO_AVAILABILITY: "It looks like there's no availability for the next {time_range_length, plural, one{day} other{# days}}"
        NEXT_AVAIL: "Aller au prochain jour réservable"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        ANY_DATE: "- Any Date -"
        MORNING_HEADER: "@:COMMON.TERMINOLOGY.MORNING"
        AFTERNOON_HEADER: "@:COMMON.TERMINOLOGY.AFTERNOON"
        EVENING_HEADER: "@:COMMON.TERMINOLOGY.EVENING"
      }
      BASKET: {
        BASKET_TITLE: "Votre Panier"
        BASKET_ITEM_NO: "Aucun élément dans votre panier."
        BASKET_ITEM_ADD_INSTRUCT: "Cliquez sur le bouton 'Ajouter un autre article' si vous souhaitez ajouter un autre produit ou service."
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
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
        APPLY_BTN: "@:COMMON.BTN.APPLY"
        VOUCHER_BOX: {
          BASKET_GIFT_CERTIFICATE_QUESTION: "Avez-vous un chèque-cadeau?"
          BASKET_GIFT_CERTIFICATE_APPLY: "Utiliser un chèque-cadeau"
          BASKET_GIFT_CERTIFICATE_APPLY_ANOTHER: "Utiliser une autre chèque-cadeau"
          VOUCHER_CODE_PLACEHOLDER: "Enter a voucher code"
          APPLY_BTN: "@:COMMON.BTN.APPLY"
        }
        CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        BASKET_ITEM_ADD: "Ajouter un autre élément"
        CHECKOUT_BTN: "@:COMMON.BTN.CHECKOUT"
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
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE_AND_OR_TIME: "@:COMMON.TERMINOLOGY.DATE/Time"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        BOOK_BTN: "@:COMMON.BTN.BOOK"
        CONFIRMATION_SUMMARY: {
          BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
          BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        }
        BASKET_TOTAL: "@:COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        CONFIRMATION_WAITLIST_SUBHEADER: "Merci d'avoir réservé {{ purchase_item }}, {{ member_name }}."
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      ERROR_MODAL: {
        OK_BTN: "@:COMMON.BTN.OK"
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
        PREV_MONTH_BTN: "Mois Précédent"
        NEXT_MONTH_BTN: "Mois suivant"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DATE_NOT_SELECTED: "Veuillez choisir une date"
      }
      DEAL_LIST: {
        BASKET_GIFT_CERTIFICATE: "@:COMMON.TERMINOLOGY.GIFT_CERTIFICATES"
        BUY_GIFT_CERT_BTN: "Acheter un chèque-cadeau"
        BASKET_GIFT_CERTIFICATE_SELECTED: "Chèques-cadeaux sélectionnés"
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        FORM: {
          RECIPIENT_ADD: "Ajouter un destinataire"
          RECIPIENT_NAME: "Recipient Name"
          EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
          PROGRESS_ADD: "Ajouter"
          RECIPIENT_NAME_REQUIRED: "Ecrivez le nom complet du destinataire"
          RECIPIENT_EMAIL_REQUIRED: "@:COMMON.FORM.EMAIL_REQUIRED"
        }
        RECIPIENT: "@:COMMON.TERMINOLOGY.RECIPIENT"
        RECIPIENT_NAME: "@:COMMON.FORM.LAST_NAME"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        PROGRESS_BUY: "Acheter"
        BACK_BTN: "@:COMMON.BTN.BACK"
        CERTIFICATE_NOT_SELECTED_ALERT: "Il vous faut au moins un chèque-cadeau pour continuer"
      }
      DURATION_LIST: {
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        BACK_BTN: "@:COMMON.BTN.BACK"
        DURATON_NOT_SELECTED_ALERT: "Merci de choisir une durée"
      }
      EVENT: {
        EVENT_DETAILS_TITLE: "Détails de l'événement"
        ITEM_TYPE: "Type"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Qty"
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
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
        APPLY_BTN: "@:COMMON.BTN.APPLY"
        BASKET_GIFT_CERTIFICATES_APPLIED: "Gift Certificates applied"
        BASKET_REMOVE_DEAL: "Remove"
        BASKET_GIFT_CERTIFICATE_BALANCE: "Remaining Gift Certificate balance"
        DETAILS_TITLE: "Vos coordonnées"
        FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
        FIRST_NAME_VALIDATION_MSG: "@:COMMON.FORM.FIRST_NAME_REQUIRED"
        LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
        LAST_NAME_VALIDATION_MSG: "@:COMMON.FORM.LAST_NAME_REQUIRED"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
        STORE_PHONE: "@:COMMON.FORM.PHONE"
        MOBILE_REQ_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        ADDRESS_LABEL: "@:COMMON.FORM.ADDRESS1"
        ADDRESS_REQ_VALIDATION_MSG: "@:COMMON.FORM.MOBILE_REQUIRED"
        ADDRESS_3_LABEL: "@:COMMON.FORM.ADDRESS3"
        ADDRESS_4_LABEL: "@:COMMON.FORM.ADDRESS4"
        POSTCODE_LABEL: "@:COMMON.FORM.POSTCODE"
        POSTCODE_INVALID: "@:COMMON.FORM.POSTCODE_PATTERN"
        FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        UIB_ACCORDION: {
          TICKET_WORD: "Ticket"
          DETAILS_WORD: "details"
          ATTENDEE_IS_YOU_QUESTION: "Êtes-vous le participant?"
          ATTENDEE_USE_MY_DETAILS: " Utiliser mes coordonnées"
          FIRST_NAME_LABEL: "@:COMMON.FORM.FIRST_NAME"
          LAST_NAME_LABEL: "@:COMMON.FORM.LAST_NAME"
          EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
          EMAIL_INVALID: "@:COMMON.FORM.EMAIL_INVALID"
          FIELD_REQUIRED: "@:COMMON.FORM.FIELD_REQUIRED"
        }
        T_AND_C_LABEL: "@:COMMON.FORM.TERMS_AND_CONDITIONS"
        T_AND_C_REQUIRED: "@:COMMON.FORM.TERMS_AND_CONDITIONS_REQUIRED"
        TICKET_WORD: "Ticket"
        DETAILS_WORD: "details"
        RESERVE_TICKET: "Reserve Ticket"
        LETTER_S: "s"
        EVENT_JOIN_WAITLIST: "Join Waitlist"
        BOOK_TICKET: "@:COMMON.BTN.BOOK Ticket"
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      EVENT_GROUP_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
      }
      EVENT_LIST: {
        EVENT_LOCATION: "Evénements à"
        FILTER: "@:COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY_CATEGORY: "@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:COMMON.TERMINOLOGY.ANY"
        FILTER_ANY_PRICE: '@:COMMON.TERMINOLOGY.ANY @:COMMON.TERMINOLOGY.PRICE'
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        HIDE_FULLY_BOOKED_EVENTS: "Cacher les événements indisponibles"
        SHOW_FULLY_BOOKED_EVENTS: "Afficher les événements indisponibles"
        FILTER_RESET: "@:COMMON.TERMINOLOGY.RESET"
        FILTER_NONE: "Tous les événements"
        FILTER_FILTERED: "Afficher les événements filtrés"
        EVENT_WORD: "@:COMMON.TERMINOLOGY.EVENTS"
        EVENT_NO: "Aucun événement trouvé"
        EVENT_SPACE_WORD: "place"
        EVENT_LEFT_WORD: "restant"
        ITEM_FROM: "À partir de"
        BOOK_EVENT_BTN: "@:COMMON.BTN.BOOK_EVENT" 
        BACK_BTN: "@:COMMON.BTN.BACK"
        EVENT_SOLD_OUT: "Épuisé"
        EVENT_JOIN_WAITLIST: "S'inscrire sur la liste d'attente"
      }
      MAIN: {
        POWERED_BY: "Réservations par"
      }
      MAP: {
        PROGRESS_SEARCH: "Rechercher"
        SEARCH_BTN: "Rechercher"
        INPUT_PLACEHOLDER: "Saisissez une ville, un code postal ou un magasin"
        GEOLOCATE_TITLE: "Utilisez votre emplacement actuel"
        STORE_RESULT_TITLE: "{results, plural, =0{Aucun réultat trouvé} one{1 résultat trouvé} other{# résultats trouvés}} pour les magasins à proximité de {address}"
        HIDE_STORES: "Masquer les magasins sans disponibilité"
        SERVICE_UNAVAILABLE: "Désolé mais {{name}} n'est pas disponible dans ce magasin"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        UIB_ACCORDION: {
          SELECT_BTN: "@:COMMON.BTN.SELECT"
          SERVICE_UNAVAILABLE: "Désolé mais {{name}} n'est pas disponible dans ce magasin"
        }
      }
      MEMBERSHIP_LEVELS: {
        MEMBERSHIP_TYPES: "Types d'adhésion"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
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
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        SURVEY_WORD: "Enquête"
        DETAILS_QUESTIONS: "@:COMMON.TERMINOLOGY.QUESTIONS"
        SURVEY_SUBMIT: "@:COMMON.BTN.SUBMIT"
        SURVEY_NO: "Aucune question de l'enquête pour cette session."
      }
      SERVICE_LIST: {
        PRICE_FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        SELECT_BTN: "@:COMMON.BTN.SELECT"
        SERVICE_LIST_NO: "Aucun service ne répond à vos critères de filtrage."
        BACK_BTN: "@:COMMON.BTN.BACK"
      }
      RESOURCE_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
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
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        EMAIL_LABEL: "@:COMMON.FORM.EMAIL"
        SERVICE_LABEL: "@:COMMON.TERMINOLOGY.SERVICE"
        WHEN_LABEL: "@:COMMON.TERMINOLOGY.WHEN"
        PRICE_LABEL: "@:COMMON.TERMINOLOGY.PRICE"
        CANCEL_BOOKING_BTN: "@:COMMON.BTN.CANCEL_BOOKING"
        MOVE_BOOKING_BTN: "Modifier la réservation"
        BOOK_WAITLIST_ITEMS_BTN: "Réserver des articles en liste d'attente"
      }
      PRINT_PURCHASE: {
        TITLE: "Confirmation de réservation"
        BOOKING_CONFIRMATION: "Merci {{member_name}}. Votre réservation est à présent confirmée. Nous vous avons envoyé par email les informations ci-dessous."
        CALENDAR_EXPORT_TITLE: "@:COMMON.TERMINOLOGY.EXPORT"
        PRINT_BTN: "@:COMMON.TERMINOLOGY.PRINT"
        AND: "@:COMMON.TERMINOLOGY.AND"
        ITEM_LABEL: "@:COMMON.TERMINOLOGY.ITEM"
        DATE_LABEL: "@:COMMON.TERMINOLOGY.DATE"
        TIME_LABEL: "@:COMMON.TERMINOLOGY.TIME"
        QTY_LABEL: "Quantité"
        BOOKING_REFERENCE: "@:COMMON.TERMINOLOGY.BOOKING_REF"
        POWERED_BY: "Réservations par"
      }
      PERSON_LIST: {
        SELECT_BTN: "@:COMMON.BTN.SELECT"
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
