/**
 * @ngdoc overview
 * @name BBAdminDashboard.translations
 * @description
 * Translations for the admin core module
 */
angular.module('BBAdminDashboard').config(function($translateProvider) {
    'ngInject';
    var translations;
    translations = {
        SIDE_NAV_BOOKINGS: "BOOKINGS",
        SIDE_NAV_CONFIG: "CONFIGURATION",
        ADMIN_DASHBOARD: {
            CORE: {
                GREETING: 'Hi',
                LOGOUT: 'Logout',
                VERSION: 'Version',
                COPYRIGHT: 'Copyright',
                SWITCH_TO_CLASSIC: 'Switch to Classic',
                PREFERENCES: {
                    SET_TIMEZONE_LABEL: 'Set timezone automatically',
                    SET_TIMEZONE_ON_LABEL: 'On',
                    SET_TIMEZONE_OFF_LABEL: 'Off',
                    TIMEZONE_LABEL: 'Timezone'
                }
            }
        },
        LOCATIONS: {
            ABIDJAN: "Abidjan",
            ACCRA: "Accra",
            ADDIS_ABABA: "Addis Ababa",
            ALGIERS: "Algiers",
            ASMARA: "Asmara",
            ASMERA: "Asmera",
            BAMAKO: "Bamako",
            BANGUI: "Bangui",
            BANJUL: "Banjul",
            BISSAU: "Bissau",
            BLANTYRE: "Blantyre",
            BRAZZAVILLE: "Brazzaville",
            BUJUMBURA: "Bujumbura",
            CAIRO: "Cairo",
            CASABLANCA: "Casablanca",
            CEUTA: "Ceuta",
            CONAKRY: "Conakry",
            DAKAR: "Dakar",
            DAR_ES_SALAAM: "Dar es Salaam",
            DJIBOUTI: "Djibouti",
            DOUALA: "Douala",
            EL_AAIUN: "El Aaiun",
            FREETOWN: "Freetown",
            GABORONE: "Gaborone",
            HARARE: "Harare",
            JOHANNESBURG: "Johannesburg",
            JUBA: "Juba",
            KAMPALA: "Kampala",
            KHARTOUM: "Khartoum",
            KIGALI: "Kigali",
            KINSHASA: "Kinshasa",
            LAGOS: "Lagos",
            LIBREVILLE: "Libreville",
            LOME: "Lome",
            LUANDA: "Luanda",
            LUBUMBASHI: "Lubumbashi",
            LUSAKA: "Lusaka",
            MALABO: "Malabo",
            MAPUTO: "Maputo",
            MASERU: "Maseru",
            MBABANE: "Mbabane",
            MOGADISHU: "Mogadishu",
            MONROVIA: "Monrovia",
            NAIROBI: "Nairobi",
            NDJAMENA: "Ndjamena",
            NIAMEY: "Niamey",
            NOUAKCHOTT: "Nouakchott",
            OUAGADOUGOU: "Ouagadougou",
            PORTO_NOVO: "Porto-Novo",
            SAO_TOME: "Sao Tome",
            TIMBUKTU: "Timbuktu",
            TRIPOLI: "Tripoli",
            TUNIS: "Tunis",
            WINDHOEK: "Windhoek",
            ADAK: "Adak",
            ANCHORAGE: "Anchorage",
            ANGUILLA: "Anguilla",
            ANTIGUA: "Antigua",
            ARAGUAINA: "Araguaina",
            BUENOS_AIRES: "Buenos Aires",
            CATAMARCA: "Catamarca",
            COMODRIVADAVIA: "ComodRivadavia",
            CORDOBA: "Cordoba",
            JUJUY: "Jujuy",
            LA_RIOJA: "La Rioja",
            MENDOZA: "Mendoza",
            RIO_GALLEGOS: "Rio Gallegos",
            SALTA: "Salta",
            SAN_JUAN: "San Juan",
            SAN_LUIS: "San Luis",
            TUCUMAN: "Tucuman",
            USHUAIA: "Ushuaia",
            ARUBA: "Aruba",
            ASUNCION: "Asuncion",
            ATIKOKAN: "Atikokan",
            ATKA: "Atka",
            BAHIA: "Bahia",
            BAHIA_BANDERAS: "Bahia Banderas",
            BARBADOS: "Barbados",
            BELEM: "Belem",
            BELIZE: "Belize",
            BLANC_SABLON: "Blanc-Sablon",
            BOA_VISTA: "Boa Vista",
            BOGOTA: "Bogota",
            BOISE: "Boise",
            BUENOS_AIRES: "Buenos Aires",
            CAMBRIDGE_BAY: "Cambridge Bay",
            CAMPO_GRANDE: "Campo Grande",
            CANCUN: "Cancun",
            CARACAS: "Caracas",
            CATAMARCA: "Catamarca",
            CAYENNE: "Cayenne",
            CAYMAN: "Cayman",
            CHICAGO: "Chicago",
            CHIHUAHUA: "Chihuahua",
            CORAL_HARBOUR: "Coral Harbour",
            CORDOBA: "Cordoba",
            COSTA_RICA: "Costa Rica",
            CRESTON: "Creston",
            CUIABA: "Cuiaba",
            CURACAO: "Curacao",
            DANMARKSHAVN: "Danmarkshavn",
            DAWSON: "Dawson",
            DAWSON_CREEK: "Dawson Creek",
            DENVER: "Denver",
            DETROIT: "Detroit",
            DOMINICA: "Dominica",
            EDMONTON: "Edmonton",
            EIRUNEPE: "Eirunepe",
            EL_SALVADOR: "El Salvador",
            ENSENADA: "Ensenada",
            FORT_NELSON: "Fort Nelson",
            FORT_WAYNE: "Fort Wayne",
            FORTALEZA: "Fortaleza",
            GLACE_BAY: "Glace Bay",
            GODTHAB: "Godthab",
            GOOSE_BAY: "Goose Bay",
            GRAND_TURK: "Grand Turk",
            GRENADA: "Grenada",
            GUADELOUPE: "Guadeloupe",
            GUATEMALA: "Guatemala",
            GUAYAQUIL: "Guayaquil",
            GUYANA: "Guyana",
            HALIFAX: "Halifax",
            HAVANA: "Havana",
            HERMOSILLO: "Hermosillo",
            INDIANAPOLIS: "Indianapolis",
            KNOX: "Knox",
            MARENGO: "Marengo",
            PETERSBURG: "Petersburg",
            TELL_CITY: "Tell City",
            VEVAY: "Vevay",
            VINCENNES: "Vincennes",
            WINAMAC: "Winamac",
            INDIANAPOLIS: "Indianapolis",
            INUVIK: "Inuvik",
            IQALUIT: "Iqaluit",
            JAMAICA: "Jamaica",
            JUJUY: "Jujuy",
            JUNEAU: "Juneau",
            LOUISVILLE: "Louisville",
            MONTICELLO: "Monticello",
            KNOX_IN: "Knox IN",
            KRALENDIJK: "Kralendijk",
            LA_PAZ: "La Paz",
            LIMA: "Lima",
            LOS_ANGELES: "Los Angeles",
            LOUISVILLE: "Louisville",
            LOWER_PRINCES: "Lower Princes",
            MACEIO: "Maceio",
            MANAGUA: "Managua",
            MANAUS: "Manaus",
            MARIGOT: "Marigot",
            MARTINIQUE: "Martinique",
            MATAMOROS: "Matamoros",
            MAZATLAN: "Mazatlan",
            MENDOZA: "Mendoza",
            MENOMINEE: "Menominee",
            MERIDA: "Merida",
            METLAKATLA: "Metlakatla",
            MEXICO_CITY: "Mexico City",
            MIQUELON: "Miquelon",
            MONCTON: "Moncton",
            MONTERREY: "Monterrey",
            MONTEVIDEO: "Montevideo",
            MONTREAL: "Montreal",
            MONTSERRAT: "Montserrat",
            NASSAU: "Nassau",
            NEW_YORK: "New York",
            NIPIGON: "Nipigon",
            NOME: "Nome",
            NORONHA: "Noronha",
            BEULAH: "Beulah",
            CENTER: "Center",
            NEW_SALEM: "New Salem",
            OJINAGA: "Ojinaga",
            PANAMA: "Panama",
            PANGNIRTUNG: "Pangnirtung",
            PARAMARIBO: "Paramaribo",
            PHOENIX: "Phoenix",
            PORT_AU_PRINCE: "Port-au-Prince",
            PORT_OF_SPAIN: "Port of Spain",
            PORTO_ACRE: "Porto Acre",
            PORTO_VELHO: "Porto Velho",
            PUERTO_RICO: "Puerto Rico",
            RAINY_RIVER: "Rainy River",
            RANKIN_INLET: "Rankin Inlet",
            RECIFE: "Recife",
            REGINA: "Regina",
            RESOLUTE: "Resolute",
            RIO_BRANCO: "Rio Branco",
            ROSARIO: "Rosario",
            SANTA_ISABEL: "Santa Isabel",
            SANTAREM: "Santarem",
            SANTIAGO: "Santiago",
            SANTO_DOMINGO: "Santo Domingo",
            SAO_PAULO: "Sao Paulo",
            SCORESBYSUND: "Scoresbysund",
            SHIPROCK: "Shiprock",
            SITKA: "Sitka",
            ST_BARTHELEMY: "St Barthelemy",
            ST_JOHNS: "St Johns",
            ST_KITTS: "St Kitts",
            ST_LUCIA: "St Lucia",
            ST_THOMAS: "St Thomas",
            ST_VINCENT: "St Vincent",
            SWIFT_CURRENT: "Swift Current",
            TEGUCIGALPA: "Tegucigalpa",
            THULE: "Thule",
            THUNDER_BAY: "Thunder Bay",
            TIJUANA: "Tijuana",
            TORONTO: "Toronto",
            TORTOLA: "Tortola",
            VANCOUVER: "Vancouver",
            VIRGIN: "Virgin",
            WHITEHORSE: "Whitehorse",
            WINNIPEG: "Winnipeg",
            YAKUTAT: "Yakutat",
            YELLOWKNIFE: "Yellowknife",
            CASEY: "Casey",
            DAVIS: "Davis",
            DUMONTDURVILLE: "DumontDUrville",
            MACQUARIE: "Macquarie",
            MAWSON: "Mawson",
            MCMURDO: "McMurdo",
            PALMER: "Palmer",
            ROTHERA: "Rothera",
            SOUTH_POLE: "South Pole",
            SYOWA: "Syowa",
            TROLL: "Troll",
            VOSTOK: "Vostok",
            LONGYEARBYEN: "Longyearbyen",
            ADEN: "Aden",
            ALMATY: "Almaty",
            AMMAN: "Amman",
            ANADYR: "Anadyr",
            AQTAU: "Aqtau",
            AQTOBE: "Aqtobe",
            ASHGABAT: "Ashgabat",
            ASHKHABAD: "Ashkhabad",
            ATYRAU: "Atyrau",
            BAGHDAD: "Baghdad",
            BAHRAIN: "Bahrain",
            BAKU: "Baku",
            BANGKOK: "Bangkok",
            BARNAUL: "Barnaul",
            BEIRUT: "Beirut",
            BISHKEK: "Bishkek",
            BRUNEI: "Brunei",
            CALCUTTA: "Calcutta",
            CHITA: "Chita",
            CHOIBALSAN: "Choibalsan",
            CHONGQING: "Chongqing",
            CHUNGKING: "Chungking",
            COLOMBO: "Colombo",
            DACCA: "Dacca",
            DAMASCUS: "Damascus",
            DHAKA: "Dhaka",
            DILI: "Dili",
            DUBAI: "Dubai",
            DUSHANBE: "Dushanbe",
            FAMAGUSTA: "Famagusta",
            GAZA: "Gaza",
            HARBIN: "Harbin",
            HEBRON: "Hebron",
            HO_CHI_MINH: "Ho Chi Minh",
            HONG_KONG: "Hong Kong",
            HOVD: "Hovd",
            IRKUTSK: "Irkutsk",
            ISTANBUL: "Istanbul",
            JAKARTA: "Jakarta",
            JAYAPURA: "Jayapura",
            JERUSALEM: "Jerusalem",
            KABUL: "Kabul",
            KAMCHATKA: "Kamchatka",
            KARACHI: "Karachi",
            KASHGAR: "Kashgar",
            KATHMANDU: "Kathmandu",
            KATMANDU: "Katmandu",
            KHANDYGA: "Khandyga",
            KOLKATA: "Kolkata",
            KRASNOYARSK: "Krasnoyarsk",
            KUALA_LUMPUR: "Kuala Lumpur",
            KUCHING: "Kuching",
            KUWAIT: "Kuwait",
            MACAO: "Macao",
            MACAU: "Macau",
            MAGADAN: "Magadan",
            MAKASSAR: "Makassar",
            MANILA: "Manila",
            MUSCAT: "Muscat",
            NICOSIA: "Nicosia",
            NOVOKUZNETSK: "Novokuznetsk",
            NOVOSIBIRSK: "Novosibirsk",
            OMSK: "Omsk",
            ORAL: "Oral",
            PHNOM_PENH: "Phnom Penh",
            PONTIANAK: "Pontianak",
            PYONGYANG: "Pyongyang",
            QATAR: "Qatar",
            QYZYLORDA: "Qyzylorda",
            RANGOON: "Rangoon",
            RIYADH: "Riyadh",
            SAIGON: "Saigon",
            SAKHALIN: "Sakhalin",
            SAMARKAND: "Samarkand",
            SEOUL: "Seoul",
            SHANGHAI: "Shanghai",
            SINGAPORE: "Singapore",
            SREDNEKOLYMSK: "Srednekolymsk",
            TAIPEI: "Taipei",
            TASHKENT: "Tashkent",
            TBILISI: "Tbilisi",
            TEHRAN: "Tehran",
            TEL_AVIV: "Tel Aviv",
            THIMBU: "Thimbu",
            THIMPHU: "Thimphu",
            TOKYO: "Tokyo",
            TOMSK: "Tomsk",
            UJUNG_PANDANG: "Ujung Pandang",
            ULAANBAATAR: "Ulaanbaatar",
            ULAN_BATOR: "Ulan Bator",
            URUMQI: "Urumqi",
            UST_NERA: "Ust-Nera",
            VIENTIANE: "Vientiane",
            VLADIVOSTOK: "Vladivostok",
            YAKUTSK: "Yakutsk",
            YANGON: "Yangon",
            YEKATERINBURG: "Yekaterinburg",
            YEREVAN: "Yerevan",
            AZORES: "Azores",
            BERMUDA: "Bermuda",
            CANARY: "Canary",
            CAPE_VERDE: "Cape Verde",
            FAEROE: "Faeroe",
            FAROE: "Faroe",
            JAN_MAYEN: "Jan Mayen",
            MADEIRA: "Madeira",
            REYKJAVIK: "Reykjavik",
            SOUTH_GEORGIA: "South Georgia",
            ST_HELENA: "St Helena",
            STANLEY: "Stanley",
            ADELAIDE: "Adelaide",
            BRISBANE: "Brisbane",
            BROKEN_HILL: "Broken Hill",
            CANBERRA: "Canberra",
            CURRIE: "Currie",
            DARWIN: "Darwin",
            EUCLA: "Eucla",
            HOBART: "Hobart",
            LINDEMAN: "Lindeman",
            LORD_HOWE: "Lord Howe",
            MELBOURNE: "Melbourne",
            NORTH: "North",
            PERTH: "Perth",
            QUEENSLAND: "Queensland",
            SOUTH: "South",
            SYDNEY: "Sydney",
            TASMANIA: "Tasmania",
            VICTORIA: "Victoria",
            WEST: "West",
            YANCOWINNA: "Yancowinna",
            ACRE: "Acre",
            DENORONHA: "DeNoronha",
            EAST: "East",
            WEST: "West",
            ATLANTIC: "Atlantic",
            CENTRAL: "Central",
            EAST_SASKATCHEWAN: "East-Saskatchewan",
            EASTERN: "Eastern",
            MOUNTAIN: "Mountain",
            NEWFOUNDLAND: "Newfoundland",
            PACIFIC: "Pacific",
            SASKATCHEWAN: "Saskatchewan",
            YUKON: "Yukon",
            CONTINENTAL: "Continental",
            EASTERISLAND: "EasterIsland",
            CUBA: "Cuba",
            EGYPT: "Egypt",
            EIRE: "Eire",
            AMSTERDAM: "Amsterdam",
            ANDORRA: "Andorra",
            ASTRAKHAN: "Astrakhan",
            ATHENS: "Athens",
            BELFAST: "Belfast",
            BELGRADE: "Belgrade",
            BERLIN: "Berlin",
            BRATISLAVA: "Bratislava",
            BRUSSELS: "Brussels",
            BUCHAREST: "Bucharest",
            BUDAPEST: "Budapest",
            BUSINGEN: "Busingen",
            CHISINAU: "Chisinau",
            COPENHAGEN: "Copenhagen",
            DUBLIN: "Dublin",
            GIBRALTAR: "Gibraltar",
            GUERNSEY: "Guernsey",
            HELSINKI: "Helsinki",
            ISLE_OF_MAN: "Isle of Man",
            ISTANBUL: "Istanbul",
            JERSEY: "Jersey",
            KALININGRAD: "Kaliningrad",
            KIEV: "Kiev",
            KIROV: "Kirov",
            LISBON: "Lisbon",
            LJUBLJANA: "Ljubljana",
            LONDON: "London",
            LUXEMBOURG: "Luxembourg",
            MADRID: "Madrid",
            MALTA: "Malta",
            MARIEHAMN: "Mariehamn",
            MINSK: "Minsk",
            MONACO: "Monaco",
            MOSCOW: "Moscow",
            NICOSIA: "Nicosia",
            OSLO: "Oslo",
            PARIS: "Paris",
            PODGORICA: "Podgorica",
            PRAGUE: "Prague",
            RIGA: "Riga",
            ROME: "Rome",
            SAMARA: "Samara",
            SAN_MARINO: "San Marino",
            SARAJEVO: "Sarajevo",
            SARATOV: "Saratov",
            SIMFEROPOL: "Simferopol",
            SKOPJE: "Skopje",
            SOFIA: "Sofia",
            STOCKHOLM: "Stockholm",
            TALLINN: "Tallinn",
            TIRANE: "Tirane",
            TIRASPOL: "Tiraspol",
            ULYANOVSK: "Ulyanovsk",
            UZHGOROD: "Uzhgorod",
            VADUZ: "Vaduz",
            VATICAN: "Vatican",
            VIENNA: "Vienna",
            VILNIUS: "Vilnius",
            VOLGOGRAD: "Volgograd",
            WARSAW: "Warsaw",
            ZAGREB: "Zagreb",
            ZAPOROZHYE: "Zaporozhye",
            ZURICH: "Zurich",
            GB_EIRE: "GB-Eire",
            GREENWICH: "Greenwich",
            HONGKONG: "Hongkong",
            ICELAND: "Iceland",
            ANTANANARIVO: "Antananarivo",
            CHAGOS: "Chagos",
            CHRISTMAS: "Christmas",
            COCOS: "Cocos",
            COMORO: "Comoro",
            KERGUELEN: "Kerguelen",
            MAHE: "Mahe",
            MALDIVES: "Maldives",
            MAURITIUS: "Mauritius",
            MAYOTTE: "Mayotte",
            REUNION: "Reunion",
            IRAN: "Iran",
            ISRAEL: "Israel",
            JAMAICA: "Jamaica",
            JAPAN: "Japan",
            KWAJALEIN: "Kwajalein",
            LIBYA: "Libya",
            BAJANORTE: "BajaNorte",
            BAJASUR: "BajaSur",
            GENERAL: "General",
            NAVAJO: "Navajo",
            APIA: "Apia",
            AUCKLAND: "Auckland",
            BOUGAINVILLE: "Bougainville",
            CHATHAM: "Chatham",
            CHUUK: "Chuuk",
            EASTER: "Easter",
            EFATE: "Efate",
            ENDERBURY: "Enderbury",
            FAKAOFO: "Fakaofo",
            FIJI: "Fiji",
            FUNAFUTI: "Funafuti",
            GALAPAGOS: "Galapagos",
            GAMBIER: "Gambier",
            GUADALCANAL: "Guadalcanal",
            GUAM: "Guam",
            HONOLULU: "Honolulu",
            JOHNSTON: "Johnston",
            KIRITIMATI: "Kiritimati",
            KOSRAE: "Kosrae",
            KWAJALEIN: "Kwajalein",
            MAJURO: "Majuro",
            MARQUESAS: "Marquesas",
            MIDWAY: "Midway",
            NAURU: "Nauru",
            NIUE: "Niue",
            NORFOLK: "Norfolk",
            NOUMEA: "Noumea",
            PAGO_PAGO: "Pago Pago",
            PALAU: "Palau",
            PITCAIRN: "Pitcairn",
            POHNPEI: "Pohnpei",
            PONAPE: "Ponape",
            PORT_MORESBY: "Port Moresby",
            RAROTONGA: "Rarotonga",
            SAIPAN: "Saipan",
            SAMOA: "Samoa",
            TAHITI: "Tahiti",
            TARAWA: "Tarawa",
            TONGATAPU: "Tongatapu",
            TRUK: "Truk",
            WAKE: "Wake",
            WALLIS: "Wallis",
            YAP: "Yap",
            POLAND: "Poland",
            PORTUGAL: "Portugal",
            SINGAPORE: "Singapore",
            TURKEY: "Turkey",
            ALASKA: "Alaska",
            ALEUTIAN: "Aleutian",
            ARIZONA: "Arizona",
            CENTRAL: "Central",
            EAST_INDIANA: "East-Indiana",
            EASTERN: "Eastern",
            HAWAII: "Hawaii",
            INDIANA_STARKE: "Indiana-Starke",
            MICHIGAN: "Michigan",
            MOUNTAIN: "Mountain",
            PACIFIC: "Pacific",
            PACIFIC_NEW: "Pacific-New",
            SAMOA: "Samoa",
            UNIVERSAL: "Universal",
            ZULU: "Zulu"
        }
    };
    $translateProvider.translations('en', translations);
});
