/*
 * Copyright (C) 2020  Wamm K. D.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick                   2.7;
import QtQuick.LocalStorage      2.0;
import Ubuntu.Components         1.3;
//import QtQuick.Controls         2.2;
import QtQuick.Layouts           1.3;
import Qt.labs.settings          1.0;
import "databaseFunctions.js" as DatabaseFunctions;

MainView {
  id                    : root;
  objectName            : 'mainView';
  applicationName       : 'emergencychat.jaft';
  automaticOrientation  : true;

  width                 : units.gu(45);
  height                : units.gu(75);

  property var  db      : DatabaseFunctions.openDB();

  PageStack {
    id            : pageStack;
    anchors.fill  : parent;
    anchors.bottom: parent.bottom;

    Component.onCompleted: push(splash_page);

    Page {
      id            : splash_page;
      header        : PageHeader {
                        id   : splash_header;
                        title: i18n.tr(DatabaseFunctions.getCurrentSplashTitle());

                        trailingActionBar {
                          actions: [Action {
                                      iconName   : "settings";
                                      text       : "Settings";
                                      onTriggered: pageStack.push(settings_page);
                                    }]
                        }
                      }
      visible       : false;
      anchors.fill  : parent;
      anchors.bottom: parent.bottom;

      Column {
        anchors.fill  : parent;
        anchors.bottom: parent.bottom;

        Row {
          id            : lab;
          width         : root.width;
          anchors.fill  : parent;
          anchors.bottom: butt.top;

          Label {
            id                      : splash_text;
            text                    : DatabaseFunctions.getCurrentSplashBlurb();
            width                   : parent.width * .9;
            wrapMode                : Label.WordWrap;
            textSize                : DatabaseFunctions.getSettingsValue("splash");
            anchors.centerIn        : parent;
            anchors.horizontalCenter: parent.horizontalCenter;
          }
        }

        Row {
          id            : butt;
          width         : root.width;
          height        : units.gu(10);
          anchors.bottom: parent.bottom;

          Button {
            text                    : "Chat";
            width                   : parent.width * .8;
            anchors.centerIn        : parent;
            anchors.horizontalCenter: parent.horizontalCenter;
            onClicked               : pageStack.push(chat_page);
          }
        }
      }
    }

    Page {
      id          : splashes_page;
      header      : PageHeader {
                      id   : splashes_header;
                      title: i18n.tr('Blurbs');
                    }
      visible     : false;
      anchors.fill: parent;

      Column {
        spacing: units.gu(2);

        anchors {
          top    : splashes_header.bottom;
          left   : parent.left;
          right  : parent.right;
          bottom : parent.bottom;
          margins: units.gu(2);
        }
      }
    }

    Page {
      id          : settings_page;
      visible     : false;
      anchors.fill: parent;

      header: PageHeader {
                id   : settings_header;
                title: i18n.tr('Settings');
              }

      Column {
        spacing: units.gu(2);

        anchors {
          top    : settings_header.bottom;
          left   : parent.left;
          right  : parent.right;
          bottom : parent.bottom;
          margins: units.gu(2);
        }

        Column {
          width  : parent.width;
          spacing: units.gu(1);

          Label {
            text     : i18n.tr('Splash Screen Text Size');
            font.bold: true;
          }

          OptionSelector {
            id                    : splash_font_size;
            width                 : parent.width;
            model                 : ["Extra, Extra Small", "Extra Small",
                                     "Small",              "Medium",      "Large"];
            selectedIndex         : DatabaseFunctions.getSettingsValue("splash");
            onSelectedIndexChanged: {
              splash_text.textSize = splash_font_size.selectedIndex;

              DatabaseFunctions.updateSettingsValue("splash",
                                                    splash_font_size.selectedIndex);
            }
          }
        }

        Column {
          spacing: units.gu(1);

          Label {
            text     : i18n.tr('Auto-Switch User');
            font.bold: true;
          }

          Row {
            CheckBox {
              id       : auto_switch;
              checked  : DatabaseFunctions.getSettingsValue("switch");
              onClicked: DatabaseFunctions.updateSettingsValue("switch",
                                                               auto_switch.checked ? 1 : 0);
            }

            Label {
              text: i18n.tr("    Switches the user after each message");
            }
          }
        }
      }
    }

    Page {
      id            : chat_page;
      header        : PageHeader {
                        id   : chat_header;
                        title: i18n.tr("Chat");
                      }
      visible       : false;
      anchors.fill  : parent;
      anchors.bottom: parent.bottom;

      Column {
        anchors.fill  : parent;
        anchors.bottom: parent.bottom;

        ScrollView {
          id    : rectangle;
          width : root.width;
          height: root.height - units.gu(6)                             -
                                swiRow.height - units.gu(1)             -
                                tool.height                             -
                                Qt.inputMethod.keyboardRectangle.height;

          anchors {
            bottom   : swiRow.top;
            topMargin: units.gu(6);
          }

          Column {
            id     : col;
            width  : rectangle.width;
            padding: units.gu(1);
            spacing: units.gu(1);
          }
        }

        Row {
          id            : swiRow;
          width         : root.width;
          height        : swi.height + units.gu(2);
          anchors.bottom: tool.top;

          Switch {
            id                      : swi;
            checked                 : false;
            anchors.centerIn        : parent;
            anchors.horizontalCenter: parent.horizontalCenter;
          }
        }

        Toolbar {
          id    : tool;
          height: bu.height;

          anchors {
            left        : parent.left;
            right       : parent.right;
            bottom      : parent.bottom;
            leftMargin  : units.gu(1);
            bottomMargin: Qt.inputMethod.keyboardRectangle.height + units.gu(1);
          }

          TextArea {
            id   : bu;
            width: parent.width - units.gu(5);
          }

          trailingActionBar.actions: [Action {
                                        iconName   : "send";
                                        onTriggered: {
                                          rectangle.forceActiveFocus();

                                          if(bu.text !== "") {
                                            Qt.createQmlObject('import QtQuick 2.7;'           +
                                                               'import Ubuntu.Components 1.3;' +

                                                               'Row {'                                             +
                                                               '  width          : rectangle.width - units.gu(2);' +
                                                               '  layoutDirection: ' + (swi.checked      ?
                                                                                        'Qt.RightToLeft' :
                                                                                        'Qt.LeftToRight') + ';'    +

                                                               '  Rectangle {'                                       +
                                                               '    id           : rec;'                             +
                                                               '    color        : ' + (swi.checked           ?
                                                                                        'UbuntuColors.blue'   :
                                                                                        'UbuntuColors.purple') + ';' +
                                                               '    width        : labe.width  + units.gu(2);'       +
                                                               '    height       : labe.height + units.gu(2);'       +
                                                               '    radius       : 10;'                              +

                                                               '    Label {'                                                         +
                                                               '      id                      : labe;'                               +
                                                               '      text                    : "' + bu.text.replace(/"/g,
                                                                                                                     "\\\"") + '";'  +
                                                               '      width                   : root.width * 0.333333;'              +
                                                               '      color                   : ' + (swi.checked              ?
                                                                                                     'UbuntuColors.jet'       :
                                                                                                     'UbuntuColors.porcelain') + ';' +
                                                               '      wrapMode                : Label.WordWrap;'                     +
                                                               '      anchors.centerIn        : parent;'                             +
                                                               '      anchors.horizontalCenter: parent.horizontalCenter;'            +
                                                               '    }'                                                               +
                                                               '  }'                                                                 +
                                                               '}',
                                                               col,
                                                               "dynamicSnippet1");

                                            if(auto_switch.checked) {
                                              swi.checked                    = !swi.checked;
                                            }
                                            bu.text                          = "";
                                            rectangle.flickableItem.contentY = rectangle.flickableItem.contentHeight;
                                          }
                                        }
                                      }]
        }
      }
    }
  }
}
