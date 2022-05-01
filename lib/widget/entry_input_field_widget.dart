import 'package:expensenoted/modal/entry_modal.dart';
import 'package:expensenoted/secure_storage.dart';
import 'package:flutter/material.dart';

class EntryInputField extends StatefulWidget {
  const EntryInputField({
    Key? key,
    required this.index,
    required this.deviceSize,
    required this.entry,
    required this.entryAction,
  }) : super(key: key);

  final int index;
  final Size deviceSize;
  final Entry entry;
  final EntryAction entryAction;

  @override
  State<EntryInputField> createState() => _EntryInputFieldState();
}

class _EntryInputFieldState extends State<EntryInputField> {
  final List<String> _type = ['bank', 'tng', 'cash', 'other'];
  bool _toggleTextArea = false;
  String _selectedValue = '';
  List<String> _builder = ['bank', '', ''];
  String _buildString = '';

  Future<bool> _asyncMethod() async {
    final _str = await SecureStorage.readPreferenceMethod();
    _toggleTextArea = _str.toString().toLowerCase() == 'true';
    return _str.toString().toLowerCase() == 'true';
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _asyncMethod(),
      builder: (context, snapshot) {
        return Column(
          children: [
            Hero(
              tag: 'entry${widget.index}',
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: widget.deviceSize.height * 0.03,
                    horizontal: 15.0),
                child: Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: widget.deviceSize.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 15.0,
                      ),
                      child: _toggleTextArea ||
                              widget.entryAction == EntryAction.editExisting
                          ? TextFormField(
                              onChanged: (value) {
                                widget.entry.text = value;
                              },
                              decoration: const InputDecoration(
                                  hintText: '[Type] [Description] [Amount]'),
                              initialValue: widget.entry.text,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 3,
                            )
                          : Row(
                              children: [
                                DropdownButton(
                                  items: _type.map(
                                    (val) {
                                      return DropdownMenuItem(
                                        child: Text(val),
                                        value: val,
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedValue = val.toString();
                                      _builder[0] = val.toString();
                                      _buildString = _builder.join(' ');
                                      widget.entry.text = _buildString;
                                    });
                                  },
                                  value: _selectedValue == ''
                                      ? _type.first
                                      : _selectedValue,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: SizedBox(
                                    width: deviceSize.width * 0.5,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        setState(() {
                                          if (_builder[0] == '') {
                                            _builder[0] == _type[0];
                                          }
                                          _builder[1] = val.toString();
                                          _buildString = _builder.join(' ');
                                          widget.entry.text = _buildString;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Description',
                                      ),
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: deviceSize.width * 0.1,
                                  child: TextField(
                                    onChanged: (val) {
                                      setState(() {
                                        _builder[2] = val.toString();
                                        _buildString = _builder.join(' ');
                                        widget.entry.text = _buildString;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: '0.0',
                                    ),
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Example: "cash purchase 10.90"',
                    style: TextStyle(fontSize: 11),
                  ),
                  widget.entryAction != EntryAction.editExisting
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _toggleTextArea = !_toggleTextArea;
                              SecureStorage.writePreferenceMethod(
                                  _toggleTextArea);
                            });
                          },
                          icon: const Icon(
                            Icons.swap_horiz_sharp,
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
