'use strict';

angular.module('BB.Services').config ($translateProvider) ->
  'ngInject'

  translations = {
    CORE: {
      ALERTS: {
        ERROR_TITLE: "Erreur"
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
        ITEM:              "Article"
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
        FULL_NAME:                     "Nom Complet"
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
        EMAIL_PATTERN:                 "Saisissez une adresse email valide"
        FIELD_REQUIRED:                "This field is required"
        PASSWORD:                      "Password"
        PASSWORD_REQUIRED:             "Veuillez entrer le mot de passe"
        REQUIRED_LABEL:                "*Requis"
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
