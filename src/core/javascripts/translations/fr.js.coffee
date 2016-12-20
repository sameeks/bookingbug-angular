'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    CORE: {
      ALERTS: {
        ERROR_HEADING: "Erreur"
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
        POSTCODE_INVALID: "@:COMMON.TERMINOLOGY.POSTCODE_PATTERN"
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
      PAGINATION: {
        SUMMARY: "{{start}} - {{end}} of {{total}}"
      }
      MODAL: {
        CANCEL_BOOKING: {
          HEADER:               "Annuler"
          QUESTION:             "Êtes-vous sûr de vouloir annuler ce {{type}}?" #gender issue
        }
        SCHEMA_FORM: {
          OK_BTN:     "@:COMMON.BTN.OK"
          CANCEL_BTN: "@:COMMON.BTN.CANCEL"
        }
      }
      FILTERS: {
        DISTANCE: {
          UNIT: "km"
        }
        CURRENCY: {
          THOUSANDS_SEPARATOR: " "
          DECIMAL_SEPARATOR:   ","
          CURRENCY_FORMAT:     "%v%s"
        }
        PRETTY_PRICE: {
          FREE: "@:COMMON.TERMINOLOGY.PRICE_FREE"
        }
        TIME_PERIOD: {
          TIME_PERIOD: "{hours, plural, =0{} one{1 hour} other{# hours}}{show_seperator, plural, =0{} =1{, } other{}}{minutes, plural, =0{} one{1 minute} other{# minutes}}"
        }
      }
      EVENT: {
        SPACES_LEFT:   "Seulement {N, plural, one{une place restante}, others{# places restantes}}"
        JOIN_WAITLIST: "S'inscrire sur la liste d'attente"
      }
    }
    COMMON: {
      TERMINOLOGY: {
        CATEGORY:          "Catégorie"
        DURATION:          "Durée"
        RESOURCE:          "Ressource"
        PERSON:            "Personne"
        SERVICE:           "Service"
        WALLET:            "Portefeuille"
        SESSION:           "Session"
        EVENT:             "Event"
        EVENTS:            "Événements"
        COURSE:            "Course"
        COURSES:           "Courses"
        DATE:              "Date"
        TIME:              "Heure"
        WHEN:              "Quand"
        GIFT_CERTIFICATE:  "Chèque-cadeau"
        GIFT_CERTIFICATES: "Chèques-cadeaux"
        ITEM_LBL:              "Article"
        FILTER:            "Filtre"
        ANY:               "Tout"
        RESET:             "Remettre"
        TOTAL:             "Total"
        TOTAL_DUE_NOW:     "Total à payer"
        BOOKING_FEE:       "Frais de réservation"
        PRICE:             "Prix"
        PRICE_FREE:        "Gratuit"
        PRINT:             " Imprimer"
        AND:               "et"
        APPOINTMENT:       "Rendez-vous"
        TICKETS:           "Billets"
        EXPORT:            "Exporter"
        RECIPIENT:         "Destinataire"
        BOOKING_REF:       "Référence de votre réservation"
        MORNING:           "Matin"
        AFTERNOON:         "Après-midi"
        EVENING:           "Soir"
        AVAILABLE:         "Disponible"
        UNAVAILABLE:       "Non disponible"
        CALENDAR:          "Calendar"
        QUESTIONS:         "Questions"
        BOOKING:           "Réservation"
        ADMITTANCE:        "Admittance"
      }
      FORM: {
        FIRST_NAME:                    "Prénom"
        FIRST_NAME_REQUIRED:           "Saisissez votre prénom"
        LAST_NAME:                     "Nom"
        LAST_NAME_REQUIRED:            "Saisissez votre nom"
        NAME:                     "Nom Complet"
        ADDRESS1:                      "Adresse"
        ADDRESS_REQUIRED:              ""
        ADDRESS3:                      "Ville"
        ADDRESS4:                      "Province/Région"
        POSTCODE:                      "Code Postal"
        POSTCODE_PATTERN:              "Saisissez un code postal valide"
        PHONE:                         "Téléphone"
        MOBILE:                        "Mobile"
        MOBILE_REQUIRED:               "Saisissez un numéro de téléphone valide"
        EMAIL:                         "Email"
        EMAIL_REQURIED:                "Veuillez entrer votre addresse email"
        EMAIL_INVALID:                 "Saisissez une adresse email valide"
        FIELD_REQUIRED:                "This field is required"
        PASSWORD:                      "Password"
        PASSWORD_REQUIRED:             "Veuillez entrer le mot de passe"
        REQUIRED_LBL:                "*Requis"
        TERMS_AND_CONDITIONS:          "J'accepte les conditions générales de vente"
        TERMS_AND_CONDITIONS_REQUIRED: "Vous devez accepter les conditions générales de vente"
      }
      BTN: {
        CANCEL:                "Annuler"
        CLOSE:                 "Fermer"
        NO:                    "Non"
        OK:                    "Ok"
        YES:                   "Oui"
        BACK:                  "Retour"
        NEXT:                  "Suivant"
        LOGIN:                 "Connexion"
        CONFIRM:               "Confirmer"
        SAVE:                  "Enregistrer"
        SELECT:                "Choisir"
        BOOK:                  "Réserver"
        BOOK_EVENT:            "Book Event"
        CANCEL_BOOKING:        "Annuler Réservation"
        DO_NOT_CANCEL_BOOKING: "Ne pas annuler"
        APPLY:                 "Appliquer"
        CLEAR:                 "Vider"
        PAY:                   "Payer"
        CHECKOUT:              "Caisse"
        TOP_UP:                "Recharger"
        ADD:                   "Ajouter"
        SUBMIT:                "Soumettre"
        DETAILS:               "Détails"
        MORE:                  "More"
        LESS:                  "Less"
        DELETE:                "Effacer"
      }
      LANGUAGE: {
        EN: "English"
        DE: "Deutsch"
        ES: "Español"
        FR: "Français"
      }

    }
  }

  $translateProvider.translations('fr', translations)

  return
