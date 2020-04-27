import QtQuick                   2.7;
import Ubuntu.Components         1.3;
import Ubuntu.Components.Popups  1.3;
import "databaseFunctions.js" as DatabaseFunctions;

Page {
  id          : splashes_page;
  header      : PageHeader {
                  id   : splashes_header;
                  title: i18n.tr('Edit');

                  trailingActionBar {
                    actions: [Action {
                                iconName   : "add";
                                text       : "Add Splash";
                                onTriggered: PopupUtils.open(blurb_add);
                              }]
                  }
                }
  visible     : false;
  anchors.fill: parent;

  ListModel {
    id: list_model;
  }

  UbuntuListView {
    id      : list_view;
    model   : list_model;
    delegate: ListItem {
                id            : blurb_item;
                height        : layout.height                          +
                                (divider.visible ? divider.height : 0);
                onClicked     : PopupUtils.open(blurb_edit);
                leadingActions: ListItemActions {
                                  actions: [Action {
                                              iconName   : "delete";
                                              onTriggered: {
                                                DatabaseFunctions.deleteSplash(identifier);

                                                layout.destroy();
                                              }
                                            }]
                                }

                property int identifier: splashID;

                ListItemLayout {
                  id          : layout;
                  title.text  : splashTitle;
                  summary.text: splashBlurb;

                  CheckBox {
                    id                  : list_check;
                    checked             : splashIs_current == 1;
                    onClicked           : {
                      if(list_check.checked) {
                        var actualCurrentIndex        = -1,
                            currentlySelectedSplashID = DatabaseFunctions.getCurrentSplashID();

                        for(var i = 0; i < list_model.count; i++) {
                          if(list_model.get(i).splashID === currentlySelectedSplashID) {
                            list_view.currentIndex = i;
                            list_view.currentItem
                                     .children[1]
                                     .children[0]
                                     .children[0]
                                     .checked      = false;
                          } else if(list_model.get(i).splashID === blurb_item.identifier) {
                            actualCurrentIndex = i;
                          }
                        }

                        DatabaseFunctions.updateSplashValue(DatabaseFunctions.getCurrentSplashID(),
                                                            "is_current",
                                                            0);
                        DatabaseFunctions.updateSplashValue(blurb_item.identifier,
                                                            "is_current",
                                                            1);

                        list_view.currentIndex = actualCurrentIndex;

                        splash_header.title = i18n.tr(layout.title.text);
                        splash_text.text    = layout.summary.text;
                      }
                    }
                    SlotsLayout.position: SlotsLayout.Leading;
                  }

                  Icon {
                    name                : "message";
                    width               : units.gu(2);
                    SlotsLayout.position: SlotsLayout.Trailing;
                  }
                }

                Component {
                  id: blurb_edit;

                  Dialog {
                    id   : blurb_popup;
                    title: "Edit";

                    TextField {
                      id            : splash_title;
                      text          : layout.title.text;
                      errorHighlight: false;
                    }

                    TextArea {
                      id    : splash_blurb;
                      text  : layout.summary.text;
                      height: units.gu(20);
                    }

                    Row {
                      spacing: units.gu(2);

                      Button {
                        text     : i18n.tr("Cancel");
                        width    : parent.width / 2 - units.gu(1);
                        onClicked: PopupUtils.close(blurb_popup);
                      }

                      Button {
                        text     : i18n.tr("Save");
                        color    : UbuntuColors.green;
                        width    : parent.width / 2 - units.gu(1);
                        onClicked: {
                          DatabaseFunctions.updateSplashValue(identifier,
                                                              "title",
                                                              splash_title.text);
                          DatabaseFunctions.updateSplashValue(identifier,
                                                              "blurb",
                                                              splash_blurb.text);

                          layout.title.text   = splash_title.text;
                          layout.summary.text = splash_blurb.text;
                          splash_header.title = i18n.tr(splash_title.text);
                          splash_text.text    = splash_blurb.text;

                          PopupUtils.close(blurb_popup);
                        }
                      }
                    }
                  }
                }
              }

    anchors {
      top   : splashes_header.bottom;
      left  : parent.left;
      right : parent.right;
      bottom: parent.bottom;
    }
  }

  Component {
    id: blurb_add;

    Dialog {
      id   : blurb_add_popup;
      title: "Add";

      TextField {
        id            : splash_add_title;
        errorHighlight: false;
      }

      TextArea {
        id    : splash_add_blurb;
        height: units.gu(20);
      }

      Row {
        spacing: units.gu(2);

        Button {
          text     : i18n.tr("Cancel");
          width    : parent.width / 2 - units.gu(1);
          onClicked: PopupUtils.close(blurb_add_popup);
        }

        Button {
          text     : i18n.tr("Save");
          color    : UbuntuColors.green;
          width    : parent.width / 2 - units.gu(1);
          onClicked: {
            DatabaseFunctions.insertSplash(splash_add_title.text,
                                           splash_add_blurb.text);

            var splashes    = DatabaseFunctions.getSplashes(),
                most_recent = splashes[splashes.length - 1];

            list_model.append({ "splashID"        : most_recent.id,
                                "splashTitle"     : most_recent.title,
                                "splashBlurb"     : most_recent.blurb,
                                "splashIs_current": most_recent.is_current });

            PopupUtils.close(blurb_add_popup);
          }
        }
      }
    }
  }

  Component.onCompleted: {
    var splashes = DatabaseFunctions.getSplashes();

    for(var i = 0; i < splashes.length; i++) {
      list_model.append({ "splashID"        : splashes[i].id,
                          "splashTitle"     : splashes[i].title,
                          "splashBlurb"     : splashes[i].blurb,
                          "splashIs_current": splashes[i].is_current });
    }
  }
}
