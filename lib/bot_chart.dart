//@dart=2.9
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/atus-kart.json").build();
    Dialogflow dialogflow = Dialogflow(language: Language.english, authGoogle: authGoogle);

    AIResponse aiResponse = await dialogflow.detectIntent(query).then((value) {
      setState(() {
        messsages.insert(0, {"data": 0, "message": value.getListMessage()[0]["text"]["text"][0].toString()});
      });
    }).catchError((onError) {
      print(onError.toString());
    });

    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  void initState() {
    // TODO: implement initState
    response('hi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xff6fb840),
          title: ListTile(
            title: const Text(
              'Chat Bot',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            contentPadding: const EdgeInsets.all(0),
            subtitle: Row(
              children: [
                const CircleAvatar(
                  radius: 4,
                  backgroundColor: Colors.lightGreen,
                ),
                Text(
                  ' active',
                  style: TextStyle(color: Colors.grey.shade300),
                )
              ],
            ),
          )),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: messsages.length,
                  itemBuilder: (context, index) => chat(messsages[index]["message"].toString(), messsages[index]["data"])),
            )),
            Container(
              decoration: const BoxDecoration(boxShadow: [const BoxShadow(blurRadius: 1, color: Colors.grey)], color: Colors.white),
              height: MediaQuery.of(context).size.height * 0.08,
              child: ListTile(
                title: Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                  ),
                  padding: const EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: messageInsert,
                    decoration: const InputDecoration(
                      hintText: "Enter a Message...",
                      hintStyle: TextStyle(color: Colors.black26),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    onChanged: (value) {},
                  ),
                ),
                trailing: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      if (messageInsert.text.isEmpty) {
                        print("empty message");
                      } else {
                        setState(() {
                          messsages.insert(0, {"data": 1, "message": messageInsert.text});
                        });
                        response(messageInsert.text);
                        messageInsert.clear();
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 8),
      child: Row(
        mainAxisAlignment: data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.support_agent_outlined),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Bubble(
                radius: const Radius.circular(8.0),
                color: data == 0 ? Colors.grey.shade300 : Colors.blue,
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                          child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(color: data == 0 ? Colors.black : Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
