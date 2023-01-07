import 'package:expensenoted/modal/entry_modal.dart';
import 'package:expensenoted/screen/modify_entry_screen.dart';
import 'package:expensenoted/screen/single_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expensenoted/providers/entry_provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class EntriesList extends StatefulWidget {
  const EntriesList({
    Key? key,
    required this.entries,
    required this.deviceSize,
  }) : super(key: key);

  final Entries entries;
  final Size deviceSize;

  @override
  State<EntriesList> createState() => _EntriesListState();
}

class _EntriesListState extends State<EntriesList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.2),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInSine,
  ));
  bool _isLoading = true;
  int _monthRange = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _asyncMethod(false));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _asyncMethod(bool force) async {
    widget.entries.getPartialEntries.isEmpty
        ? await widget.entries.getUserPartialEntries(_monthRange)
        : force
            ? await widget.entries.getUserPartialEntries(_monthRange)
            : null;

    if (widget.entries.getPartialEntries.length < 6 && _monthRange < 13) {
      _monthRange += 3;
      await widget.entries.getUserPartialEntries(_monthRange);
      _asyncMethod(true);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Padding(
            padding:
                EdgeInsets.symmetric(vertical: widget.deviceSize.height / 4),
            child: const CircularProgressIndicator(),
          )
        : widget.entries.getPartialEntries.isNotEmpty
            ? Expanded(
                flex: 1,
                child: RefreshIndicator(
                  onRefresh: (() => _asyncMethod(true)),
                  child: StickyGroupedListView(
                    elements: widget.entries.getPartialEntries,
                    order: StickyGroupedListOrder.DESC,
                    stickyHeaderBackgroundColor:
                        Theme.of(context).colorScheme.onBackground,
                    groupBy: (Entry entry) => DateTime(
                        entry.date.year, entry.date.month, entry.date.day),
                    groupSeparatorBuilder: (Entry entry) => SizedBox(
                      height: 70,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              entry.date.day == DateTime.now().day &&
                                      entry.date.month == DateTime.now().month
                                  ? '${DateFormat('MMMM dd, yyyy').format(entry.date)} (Today)'
                                  : DateFormat('MMMM dd, yyyy')
                                      .format(entry.date),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    indexedItemBuilder: (_, Entry entry, index) {
                      return SlideTransition(
                        position: _offsetAnimation,
                        child: FadeTransition(
                          opacity: _controller,
                          child: Hero(
                            tag: 'entry$index',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 15.0,
                              ),
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => SingleEntryScreen(
                                          index: index,
                                          entry: entry,
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => ModifyEntryScreen(
                                          index: index,
                                          entry: entry,
                                          action: EntryAction.editExisting,
                                          cb: (bool force) async {
                                            await _asyncMethod(force);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: widget.deviceSize.height / 8,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width:
                                                widget.deviceSize.width * 0.5,
                                            child: Text(
                                              entry.text,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: (widget.deviceSize
                                                                .height /
                                                            8) /
                                                        4),
                                                child: const Text(
                                                  'total spent:',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 4.0,
                                                  right: 8.0,
                                                  top: (widget.deviceSize
                                                              .height /
                                                          8) /
                                                      5,
                                                  bottom: (widget.deviceSize
                                                              .height /
                                                          8) /
                                                      4,
                                                ),
                                                child: Text(
                                                  Entry.getEntryTotal(entry)
                                                      .toStringAsFixed(2),
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _asyncMethod(true),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('assets/custom/vector1.png'),
                          height: 250,
                        ),
                        SizedBox(
                          width: 250,
                          child: Text(
                            'Seems like no entry added yet, swipe right to add one!',
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
