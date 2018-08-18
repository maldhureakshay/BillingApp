import 'package:flutter/material.dart';
import 'package:reciept_generator_app/database/dbhelper.dart';
import 'package:reciept_generator_app/model/Record.dart';
import 'package:reciept_generator_app/recordList.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home:  MyRecordList(),
    );
  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  DRecord record = new DRecord("", "", "", "","");
 
  String customerName; 
  String orderNo;
  String mobileNo;
  String totalAmount;
  String paidAmount;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add new Record"),
        ),
        body:  Form(
        key: _formKey,
        child: new ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
        
         TextFormField(
           decoration: InputDecoration(labelText: "Customer Name"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter customer name';
              }
            },
            onSaved: (value) {
             this.customerName = value; 
            },
            keyboardType: TextInputType.text,
          ),
           TextFormField(
             decoration: InputDecoration(labelText: "Order No"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter order no';
              }
            },
            onSaved: (value) {
             this.orderNo = value; 
            },
             keyboardType: TextInputType.number
          ),
           TextFormField(
             decoration: InputDecoration(labelText: "Mobile No"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter mobile no';
              }
              if (value.length!=10){
                return 'Please enter 10 digit mobile no';
              }
            },
            onSaved: (value) {
             this.mobileNo = value; 
            },
             keyboardType: TextInputType.number
          ),
          TextFormField(
             decoration: InputDecoration(labelText: "Total Amout"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter total amount';
              }
            },
            onSaved: (value) {
             this.totalAmount = value; 
            },
             keyboardType: TextInputType.number
          ),
          TextFormField(
             decoration: InputDecoration(labelText: "Paid Amout"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter paid amount';
              }
            },
            onSaved: (value) {
             this.paidAmount = value; 
            },
            keyboardType: TextInputType.number
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child : RaisedButton(
            onPressed: (){
              if (_formKey.currentState.validate()) {
                  // If the form is valid, we want to show a Snackbar
                  _submit();
                }
            },
            child: Text("Submit"),
          ))
        ],
      )
    )
    );
        

  }
    void _submit() {
     if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); 
     }else{
       return null;
     }
    var record = DRecord(customerName,orderNo,mobileNo,totalAmount,paidAmount);
    var dbHelper = DBHelper();
    dbHelper.saveRecord(record);
    _showSnackBar("Data saved successfully");
    navigateToRecordList();
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }  

   void navigateToRecordList(){
     Navigator.push(
    context,
    new MaterialPageRoute(builder: (context) => new MyRecordList()),
  );
  }
}

