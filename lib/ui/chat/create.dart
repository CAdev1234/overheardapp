import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overheard_flutter_app/constants/colorset.dart';
import 'package:overheard_flutter_app/constants/fontsizeset.dart';
import 'package:overheard_flutter_app/constants/stringset.dart';
import 'package:overheard_flutter_app/ui/chat/bloc/chat_bloc.dart';
import 'package:overheard_flutter_app/ui/chat/repository/chat.repository.dart';
import 'package:overheard_flutter_app/ui/components/alphabet_scroll.dart';
import 'package:overheard_flutter_app/ui/components/glassmorphism.dart';

class ChatCreateScreen extends StatefulWidget {
  const ChatCreateScreen({Key? key}): super();
  
  @override
  ChatCreateScreenState createState() {
    return ChatCreateScreenState();
  }
}

class ChatCreateScreenState extends State<ChatCreateScreen> {
  late ChatBloc chatBloc;
  late TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc(chatRepository: ChatRepository());
  }

  PreferredSizeWidget customAppBarWidget(BuildContext context) {
    return CupertinoNavigationBar(
      leading: GestureDetector(
        onTap: (){
          Navigator.of(context).pop(context);
        },
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            CancelButtonText,
            style: TextStyle(
                color: primaryWhiteTextColor,
                fontSize: primaryButtonMiddleFontSize
            ),
            textScaleFactor: 1.0,
          ),
        ),
      ),
      middle: const Text(
        createChatAppBarTitle,
        style: TextStyle(
            fontSize: appBarTitleFontSize,
            color: primaryWhiteTextColor
        ),
        textScaleFactor: 1.0,
      ),
      trailing: GestureDetector(
        onTap: (){},
        child: const Text(
          CancelButtonText,
          style: TextStyle(
              color: Colors.transparent,
              fontSize: primaryButtonMiddleFontSize
          ),
        ),
      ),
    );
  }

  Widget searchInputWidget(BuildContext context) {
    return Center(
      child: Glassmorphism(
        blur: 20, 
        opacity: 0.2, 
        borderRadius: 10, 
        child: Container(
          width: MediaQuery.of(context).size.width - 5 * 2,
          height: 40,
          alignment: Alignment.center,
          child: Theme(
            data: Theme.of(context).copyWith(
                // textSelectionHandleColor: Colors.transparent,
                primaryColor: Colors.transparent,
                scaffoldBackgroundColor:Colors.transparent,
                bottomAppBarColor: Colors.transparent
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value){},
              cursorColor: primaryPlaceholderTextColor,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(color: primaryWhiteTextColor),
                hintText: searchPlaceholder,
                prefixIcon: const Icon(Icons.search, color: primaryWhiteTextColor),
                suffixIcon: searchController.text.isNotEmpty ?
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: const Icon(Icons.cancel, color: primaryWhiteTextColor),
                ):
                const Text(''),
                contentPadding: const EdgeInsets.only(
                  bottom: 40 / 2,  // HERE THE IMPORTANT PART
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              style: const TextStyle(
                  color: primaryWhiteTextColor,
                  fontSize: primaryTextFieldFontSize
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: chatBloc,
      listener: (context, state) async{

      },
      child: Container(
        decoration: primaryBoxDecoration,
        child: Scaffold(
          appBar: customAppBarWidget(context),
          backgroundColor: Colors.transparent,
          body: BlocBuilder(
            bloc: chatBloc,
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      searchInputWidget(context),
                      const SizedBox(height: 10),
                      const Divider(height: 1, color: primaryWhiteTextColor),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: SizedBox(
                          child: AlphabetScrollList(
                            // onClickedItem: () {},
                            items: [
                              "Afghanistan",
                              "Albania",
                              "Algeria",
                              "American Samoa",
                              "Andorra",
                              "Angola",
                              "Anguilla",
                              "Antarctica",
                              "Antigua and Barbuda",
                              "Argentina",
                              "Armenia",
                              "Aruba",
                              "Australia",
                              "Austria",
                              "Azerbaijan",
                              "Bahamas (the)",
                              "Bahrain",
                              "Bangladesh",
                              "Barbados",
                              "Belarus",
                              "Belgium",
                              "Belize",
                              "Benin",
                              "Bermuda",
                              "Bhutan",
                              "Bolivia (Plurinational State of)",
                              "Bonaire, Sint Eustatius and Saba",
                              "Bosnia and Herzegovina",
                              "Botswana",
                              "Bouvet Island",
                              "Brazil",
                              "British Indian Ocean Territory (the)",
                              "Brunei Darussalam",
                              "Bulgaria",
                              "Burkina Faso",
                              "Burundi",
                              "Cabo Verde",
                              "Cambodia",
                              "Cameroon",
                              "Canada",
                              "Cayman Islands (the)",
                              "Central African Republic (the)",
                              "Chad",
                              "Chile",
                              "China",
                              "Christmas Island",
                              "Cocos (Keeling) Islands (the)",
                              "Colombia",
                              "Comoros (the)",
                              "Congo (the Democratic Republic of the)",
                              "Congo (the)",
                              "Cook Islands (the)",
                              "Costa Rica",
                              "Croatia",
                              "Cuba",
                              "Curaçao",
                              "Cyprus",
                              "Czechia",
                              "Côte d'Ivoire",
                              "Denmark",
                              "Djibouti",
                              "Dominica",
                              "Dominican Republic (the)",
                              "Ecuador",
                              "Egypt",
                              "El Salvador",
                              "Equatorial Guinea",
                              "Eritrea",
                              "Estonia",
                              "Eswatini",
                              "Ethiopia",
                              "Falkland Islands (the) [Malvinas]",
                              "Faroe Islands (the)",
                              "Fiji",
                              "Finland",
                              "France",
                              "French Guiana",
                              "French Polynesia",
                              "French Southern Territories (the)",
                              "Gabon",
                              "Gambia (the)",
                              "Georgia",
                              "Germany",
                              "Ghana",
                              "Gibraltar",
                              "Greece",
                              "Greenland",
                              "Grenada",
                              "Guadeloupe",
                              "Guam",
                              "Guatemala",
                              "Guernsey",
                              "Guinea",
                              "Guinea-Bissau",
                              "Guyana",
                              "Haiti",
                              "Heard Island and McDonald Islands",
                              "Holy See (the)",
                              "Honduras",
                              "Hong Kong",
                              "Hungary",
                              "Iceland",
                              "India",
                              "Indonesia",
                              "Iran (Islamic Republic of)",
                              "Iraq",
                              "Ireland",
                              "Isle of Man",
                              "Israel",
                              "Italy",
                              "Jamaica",
                              "Japan",
                              "Jersey",
                              "Jordan",
                              "Kazakhstan",
                              "Kenya",
                              "Kiribati",
                              "Korea (the Democratic People's Republic of)",
                              "Korea (the Republic of)",
                              "Kuwait",
                              "Kyrgyzstan",
                              "Lao People's Democratic Republic (the)",
                              "Latvia",
                              "Lebanon",
                              "Lesotho",
                              "Liberia",
                              "Libya",
                              "Liechtenstein",
                              "Lithuania",
                              "Luxembourg",
                              "Macao",
                              "Madagascar",
                              "Malawi",
                              "Malaysia",
                              "Maldives",
                              "Mali",
                              "Malta",
                              "Marshall Islands (the)",
                              "Martinique",
                              "Mauritania",
                              "Mauritius",
                              "Mayotte",
                              "Mexico",
                              "Micronesia (Federated States of)",
                              "Moldova (the Republic of)",
                              "Monaco",
                              "Mongolia",
                              "Montenegro",
                              "Montserrat",
                              "Morocco",
                              "Mozambique",
                              "Myanmar",
                              "Namibia",
                              "Nauru",
                              "Nepal",
                              "Netherlands (the)",
                              "New Caledonia",
                              "New Zealand",
                              "Nicaragua",
                              "Niger (the)",
                              "Nigeria",
                              "Niue",
                              "Norfolk Island",
                              "Northern Mariana Islands (the)",
                              "Norway",
                              "Oman",
                              "Pakistan",
                              "Palau",
                              "Palestine, State of",
                              "Panama",
                              "Papua New Guinea",
                              "Paraguay",
                              "Peru",
                              "Philippines (the)",
                              "Pitcairn",
                              "Poland",
                              "Portugal",
                              "Puerto Rico",
                              "Qatar",
                              "Republic of North Macedonia",
                              "Romania",
                              "Russian Federation (the)",
                              "Rwanda",
                              "Réunion",
                              "Saint Barthélemy",
                              "Saint Helena, Ascension and Tristan da Cunha",
                              "Saint Kitts and Nevis",
                              "Saint Lucia",
                              "Saint Martin (French part)",
                              "Saint Pierre and Miquelon",
                              "Saint Vincent and the Grenadines",
                              "Samoa",
                              "San Marino",
                              "Sao Tome and Principe",
                              "Saudi Arabia",
                              "Senegal",
                              "Serbia",
                              "Seychelles",
                              "Sierra Leone",
                              "Singapore",
                              "Sint Maarten (Dutch part)",
                              "Slovakia",
                              "Slovenia",
                              "Solomon Islands",
                              "Somalia",
                              "South Africa",
                              "South Georgia and the South Sandwich Islands",
                              "South Sudan",
                              "Spain",
                              "Sri Lanka",
                              "Sudan (the)",
                              "Suriname",
                              "Svalbard and Jan Mayen",
                              "Sweden",
                              "Switzerland",
                              "Syrian Arab Republic",
                              "Taiwan",
                              "Tajikistan",
                              "Tanzania, United Republic of",
                              "Thailand",
                              "Timor-Leste",
                              "Togo",
                              "Tokelau",
                              "Tonga",
                              "Trinidad and Tobago",
                              "Tunisia",
                              "Turkey",
                              "Turkmenistan",
                              "Turks and Caicos Islands (the)",
                              "Tuvalu",
                              "Uganda",
                              "Ukraine",
                              "United Arab Emirates (the)",
                              "United Kingdom of Great Britain and Northern Ireland (the)",
                              "United States Minor Outlying Islands (the)",
                              "United States of America (the)",
                              "Uruguay",
                              "Uzbekistan",
                              "Vanuatu",
                              "Venezuela (Bolivarian Republic of)",
                              "Viet Nam",
                              "Virgin Islands (British)",
                              "Virgin Islands (U.S.)",
                              "Wallis and Futuna",
                              "Western Sahara",
                              "Yemen",
                              "Zambia",
                              "Zimbabwe",
                              "Åland Islands"
                        ],
                      ),
                        ) 
                      )
                      
                    ],
                  ),
                )
              );
            },
          ),
        ),
      ), 
    );
  }
}