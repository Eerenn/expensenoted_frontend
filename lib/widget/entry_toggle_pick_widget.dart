import 'package:expensenoted/modal/category_modal.dart';
import 'package:expensenoted/modal/entry_modal.dart';
import 'package:flutter/material.dart';

class EntryTogglePick extends StatefulWidget {
  const EntryTogglePick({
    Key? key,
    required this.entry,
    required this.deviceSize,
    required this.entryAction,
  }) : super(key: key);

  final Size deviceSize;
  final Entry entry;
  final EntryAction entryAction;

  @override
  State<EntryTogglePick> createState() => _EntryTogglePickState();
}

class _EntryTogglePickState extends State<EntryTogglePick> {
  bool _expandToggle = true;
  List<EntryCategory> _categories = List.empty(growable: true);

  Future<List<EntryCategory>> _getAllCategories() async {
    if (_categories.isEmpty) {
      if (widget.entryAction == EntryAction.editExisting) {
        _categories =
            await EntryCategory.getUserCategories(widget.entry.categories);
        widget.entry.setCategories(_categories);
        return _categories;
      } else {
        return _categories = await EntryCategory.getAllCategories();
      }
    } else {
      return _categories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            widget.entryAction == EntryAction.editExisting ||
                    widget.entryAction == EntryAction.createNew ||
                    widget.entry.categories.length > 3
                ? Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _expandToggle = !_expandToggle;
                        });
                      },
                      child: Text(
                        _expandToggle ? 'Close' : 'Expand',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _expandToggle ? 150 : 60,
          child: widget.entryAction == EntryAction.viewDetail
              ? GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection:
                      _expandToggle ? Axis.vertical : Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _expandToggle ? 3 : 1,
                    childAspectRatio: _expandToggle
                        ? widget.deviceSize.width /
                            (widget.deviceSize.height / 3)
                        : widget.deviceSize.width / widget.deviceSize.height,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Flex(
                      direction: Axis.vertical,
                      children: [
                        Image(
                          image: AssetImage(
                            'assets/categories${widget.entry.categories[index].path}',
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.entry.categories[index].name,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: widget.entry.categories.length,
                )
              : FutureBuilder<List<EntryCategory>>(
                  future: _getAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        scrollDirection:
                            _expandToggle ? Axis.vertical : Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _expandToggle ? 3 : 1,
                          childAspectRatio: _expandToggle
                              ? widget.deviceSize.width /
                                  (widget.deviceSize.height / 3)
                              : widget.deviceSize.width /
                                  widget.deviceSize.height,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (() {
                              setState(() {
                                _categories[index].selected =
                                    !_categories[index].selected;
                                widget.entry.setCategories(_categories);
                              });
                            }),
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  constraints:
                                      const BoxConstraints.expand(height: 30.0),
                                  child: Image(
                                    image: AssetImage(
                                      'assets/categories${_categories[index].path}',
                                    ),
                                    color: _categories[index].selected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                    height: 30,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _categories[index].name,
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: _categories.length,
                      );
                    } else if (snapshot.hasError) {
                      return const Text("Error");
                    }
                    return Container();
                  },
                ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Text(
            'Expense experience',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: (() {
                setState(() {
                  if (widget.entryAction != EntryAction.viewDetail) {
                    widget.entry.worthiness = Worthiness.worth;
                  }
                });
              }),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 80,
                    ),
                    child: Image(
                      image: const AssetImage('assets/categories/star.png'),
                      color: widget.entry.worthiness.index == 0
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                      height: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Worth',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  if (widget.entryAction != EntryAction.viewDetail) {
                    widget.entry.worthiness = Worthiness.average;
                  }
                });
              }),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 80,
                    ),
                    child: Image(
                      image: const AssetImage('assets/categories/star.png'),
                      color: widget.entry.worthiness.index == 1
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                      height: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Average',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  if (widget.entryAction != EntryAction.viewDetail) {
                    widget.entry.worthiness = Worthiness.notWorth;
                  }
                });
              }),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 80,
                    ),
                    child: Image(
                      image: const AssetImage('assets/categories/star.png'),
                      color: widget.entry.worthiness.index == 2
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                      height: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Not Worth',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (() {
                setState(() {
                  if (widget.entryAction != EntryAction.viewDetail) {
                    widget.entry.worthiness = Worthiness.necessity;
                  }
                });
              }),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 80,
                    ),
                    child: Image(
                      image: const AssetImage('assets/categories/star.png'),
                      color: widget.entry.worthiness.index == 3
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                      height: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Necessity',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: widget.deviceSize.height / 10),
      ],
    );
  }
}
