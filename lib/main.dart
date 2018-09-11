import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

final ThemeData androidTheme = new ThemeData(
primarySwatch: Colors.deepOrange,
accentColor : Colors.green
);
const String user = "Rupa ";
const String my_name ="RupaRavulakollu";
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
 @override
  Widget build(BuildContext context)
  {
      
      return new MaterialApp(
        title: "My First Application",
        theme:androidTheme ,
        home: new ChatApp(),
      );
  }
  
}

class ChatApp extends StatefulWidget {
  @override
  State createState() => new ChatWindow();
}

class ChatWindow extends State<ChatApp> with TickerProviderStateMixin {
   final List<Message> _messages = <Message>[];
   final TextEditingController textedit = new TextEditingController();
   bool isWriting = false;
   @override
   Widget build(BuildContext context)
   {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Chat Application"),
          elevation: Theme.of(context).platform == TargetPlatform.android ? 0.6 : 0.0
        ),
        body: new Column(children: <Widget>[
          new Flexible(
            child: new ListView.builder(
            itemBuilder: (_,int pos) => _messages[pos] ,
            itemCount: _messages.length, 
            reverse:  true,
            padding: new EdgeInsets.all(0.6),
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            child: _buildComposer(),
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          ),
        ]),
      );  
   }

  Widget  _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 9.0 ),
        child:  new Row(
          children: <Widget>[
            new Flexible(
                child: new TextField(
                  controller: textedit ,
                  onChanged: (String text){
                      setState(() {
                      isWriting = text.length > 0;                        
                      });
                  },
                  onSubmitted: _submitMsg ,
                  decoration:
                    new InputDecoration.collapsed(hintText: "Enter the message to send"),
                ),
            ),
            new Container(
              margin:new EdgeInsets.symmetric(horizontal:3.0) ,
              child: new IconButton(
                icon: new Icon(Icons.message),
                onPressed: isWriting ? ()=>_submitMsg(textedit.text) : null 
              ) 
            ),
          ],
        ),
      ),
    );
  }


  void _submitMsg(String value) {
    textedit.clear();
    setState(() {
          isWriting =false;
    });

    Message message = new Message(
      text: value,
      animationController: new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 500)
      ),
    );
    setState(() {
        _messages.insert(0, message);      
    });
    message.animationController.forward();
  }

  @override
  void dispose(){
    for(Message mesg in _messages)
    {
      mesg.animationController.dispose();
    }
    super.dispose();
  }
}

class Message extends StatelessWidget{
  Message({this.text,this.animationController});
  final String text ;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent : animationController,
        curve : Curves.bounceOut
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin : EdgeInsets.symmetric(vertical:8.0),
        child:new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right:10.0) ,
              child: new CircleAvatar(child:new Text(user)),
            ),
            new Expanded(
                child:  new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(user,style:Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top:6.0) ,
                      
                      child: new Text(text),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

}
