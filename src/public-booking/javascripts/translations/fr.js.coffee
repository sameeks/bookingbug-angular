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
        INVALID_POSTCODE: "Saisissez un code postal valide"
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
        MODAL_TITLE: "Destinataire"
        WHO_TO_QUESTION: "Pour qui est le cadeau ?"
        WHO_TO_OPTION_ME: "Moi"
        WHO_TO_OPTION_NOT_ME: "Quelqu'un d'autre"
        NAME_LABEL: "Nom"
        NAME_VALIDATION_MSG: "Veuillez entrer le nom complet du destinataire"
        EMAIL_LABEL: "Email"
        EMAIL_VALIDATION_MSG: "Veuillez entrer une addresse email valid"
        ADD_LABEL: "Ajouter un destinataire"
        CANCEL_LABEL: "Annuler"
      }
      BASKET_DETAILS: {
        BASKET_DETAILS_TITLE: "Détails du panier"
        BASKET_DETAILS_NO: "Aucun élément dans votre panier."
        ITEM: "@:CORE.COMMON.TERMINOLOGY.ITEM"
        BASKET_ITEM_APPOINTMENT: "@:CORE.COMMON.TERMINOLOGY.APPOINTMENT"
        TIME_AND_DURATION: "{{ time | datetime: 'LLLL':false}} pour {{ duration | time_period }}"
        PROGRESS_CANCEL: "@:CORE.COMMON.BTN.CANCEL"
        BASKET_CHECKOUT: "Caisse"
        BASKET_STATUS: "{N, plural, =0 {vide}, one {Un article dans votre panier}, others {# articles dans votre panier}}"
      }
      BASKET_ITEM_SUMMARY: {
        ITEM_DURATION: "@:CORE.COMMON.TERMINOLOGY.DURATION"
        ITEM_RESOURCE: "@:CORE.COMMON.TERMINOLOGY.RESOURCE"
        ITEM_PERSON: "@:CORE.COMMON.TERMINOLOGY.PERSON"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        ITEM_DATE: "@:CORE.COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:CORE.COMMON.TERMINOLOGY.TIME"
      }
      CALENDAR: {
        PROGRESS_NEXT: "@:CORE.BTN.NEXT"
        PROGRESS_MOVE_BOOKING: "@:CORE.BTN.BOOK"
        PROGRESS_BACK: "@:CORE.BTN.BACK"
      }
      CATEGORY : {
        APPOINTMENT_TYPE: "Type de rdv"
        PROGRESS_BOOK: "@:CORE.COMMON.BTN.BOOK"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      CANCEL_MODAL: {
        CANCEL_QUESTION: "Êtes-vous sûr que vous voulez annuler cette réservation?"
        ITEM_SERVICE: "@:CORE.COMMON.TERMINOLOGY.SERVICE"
        ITEM_WHEN: "@:CORE.COMMON.TERMINOLOGY.WHEN"
        PROGRESS_CANCEL_BOOKING: "@:CORE.COMMON.BTN.CANCEL_BOOKING"
        PROGRESS_CANCEL_CANCEL: "@:CORE.COMMON.BTN.DO_NOT_CANCEL_BOOKING"
      }
      CHECK_ITEMS : {
        REVIEW: "Examen"
        DETAILS_TITLE: "Détail de votre rendez-vous"
        DETAILS_FIRST_NAME: "@:CORE.COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:CORE.COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:CORE.COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:CORE.COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:CORE.COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:CORE.COMMON.FORM.EMAIL_REQURIED"
        DETAILS_PHONE_MOBILE: "@:CORE.COMMON.FORM.MOBILE"
        DETAILS_VALIDATION_MSG: "@:CORE.COMMON.FORM.FIELD_REQUIRED"
        DETAILS_OTHER_INFO: "Autre Information"
        DETAILS_VALIDATION_MSG: "@:CORE.COMMON.FORM.FIELD_REQUIRED"
        PROGRESS_CONFIRM: "@:CORE.COMMON.BTN.CONFIRM"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      CHECKOUT: {
        PAYMENT_WORD: "Paiement"
        PAYMENT_DETAILS_TITLE: "Détails de paiement"
        PAY_BTN: "@:CORE.COMMON.BTN.PAY"
      }
      CHECKOUT_EVENT: {
        EVENT_PAYMENT: "Merci de finir le paiement pour confirmer votre réservation"
        EVENT_TICKETS: "@:CORE.COMMON.TERMINOLOGY.TICKETS"
        ITEM_TYPE: "Type"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        ITEM_QTY: "Quantité"
        BASKET_TOTAL: "@:CORE.COMMON.TERMINOLOGY.TOTAL"
        COUNT_AS: "for {{count_as}}"
        PAY_BTN: "@:CORE.COMMON.BTN.PAY"
      }
      CLIENT: {
        DETAILS_TITLE: "Vos coordonnées"
        CLIENT_DETAILS_TITLE: "Détails du client"
        REQUIRED_FIELDS: "@:CORE.COMMON.FORM.FIELD_REQUIRED"
        DETAILS_FIRST_NAME: "@:CORE.COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "@:CORE.COMMON.FORM.FIRST_NAME_REQUIRED"
        DETAILS_LAST_NAME: "@:CORE.COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "@:CORE.COMMON.FORM.LAST_NAME_REQUIRED"
        DETAILS_EMAIL: "@:CORE.COMMON.FORM.EMAIL"
        DETAILS_EMAIL_VALIDATION_MSG: "@:CORE.COMMON.FORM.EMAIL_PATTERN"
        DETAILS_PHONE_MOBILE: "@:CORE.COMMON.FORM.MOBILE"
        DETAILS_OTHER_INFO: "Autre Information"
        DETAILS_VALIDATION_MSG: "@:CORE.COMMON.FORM.FIELD_REQUIRED"
        PROGRESS_CONTINUE: "@:CORE.COMMON.BTN.NEXT"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
        PROGRESS_CLEAR: "@:CORE.COMMON.BTN.NEXT"
      }
      COMPANY_CARDS: {
        SELECT_BTN: "@:CORE.COMMON.BTN.SELECT"
        BACK_BTN: "@:CORE.COMMON.BTN.BACK"
      }
      COMPANY_LIST: {
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      CONFIRMATION: {
        CONFIRMATION_BOOKING_TITLE: "Confirmation de réservation"
        CONFIRMATION_BOOKING_SUBHEADER: "Merci {{member_name}}. Votre réservation est à présent confirmée. Nous vous avons envoyé par email les informations ci-dessous."
        ITEM_CONFIRMATION: "Confirmation"
        CONFIRMATION_BOOKING_SUBHEADER_WITH_WAITLIST: "Merci {{ member_name }}. Votre réservation a été effectuée avec succès. Nous vous avons envoyé par email les informations ci-dessous."
        PRINT: "@:CORE.COMMON.TERMINOLOGY.PRINT"
        BOOKING_REFERENCE: "Référence de votre réservation"
        ITEM_SERVICE: "Service"
        ITEM_DATE: "Date"
        ITEM_TIME: "Heure"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
      }
      MEMBER_LOGIN_FORM: {
        EMAIL_LABEL: "Email"
        EMAIL_VALIDATION_REQUIRED_MESSAGE: "Veuillez entrer votre addresse email"
        EMAIL_VALIDATION_PATTERN_MESSAGE: "Veuillez entrer une addresse email valid"
        PASSWORD_LABEL: "Password"
        PLEASE_ENTER_PASSWORD: "Veuillez entrer le mot de passe"
        REMEMBER_ME: "Rester connecter"
        LOGIN: "Connexion"
      }
      MONTH_PICKER: {
        PROGRESS_PREVIOUS: "Précédent"
        PROGRESS_NEXT: "Suivant"
      }
      POPOUT_EXPORT_BOOKING: {
        LONG_EXPORT_LABEL: "Exporter vers un calendrier"
        SHORT_EXPORT_LABEL: "Exporter"
      }
      PRICE_FILTER: {
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
      }
      SERVICE_LIST_FILTER: {
        FILTER: "@:CORE.COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:CORE.COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:CORE.COMMON.TERMINOLOGY.ANY"
        ITEM_SERVICE: "@:CORE.COMMON.TERMINOLOGY.SERVICE"
        FILTER_RESET: "@:CORE.COMMON.TERMINOLOGY.RESET"
      }
      WEEK_CALENDAR: {
        ALL_TIMES_IN: "Le fuseau horaire est {{time_zone_name}}."
        NO_AVAILABILITY: "{time_range_length, plural, Aucune disponibilité pour one{le prochain jour} other{les prochains {time_range_length} jours}}"
        NEXT_AVAIL: "Aller au prochain jour réservable"
        ANY_DATE: "- Date -"
      }
      BASKET: {
        BASKET_TITLE: "Votre Panier"
        BASKET_ITEM_NO: "Aucun élément dans votre panier."
        BASKET_ITEM_ADD_INSTRUCT: "Cliquez sur le bouton 'Ajouter un autre article' si vous souhaitez ajouter un autre produit ou service."
        ITEM: "@:CORE.COMMON.TERMINOLOGY.ITEM"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        BASKET_RECIPIENT: "Destinataire"
        BASKET_CERTIFICATE_PAID: "Chèques-cadeaux payés"
        BASKET_GIFT_CERTIFICATES: "Chèques-cadeaux"
        BASKET_PRICE_ORIGINAL: "Prix d'origine"
        BASKET_BOOKING_FEE: "Frais de réservation"
        BASKET_GIFT_CERTIFICATES_TOTAL: "Total des chèque-cadeau"
        BASKET_GIFT_CERTIFICATE_BALANCE: "La valeur restante de vos chèques-cadeaux"
        BASKET_COUPON_DISCOUNT: "Coupon"
        BASKET_TOTAL: "@:CORE.COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:CORE.COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        BASKET_WALLET: "@:CORE.COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_BALANCE: "Balance du Portefeuille"
        BASKET_WALLET_BALANCE_INSUFFICIENT: "Oh non! Vous n'avez pas assez d'argent dans votre Portefeuille. Vous pouvez soit payer le montant intégral, soit recharger votre Portefeuille."
        BASKET_WALLET_REMAINDER_PART_ONE: "Vous aurez encore "
        BASKET_WALLET_REMAINDER_PART_TWO: " dans votre Portefeuille après cet achat"
        BASKET_WALLET_TOP_UP: "Recharger"
        BASKET_COUPON_APPLY: "Appliquer un coupon"
        PROGRESS_APPLY: "@:CORE.COMMON.BTN.APPLY"
        BASKET_GIFT_CERTIFICATE_QUESTION: "Avez-vous un chèque-cadeau?"
        BASKET_GIFT_CERTIFICATE_APPLY: "Utiliser un chèque-cadeau"
        BASKET_GIFT_CERTIFICATE_APPLY_ANOTHER: "Utiliser une autre chèque-cadeau"
        PROGRESS_CANCEL: "@:CORE.COMMON.BTN.CANCEL"
        BASKET_ITEM_ADD: "Ajouter un autre élément"
        BASKET_CHECKOUT: "Caisse"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      BASKET_ITEM_SUMMARY: {
        STEP_TITLE: "Résumé"
        STEP_DESCRIPTION: "Merci de vérifier ces détails"
        DURATION_LABEL: "@:CORE.COMMON.TERMINOLOGY.DURATION"
        FULL_NAME_LABEL: "Full name"
        EMAIL_LABEL: "Mail"
        MOBILE_LABEL: "Mobile"
        ADDRESS_LABEL: "Adresse"
        PRICE_LABEL: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        CONFIRM_BUTTON: "Confirmer"
        BACK_BUTTON: "@:CORE.COMMON.BTN.BACK"
      }
      BASKET_WAITLIST: {
        WAITLIST_BOOKING_TITLE: "Votre réservation est sur liste d'attente"
        BOOKING_REFERENCE: "Référence de votre réservation"
        ITEM_SERVICE: "@:CORE.COMMON.TERMINOLOGY.SERVICE"
        ITEM_DATE_AND_OR_TIME: "@:CORE.COMMON.TERMINOLOGY.DATE/Time"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        PROGRESS_BOOK: "@:CORE.COMMON.BTN.BOOK"
        BASKET_TOTAL: "@:CORE.COMMON.TERMINOLOGY.TOTAL"
        BASKET_TOTAL_DUE_NOW: "@:CORE.COMMON.TERMINOLOGY.TOTAL_DUE_NOW"
        CONFIRMATION_WAITLIST_SUBHEADER: "Merci d'avoir réservé {{ purchase_item }}, {{ member_name }}."
        PRINT: "@:CORE.COMMON.TERMINOLOGY.PRINT"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      ERROR_MODAL: {
        PROGRESS_OK: "OK"
      }
      MEMBER_FORM: {
        FIRST_NAME_LABEL: "@:CORE.COMMON.FORM.FIRST_NAME"
        LAST_NAME_LABEL: "@:CORE.COMMON.FORM.LAST_NAME"
        EMAIL_LABEL: "Email"
        PHONE_LABEL: "Téléphone"
        MOBILE_LABEL: "Mobile"
        SAVE_BUTTON: "@:CORE.COMMON.BTN.SAVE"
      }
      BASKET_WALLET: {
        BASKET_WALLET_MAKE_PAYMENT: "effectuer le paiement"
        BASKET_WALLET_TOP_UP: "Recharger"
        BASKET_WALLET_AMOUNT: "Montant"
        BASKET_WALLET: "@:CORE.COMMON.TERMINOLOGY.WALLET"
        BASKET_WALLET_AMOUNT_MINIMUM: "Le montant de recharge minimum doit être supérieur"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      DASH: {
        DASHBOARD: "Tableau de bord"
        DASHBOARD_TITLE: "Choisissez un emplacement / service"
      }
      DAY: {
        AVAIL_MONTH_PREVIOUS: "Mois Précédent"
        AVAIL_MONTH_NEXT: "Mois suivant"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
        DATE_NOT_SELECTED: "Veuillez choisir une date"
      }
      DEAL_LIST: {
        BASKET_GIFT_CERTIFICATE: "Chèques-cadeaux"
        BASKET_GIFT_CERTIFICATE_BUY: "Acheter un chèque-cadeau"
        BASKET_GIFT_CERTIFICATE_SELECTED: "Chèques-cadeaux sélectionnés"
        ITEM: "@:CORE.COMMON.TERMINOLOGY.ITEM"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        RECIPIENT_ADD: "Ajouter un destinataire"
        RECIPIENT_NAME: "@:CORE.COMMON.FORM.LAST_NAME"
        DETAILS_EMAIL: "Mail"
        PROGRESS_ADD: "Ajouter"
        RECIPIENT_NAME_VALIDATION_MSG: "Ecrivez le nom complet du destinataire"
        RECIPIENT_EMAIL_VALIDATION_MSG: "Saisissez une adresse email valide"
        RECIPIENT: "Destinataire"
        RECIPIENT_NAME: "@:CORE.COMMON.FORM.LAST_NAME"
        PROGRESS_BUY: "Acheter"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
        CERTIFICATE_NOT_SELECTED_ALERT: "Il vous faut au moins un chèque-cadeau pour continuer"
      }
      DURATION_LIST: {
        ITEM_FREE: "@:CORE.COMMON.TERMINOLOGY.PRICE_FREE"
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
        DURATON_NOT_SELECTED_ALERT: "Merci de choisir une durée"
      }
      EVENT: {
        EVENT_DETAILS_TITLE: "Détails de l'événement"
        DETAILS_TITLE: "Vos coordonnées"
        DETAILS_FIRST_NAME: "@:CORE.COMMON.FORM.FIRST_NAME"
        DETAILS_FIRST_NAME_VALIDATION_MSG: "Saisissez votre prénom"
        DETAILS_LAST_NAME: "@:CORE.COMMON.FORM.LAST_NAME"
        DETAILS_LAST_NAME_VALIDATION_MSG: "Saisissez votre nom"
        DETAILS_EMAIL: "Mail"
        DETAILS_EMAIL_VALIDATION_MSG: "Saisissez une adresse email valide"
        STORE_PHONE: "Téléphone"
        DETAILS_PHONE_MOBILE_VALIDATION_MSG: "Saisissez un numéro de téléphone valide"
        DETAILS_ADDRESS: "Adresse"
        DETAILS_ADDRESS_VALIDATION_MSG: "Merci d'entrer votre adresse"
        DETAILS_TOWN: "Ville"
        DETAILS_COUNTY: "Comté"
        DETAILS_POSTCODE: "Code Postal"
        INVALID_POSTCODE: "Saisissez un code postal valide"
        DETAILS_VALIDATION_MSG: "Ce champ est obligatoire"
        ATTENDEE_IS_YOU_QUESTION: "Êtes-vous le participant?"
        ATTENDEE_USE_MY_DETAILS: " Utiliser mes coordonnées"
        DETAILS_TERMS: " J'accepte les conditions générales de vente."
        DETAILS_TERMS_VALIDATION_MSG: "Vous devez accepter les conditions générales de vente"
      }
      EVENT_GROUP_LIST: {
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
      }
      EVENT_LIST: {
        EVENT_LOCATION: "Evénements à"
        FILTER: "@:CORE.COMMON.TERMINOLOGY.FILTER"
        FILTER_CATEGORY: "@:CORE.COMMON.TERMINOLOGY.CATEGORY"
        FILTER_ANY: "@:CORE.COMMON.TERMINOLOGY.ANY"
        ITEM_DATE: "@:CORE.COMMON.TERMINOLOGY.DATE"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        EVENT_SOLD_OUT_HIDE: "Cacher les événements indisponibles"
        EVENT_SOLD_OUT_SHOW: "Afficher les événements indisponibles"
        FILTER_RESET: "@:CORE.COMMON.TERMINOLOGY.RESET"
        FILTER_NONE: "Tous les événements"
        FILTER_FILTERED: "Afficher les événements filtrés"
        EVENT_WORD: "Événements"
        EVENT_NO: "Aucun événement trouvé"
        EVENT_SPACE_WORD: "place"
        EVENT_LEFT_WORD: "restant"
        ITEM_FROM: "À partir de"
        PROGRESS_BOOK: "@:CORE.COMMON.BTN.BOOK"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
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
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
        UIB_ACCORDIAN: {
          PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
          SERVICE_UNAVAILABLE: "Désolé mais {{name}} n'est pas disponible dans ce magasin"
        }
      }
      MEMBERSHIP_LEVELS: {
        MEMBERSHIP_TYPES: "Types d'adhésion"
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
      }
      TIME: {
        AVAIL_DAY_PREVIOUS: "Jour Précédent"
        AVAIL_DAY_NEXT: "Jour suivant"
        AVAIL_NO: "Aucun service disponible"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
        TIME_NOT_SELECTED_ALERT: "Veuillez choisir un créneau"
        AVAIL_MORNING: "Matin"
        AVAIL_AFTERNOON: "Après-midi"
        AVAIL_EVENING: "Soir"
      }
      SURVEY: {
        SURVEY_THANK_YOU: "Merci d'avoir rempli le questionnaire !"
        ITEM_SESSION: "@:CORE.COMMON.TERMINOLOGY.SESSION"
        ITEM_DATE: "@:CORE.COMMON.TERMINOLOGY.DATE"
        SURVEY_WORD: "Enquête"
        DETAILS_QUESTIONS: "Questions"
        SURVEY_SUBMIT: "Soumettre les réponses"
        SURVEY_NO: "Aucune question de l'enquête pour cette session."
      }
      SERVICE_LIST: {
        ITEM_FREE: "@:CORE.COMMON.TERMINOLOGY.PRICE_FREE"
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
        SERVICE_LIST_NO: "Aucun service ne répond à vos critères de filtrage."
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      RESOURCE_LIST: {
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      RESCHEDULE_REASONS:{
        MOVE_TITLE: "Déplacer le rendez-vous "
        MOVE_REASON: "Veuillez choisir une raison :"
        MOVE_BTN: "Déplacer"
        }
      PURCHASE: {
        CANCEL_CONFIRMATION: "Votre réservation a été annulée."
        CONFIRMATION_PURCHASE_TITLE: "Votre {{ service_name }} réservation"
        RECIPIENT_NAME: "@:CORE.COMMON.FORM.LAST_NAME"
        PRINT: "@:CORE.COMMON.TERMINOLOGY.PRINT"
        DETAILS_EMAIL: "Mail"
        ITEM_SERVICE: "@:CORE.COMMON.TERMINOLOGY.SERVICE"
        ITEM_WHEN: "@:CORE.COMMON.TERMINOLOGY.WHEN"
        ITEM_PRICE: "@:CORE.COMMON.TERMINOLOGY.PRICE"
        PROGRESS_CANCEL_BOOKING: "@:CORE.COMMON.BTN.CANCEL_BOOKING"
        PROGRESS_MOVE_BOOKING: "Modifier la réservation"
        PROGRESS_BOOK_WAITLIST_ITEMS: "Réserver des articles en liste d'attente"
      }
      PRINT_PURCHASE: {
        CONFIRMATION_BOOKING_TITLE: "Confirmation de réservation"
        CONFIRMATION_BOOKING_SUBHEADER: "Merci {{member_name}}. Votre réservation est à présent confirmée. Nous vous avons envoyé par email les informations ci-dessous."
        CALENDAR_EXPORT_TITLE: "Exporter"
        PRINT: "@:CORE.COMMON.TERMINOLOGY.PRINT"
        AND: "@:CORE.COMMON.TERMINOLOGY.AND"
        ITEM: "@:CORE.COMMON.TERMINOLOGY.ITEM"
        ITEM_DATE: "@:CORE.COMMON.TERMINOLOGY.DATE"
        ITEM_TIME: "@:CORE.COMMON.TERMINOLOGY.TIME"
        ITEM_QUANTITY: "Quantité"
        BOOKING_REFERENCE: "Référence de votre réservation"
        POWERED_BY: "Réservations par"
      }
      PERSON_LIST: {
        PROGRESS_SELECT: "@:CORE.COMMON.BTN.SELECT"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
      MONTHLY_CALENDAR: {
        SELECT_DAY: "Choisir jour"
        WEEK_BEGINNING: "La semaine commençant le"
        PICK_A_DATE: "Choisir une date"
        PREVIOUS_5_WEEKS: "5 semaines précédentes"
        NEXT_5_WEEKS: "5 semaines suivantes"
        KEY: "Clé"
        AVAILABLE: "{number, plural, =0{Aucun disponible} one{1 disponible} other{# disponibles}}"
        UNAVAILABLE: "Non disponible"
        PROGRESS_BACK: "@:CORE.COMMON.BTN.BACK"
      }
    }
  }

  $translateProvider.translations('fr', translations)

  return
