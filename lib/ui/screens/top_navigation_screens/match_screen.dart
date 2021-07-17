import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_flutter/data/db/entity/app_user.dart';
import 'package:tinder_app_flutter/data/db/entity/chat.dart';
import 'package:tinder_app_flutter/data/db/entity/match.dart';
import 'package:tinder_app_flutter/data/db/entity/swipe.dart';
import 'package:tinder_app_flutter/data/db/remote/firebase_database_source.dart';
import 'package:tinder_app_flutter/data/provider/user_provider.dart';
import 'package:tinder_app_flutter/ui/screens/matched_screen.dart';
import 'package:tinder_app_flutter/ui/widgets/custom_modal_progress_hud.dart';
import 'package:tinder_app_flutter/ui/widgets/rounded_icon_button.dart';
import 'package:tinder_app_flutter/util/constants.dart';
import 'package:tinder_app_flutter/util/utils.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool showInfo = false;
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _ignoreSwipeIds;

  Future<AppUser> loadPerson(String myUserId) async {
    if (_ignoreSwipeIds == null) {
      _ignoreSwipeIds = List<String>();
      var swipes = await _databaseSource.getSwipes(myUserId);
      for (var i = 0; i < swipes.size; i++) {
        Swipe swipe = Swipe.fromSnapshot(swipes.docs[i]);
        _ignoreSwipeIds.add(swipe.id);
      }
      _ignoreSwipeIds.add(myUserId);
    }
    var res = await _databaseSource.getPersonsToMatchWith(1, _ignoreSwipeIds);
    if (res.docs.length > 0) {
      var userToMatchWith = AppUser.fromSnapshot(res.docs.first);
      return userToMatchWith;
    } else {
      return null;
    }
  }

  void personSwiped(AppUser myUser, AppUser otherUser, bool isLiked) async {
    _databaseSource.addSwipedUser(myUser.id, Swipe(otherUser.id, isLiked));
    _ignoreSwipeIds.add(otherUser.id);

    if (isLiked == true) {
      if (await isMatch(myUser, otherUser) == true) {
        _databaseSource.addMatch(myUser.id, Match(otherUser.id));
        _databaseSource.addMatch(otherUser.id, Match(myUser.id));
        String chatId = compareAndCombineIds(myUser.id, otherUser.id);
        _databaseSource.addChat(Chat(chatId, null));

        Navigator.pushNamed(context, MatchedScreen.id, arguments: {
          "my_user_id": myUser.id,
          "other_user_id": otherUser.id
        });
      }
    }
    setState(() {});
  }

  Future<bool> isMatch(AppUser myUser, AppUser otherUser) async {
    DocumentSnapshot swipeSnapshot =
        await _databaseSource.getSwipe(otherUser.id, myUser.id);
    if (swipeSnapshot.exists) {
      Swipe swipe = Swipe.fromSnapshot(swipeSnapshot);

      if (swipe.liked == true) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: ListView(
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return FutureBuilder<AppUser>(
                  future: userProvider.user,
                  builder: (context, userSnapshot) {
                    return CustomModalProgressHUD(
                      inAsyncCall:
                          userProvider.user == null || userProvider.isLoading,
                      child: (userSnapshot.hasData)
                          ? FutureBuilder<AppUser>(
                              future: loadPerson(userSnapshot.data.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    !snapshot.hasData) {
                                  return Center(
                                    child: Container(
                                        child: Text('No users',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4)),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return CustomModalProgressHUD(
                                    inAsyncCall: true,
                                    child: Container(),
                                  );
                                }
                                return Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8,
                                                        top: 8,
                                                        bottom: 8),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            snapshot.data.name,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          Text(
                                                            "Seat - " +
                                                                snapshot
                                                                    .data.age
                                                                    .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                          Text(
                                                            "Tap to Connect  ",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )
                                                        ]),
                                                  )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8,
                                                        top: 8,
                                                        bottom: 8),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "   " +
                                                                snapshot
                                                                    .data.bio,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              RoundedIconButton(
                                                                onPressed: () {
                                                                  personSwiped(
                                                                      userSnapshot
                                                                          .data,
                                                                      snapshot
                                                                          .data,
                                                                      false);
                                                                },
                                                                iconData:
                                                                    Icons.clear,
                                                                buttonColor:
                                                                    kColorPrimaryVariant,
                                                                iconSize: 20,
                                                              ),
                                                              SizedBox(
                                                                  width: 20),
                                                              RoundedIconButton(
                                                                onPressed: () {
                                                                  personSwiped(
                                                                      userSnapshot
                                                                          .data,
                                                                      snapshot
                                                                          .data,
                                                                      true);
                                                                },
                                                                iconData:
                                                                    Icons.add,
                                                                iconSize: 20,
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                  )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Container(),
                    );
                  },
                );
              },
            )
          ],
        ));
  }
}
