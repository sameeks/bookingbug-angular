exports.bbCheckoutMock = ->
  angular.module 'bbCheckoutMock', ['BB', 'ngMockE2E']
  .run ($httpBackend) ->
    checkoutResponse =
    {
      "total_price": 4000,
      "price": 4000,
      "paid": 0,
      "deposit": 0,
      "tax_payable_on_price": 0,
      "tax_payable_on_deposit": 0,
      "tax_payable_on_due_now": 0,
      "due_now": 4000,
      "long_id": "J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D",
      "id": 8916829,
      "client_name": "G F",
      "created_at": "2016-04-08T08:52:29Z",
      "certificate_paid": 0,
      "payment_type": "other",
      "_embedded": {
        "client": {
          "first_name": "g",
          "last_name": "f",
          "email": "d@de.de",
          "country": "United Kingdom",
          "phone_prefix": "44",
          "mobile_prefix": "44",
          "id": 2681377,
          "answers": [

          ],
          "deleted": false,
          "notifications": {

          },
          "client_type": "Contact",
          "_links": {
            "self": {
              "href": "https://uk.bookingbug.com/api/v1/41284/client/2681377"
            },
            "questions": {
              "href": "https://uk.bookingbug.com/api/v1/41284/client_details"
            }
          }
        },
        "member": {
          "id": 2681377,
          "name": "G F",
          "first_name": "g",
          "last_name": "f",
          "client_type": "Contact",
          "email": "d@de.de",
          "country": "United Kingdom",
          "phone_prefix": "44",
          "mobile_prefix": "44",
          "path": "https://uk.bookingbug.com/api/v1",
          "company_id": 41284,
          "has_active_wallet": false,
          "has_wallet": false,
          "_links": {
            "self": {
              "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377{?embed}",
              "templated": true
            },
            "bookings": {
              "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377/bookings{?start_date,end_date,include_cancelled,page,per_page}",
              "templated": true
            },
            "pre_paid_bookings": {
              "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377/pre_paid_bookings{?include_invalid,event_id}",
              "templated": true
            },
            "purchase_totals": {
              "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377/purchase_totals{?start_date,end_date,page,per_page}",
              "templated": true
            },
            "edit_member": {
              "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377/edit"
            },
            "company": {
              "href": "https://uk.bookingbug.com/api/v1/company/41284"
            },
            "update_password": {
              "href": "https://uk.bookingbug.com/api/v1/login/41284/update_password/2681377"
            },
            "send_welcome_email": {
              "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377/send_welcome_email"
            }
          }
        },
        "bookings": [
          {
            "id": 10272461,
            "full_describe": "Club Fitting with Derrick C at BB Golf - Norwich",
            "describe": "Mon 11th Apr 9:00am",
            "person_name": "Derrick C",
            "datetime": "2016-04-11T09:00:00+01:00",
            "end_datetime": "2016-04-11T10:00:00+01:00",
            "duration": 60,
            "duration_span": 3600,
            "listed_duration": 60,
            "on_waitlist": false,
            "company_id": 41286,
            "attended": true,
            "price": 4000,
            "due_now": 4000,
            "paid": 0,
            "quantity": 1,
            "event_id": 578457,
            "service_id": 65609,
            "purchase_id": 8916829,
            "purchase_ref": "J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D",
            "settings": {
              "person": 19659,
              "earliest_time": "2016-04-08T10:00:00.000Z"
            },
            "min_cancellation_time": "2016-04-10T09:00:00+01:00",
            "service_name": "Club Fitting",
            "time_zone": "Europe/London",
            "address": {
              "id": 36555,
              "address1": "The Forum",
              "address2": "Millennium Plain",
              "address3": "",
              "address4": "Norwich",
              "address5": "Norfolk",
              "postcode": "NR2 1AW",
              "country": "United Kingdom",
              "lat": 52.6277912,
              "long": 1.2909797,
              "map_url": "",
              "map_marker": "The+Forum,+Millennium+Plain,+Norwich,+Norfolk,+NR2+1AW,+United+Kingdom",
              "phone": "+44 (0)1493 990915",
              "homephone": "1493 990915",
              "_links": {
                "self": {
                  "href": "/41286/addresses/36555"
                }
              }
            },
            "booking_type": "Reservation",
            "slot_id": 13766135,
            "first_name": "g",
            "last_name": "f",
            "email": "d@de.de",
            "_embedded": {
              "answers": [
                {
                  "id": 13008709,
                  "value": "d",
                  "price": 0.0,
                  "question_id": 19516,
                  "admin_only": false,
                  "important": false,
                  "_embedded": {
                    "question": {
                      "id": 19516,
                      "name": "Handicap",
                      "position": 1,
                      "required": true,
                      "important": false,
                      "admin_only": false,
                      "applies_to": 0,
                      "ask_member": true,
                      "detail_type": "text_field",
                      "settings": {

                      },
                      "price": 0,
                      "price_per_booking": false,
                      "outcome": false,
                      "_links": {
                        "self": {
                          "href": "/41284/questions/19516"
                        }
                      }
                    }
                  },
                  "question_text": "Handicap",
                  "outcome": false,
                  "company_id": 41284,
                  "_links": {
                    "self": {
                      "href": "/41284/answers/13008709"
                    },
                    "question": {
                      "title": "Handicap",
                      "href": "/41284/questions/19516"
                    }
                  }
                },
                {
                  "id": 13008710,
                  "value": "d",
                  "price": 0.0,
                  "question_id": 19515,
                  "admin_only": false,
                  "important": false,
                  "_embedded": {
                    "question": {
                      "id": 19515,
                      "name": "Height",
                      "position": 0,
                      "required": true,
                      "important": false,
                      "admin_only": false,
                      "applies_to": 0,
                      "ask_member": true,
                      "detail_type": "text_field",
                      "settings": {

                      },
                      "price": 0,
                      "price_per_booking": false,
                      "outcome": false,
                      "_links": {
                        "self": {
                          "href": "/41284/questions/19515"
                        }
                      }
                    }
                  },
                  "question_text": "Height",
                  "outcome": false,
                  "company_id": 41284,
                  "_links": {
                    "self": {
                      "href": "/41284/answers/13008710"
                    },
                    "question": {
                      "title": "Height",
                      "href": "/41284/questions/19515"
                    }
                  }
                },
                {
                  "id": 13008711,
                  "value": "Both",
                  "price": 0.0,
                  "question_id": 19518,
                  "admin_only": false,
                  "important": false,
                  "_embedded": {
                    "question": {
                      "id": 19518,
                      "name": "Club Type",
                      "required": true,
                      "important": false,
                      "admin_only": false,
                      "applies_to": 0,
                      "ask_member": true,
                      "detail_type": "select",
                      "options": [
                        {
                          "name": "Wedges",
                          "price": 0,
                          "is_default": false,
                          "id": 36142
                        },
                        {
                          "name": "Iron",
                          "price": 0,
                          "is_default": false,
                          "id": 36143
                        },
                        {
                          "name": "Both",
                          "price": 0,
                          "is_default": false,
                          "id": 36144
                        }
                      ],
                      "settings": {

                      },
                      "price": 0,
                      "price_per_booking": false,
                      "outcome": false,
                      "_links": {
                        "self": {
                          "href": "/41284/questions/19518"
                        }
                      }
                    }
                  },
                  "question_text": "Club Type",
                  "outcome": false,
                  "company_id": 41284,
                  "_links": {
                    "self": {
                      "href": "/41284/answers/13008711"
                    },
                    "question": {
                      "title": "Club Type",
                      "href": "/41284/questions/19518"
                    }
                  }
                },
                {
                  "id": 13008712,
                  "price": 0.0,
                  "question_id": 22818,
                  "admin_only": false,
                  "important": false,
                  "_embedded": {
                    "question": {
                      "id": 22818,
                      "name": "Date",
                      "required": false,
                      "important": false,
                      "admin_only": false,
                      "applies_to": 0,
                      "ask_member": true,
                      "detail_type": "date",
                      "settings": {

                      },
                      "price": 0,
                      "price_per_booking": false,
                      "outcome": false,
                      "_links": {
                        "self": {
                          "href": "/41284/questions/22818"
                        }
                      }
                    }
                  },
                  "question_text": "Date",
                  "outcome": false,
                  "company_id": 41284,
                  "_links": {
                    "self": {
                      "href": "/41284/answers/13008712"
                    },
                    "question": {
                      "title": "Date",
                      "href": "/41284/questions/22818"
                    }
                  }
                }
              ],
              "survey_answers": [

              ]
            },
            "_links": {
              "self": {
                "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/bookings/10272461"
              },
              "check_in": {
                "href": "https://uk.bookingbug.com/api/v1/bookings/10272461/check_in"
              },
              "attachments": {
                "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/bookings/10272461/attach"
              },
              "person": {
                "href": "https://uk.bookingbug.com/api/v1/41286/people/19659"
              },
              "service": {
                "href": "https://uk.bookingbug.com/api/v1/41286/services/65609"
              },
              "company": {
                "href": "https://uk.bookingbug.com/api/v1/company/41286"
              },
              "client": {
                "href": "https://uk.bookingbug.com/api/v1/41286/client/2681377"
              },
              "member": {
                "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377{?embed}",
                "templated": true
              },
              "survey_questions": {
                "href": "https://uk.bookingbug.com/api/v1/41286/23040/survey_questions{?admin_only}",
                "templated": true
              }
            }
          }
        ],
        "packages": [

        ],
        "products": [

        ],
        "pre_paid_bookings": [

        ],
        "deals": [

        ],
        "course_bookings": [

        ],
        "external_purchases": [

        ],
        "confirm_messages": [

        ]
      },
      "_links": {
        "self": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D"
        },
        "ical": {
          "href": "http://uk.bookingbug.com/ical/total/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D"
        },
        "web_cal": {
          "href": "webcal://uk.bookingbug.com/ical/total/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D"
        },
        "gcal": {
          "href": "http://www.google.com/calendar/event?dates=20160411T080000Z%2F20160411T090000Z&details=&sprop=www.bookingbug.com&text=Reservation%3A+Club+Fitting+with+Derrick+C+at+BB+Golf+-+Norwich&trp=false&action=TEMPLATE"
        },
        "client": {
          "href": "https://uk.bookingbug.com/api/v1/41286/client/2681377"
        },
        "member": {
          "href": "https://uk.bookingbug.com/api/v1/41284/members/2681377{?embed}",
          "templated": true
        },
        "company": {
          "href": "https://uk.bookingbug.com/api/v1/company/41286"
        },
        "bookings": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/bookings"
        },
        "packages": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/packages"
        },
        "pre_paid_bookings": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/pre_paid_bookings"
        },
        "products": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/products"
        },
        "deals": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/deals"
        },
        "confirm_messages": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/confirm_messages"
        },
        "book_waitlist_item": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/book_waitlist_item"
        },
        "external_purchases": {
          "href": "https://uk.bookingbug.com/api/v1/purchases/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D/external_purchases"
        },
        "print": {
          "href": "/angular/print_purchase.html?id=J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D&company_id=41286"
        },
        "paypal_express": {
          "href": "/pay/paypal_express/J4vqfqRAFJ7QNf9WODkxNjgyOQ%3D%3D{?landing_page,allow_guest_checkout,allow_note,logo_image,max_amount,no_shipping,allowed_payment_method}",
          "templated": true,
          "type": "location"
        }
      }
    }

    $httpBackend
    .whenPOST /.*checkout/
    .respond checkoutResponse

    $httpBackend
    .whenPOST /.*/
    .passThrough()

    $httpBackend
    .whenGET /.*/
    .passThrough()

    return
  return
