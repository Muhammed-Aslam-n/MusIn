import 'package:flutter/material.dart';
import 'package:musin/materials/colors.dart';
import 'package:musin/pages/widgets/widgets.dart';
import 'package:get/get.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#A6B9FF"),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            const CommonHeaders(
              title: "Privacy Policy",
              subtitle: "We care About Your Privacy ",
              pLeft: 0.0,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text("Last updated: November 01, 2021"),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: HexColor("#A6B9FF"),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: privacyText(
                      content:
                          "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You." "We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy. ")),
            ),
            sizedh2,
            commonText(text: "Interpretation and Definitions", size: 19),
            sizedh1,
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            commonText(text: "Interpretation", size: 17),
            sizedh1,
            privacyText(
                content:
                    "The words of which the initial letter is capitalised have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural."),
            sizedh1,
            commonText(text: "Definitions", size: 17),
            sizedh1,
            privacyText(content: "For the purposes of this Privacy Policy:"),
            sizedh1,
            bullettedList("Account",
                "means a unique account created for You to access our Service or parts of our Service."),
            sizedh1,
            bullettedList("Affiliate",
                """ means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority. """),
            sizedh1,
            bullettedList("Application",
                """ means the software program provided by the Company downloaded by You on any electronic device, named Musin """),
            sizedh1,
            bullettedList("Company",
                """ (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Musin. """),
            sizedh1,
            bullettedList("Country", """ refers to: Kerala, India """),
            sizedh1,
            bullettedList("Device",
                """ means any device that can access the Service such as a computer, a cellphone or a digital tablet. """),
            sizedh1,
            bullettedList("Personal Data",
                """ is any information that relates to an identified or identifiable individual. """),
            sizedh1,
            bullettedList("Service", """ refers to the Application. """),
            sizedh1,
            bullettedList("Service Provider",
                """ means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analysing how the Service is used. """),
            sizedh1,
            bullettedList("Usage Data",
                """ refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit). """),
            sizedh1,
            bullettedList("You",
                """ means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable. """),
            sizedh2,
            commonText(
                text: "Collecting and Using Your Personal Data", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            commonText(text: "Types of Data Collected", size: 17.5),
            sizedh2,
            commonText(text: "Personal Data", size: 16.5),
            sizedh1,
            privacyText(
                content:
                    "While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:"),
            sizedh1,
            bullettedList("", "Email Address"),
            sizedh1,
            bullettedList("", "Usage Data"),
            sizedh1,
            commonText(text: "Usage Data", size: 16.5),
            sizedh1,
            privacyText(
                content:
                    "Usage Data is collected automatically when using the Service."),
            sizedh1,
            privacyText(
                content:
                    "Usage Data may include information such as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data."),
            sizedh1,
            privacyText(
                content:
                    "When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data."),
            sizedh1,
            privacyText(
                content:
                    "We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device."),
            sizedh1,
            commonText(text: "Use of Your Personal Data", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(
                content:
                    "The Company may use Personal Data for the following purposes:"),
            sizedh1,
            bullettedList("""  To provide and maintain our Service""", """ including to monitor the usage of our Service. """),
            sizedh1,
            bullettedList(""" To manage Your Account: """, """ to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user. """),
            sizedh1,
            bullettedList(""" For the performance of a contract: """, """ the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service. """),
            sizedh1,
            bullettedList(""" To contact You: """, """ To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation. """),
            sizedh1,
            bullettedList(""" To provide You """, """ with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information. """),
            sizedh1,
            bullettedList(""" To manage Your requests: """, """ To attend and manage Your requests to Us. """),
            sizedh1,
            bullettedList(""" For business transfers: """, """ We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganisation, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred. """),
            sizedh1,
            bullettedList(""" For other purposes: """, """ We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience. """),
            sizedh1,
            privacyText(content: "We may share Your personal information in the following situations:"),
            sizedh1,
            bullettedList(""" With Service Providers: """, """ We may share Your personal information with Service Providers to monitor and analyse the use of our Service, to contact You. """),
            sizedh1,
            bullettedList(""" For business transfers: """, """ We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our business to another company. """),
            sizedh1,
            bullettedList(""" With Affiliates:  """, """ We may share Your information with Our affiliates, in which case we will require those affiliates to honour this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us. """),
            sizedh1,
            bullettedList(""" With business partners: """, """ We may share Your information with Our business partners to offer You certain products, services or promotions. """),
            sizedh1,
            bullettedList(""" With other users: """, """ when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside. """),
            sizedh1,
            bullettedList(""" With Your consent: """, """ We may disclose Your personal information for any other purpose with Your consent. """),
            sizedh2,
            commonText(
                text: "Retention of Your Personal Data", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(content: "The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies."),
            sizedh1,
            privacyText(content: "The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods."),
            sizedh2,
            commonText(
                text: "Transfer of Your Personal Data", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(content: "Your information, including Personal Data, is processed at the Company's operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction."),
            sizedh1,
            privacyText(content: "Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer."),
            sizedh1,
            privacyText(content: "The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organisation or a country unless there are adequate controls in place including the security of Your data and other personal information."),
            sizedh2,
            commonText(
                text: "Disclosure of Your Personal Data", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            commonText(text: "Business Transactions", size: 17),
            sizedh1,
            privacyText(content: "If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy."),
            sizedh1,
            commonText(text: "Law enforcement", size: 17),
            sizedh1,
            privacyText(content: "Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency)."),
            sizedh1,
            commonText(text: "Other legal requirements", size: 17),
            sizedh1,
            privacyText(content: "The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:"),
            sizedh1,

            bullettedList("""""", """ Comply with a legal obligation """),
            sizedh1,sizedh1,

            bullettedList("""""", """ Protect and defend the rights or property of the Company """),
            sizedh1,

            bullettedList("""""", """ Prevent or investigate possible wrongdoing in connection with the Service """),
            sizedh1,

            bullettedList("""""", """ Protect the personal safety of Users of the Service or the public"""),
            sizedh1,

            bullettedList("""""", """ Protect against legal liability """),
            sizedh2,
            commonText(
                text: "Security of Your Personal Data", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(content: "The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security."),
            sizedh2,
            commonText(
                text: "Children's Privacy", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(content: "Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers."),
            sizedh1,
            privacyText(content: "If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent's consent before We collect and use that information."),
            sizedh2,
            commonText(
                text: "Links to Other Websites", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(content: "Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party's site. We strongly advise You to review the Privacy Policy of every site You visit."),
            sizedh1,
            privacyText(content: "We have no control over and assume no responsibility for the content, privacy policies or practises of any third party sites or services."),
            sizedh2,
            commonText(
                text: "Changes to this Privacy Policy", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(content: "We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page."),
            sizedh1,
            privacyText(content: """ We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy. """),
            sizedh1,
            privacyText(content: "You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page."),
            sizedh2,
            commonText(
                text: "Contact Us", size: 19),
            Divider(
              color: HexColor("#A6B9FF"),
            ),
            sizedh1,
            privacyText(content: "If you have any questions about this Privacy Policy, You can contact us:"),
            sizedh1,
            bullettedList("", "By email: aslamnputhanpurayil@gmail.com",),
            sizedh1,
            sizedh1,
            sizedh1,
          ],
        ),
      ),
    );
  }

  privacyText({content, color, size, weight}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        content,
        style: TextStyle(
            fontWeight: weight ?? FontWeight.w400,
            fontSize: size ?? 16,
            color: color),
      ),
    );
  }

  bullettedList(head, text) {
    return Row(
      children: [
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("• ",
                    style: TextStyle(fontSize: 22, color: Colors.black)),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: head ?? '',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                      children: <TextSpan>[
                        TextSpan(
                          text: "\t$text",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
