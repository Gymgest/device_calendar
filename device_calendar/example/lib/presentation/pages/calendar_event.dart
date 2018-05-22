import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

import '../date_time_picker.dart';

class CalendarEventPage extends StatefulWidget {
  final Calendar _calendar;

  CalendarEventPage(this._calendar);

  @override
  _CalendarEventPageState createState() {
    return new _CalendarEventPageState(_calendar);
  }
}

class _CalendarEventPageState extends State<CalendarEventPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Calendar _calendar;

  Event _event;
  DeviceCalendarPlugin _deviceCalendarPlugin;

  DateTime _fromDate = new DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);

  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 28);

  bool _autovalidate = false;

  _CalendarEventPageState(this._calendar) {
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
    _event = new Event(start: _fromDate, end: _toDate);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Create new event'),
      ),
      body: new Column(
        children: <Widget>[
          new Form(
            autovalidate: _autovalidate,
            key: _formKey,
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                        flex: 1,
                        child: new Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: new TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Title',
                                hintText: 'Meeting with Gloria...'),
                            validator: _validateTitle,
                            onSaved: (String value) {
                              _event.title = value;
                            },
                          ),
                        )),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                        flex: 1,
                        child: new Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new DateTimePicker(
                                labelText: 'From',
                                selectedDate: _fromDate,
                                selectedTime: _fromTime,
                                selectDate: (DateTime date) {
                                  setState(() {
                                    _fromDate = date;
                                    _event.start = date;
                                  });
                                },
                                selectTime: (TimeOfDay time) {
                                  setState(() {
                                    _fromTime = time;
                                  });
                                })))
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                        flex: 1,
                        child: new Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new DateTimePicker(
                                labelText: 'To',
                                selectedDate: _toDate,
                                selectedTime: _toTime,
                                selectDate: (DateTime date) {
                                  setState(() {
                                    _fromDate = date;
                                    _event.end = date;
                                  });
                                },
                                selectTime: (TimeOfDay time) {
                                  setState(() {
                                    _fromTime = time;
                                  });
                                })))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          final FormState form = _formKey.currentState;
          if (!form.validate()) {
            _autovalidate = true; // Start validating on every change.
            showInSnackBar('Please fix the errors in red before submitting.');
          } else {
            form.save();
            var createEventResult =
                await _deviceCalendarPlugin.createEvent(_calendar, _event);
            if (createEventResult.isSuccess) {
              Navigator.pop(context, true);
            } else {
              showInSnackBar(createEventResult.errorMessages.join('|'));
            }
          }
        },
        child: new Icon(Icons.check),
      ),
    );
  }

  String _validateTitle(String value) {
    if (value.isEmpty) {
      return 'Name is required.';
    }

    return null;
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}