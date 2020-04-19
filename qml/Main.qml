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

import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

MainView {
  id                  : root;
  objectName          : 'mainView';
  applicationName     : 'emergencychat.jaft';
  automaticOrientation: true;

  width : units.gu(45);
  height: units.gu(75);

  PageStack {
    id            : pageStack;
    anchors.fill  : parent;
    anchors.bottom: parent.bottom;

    Component.onCompleted: push(page0);

    Page {
      id            : page0;
      header        : PageHeader {
                        id   : header;
                        title: i18n.tr("Autistic Meltdown");

                        trailingActionBar {
                          actions: [Action {
                                      iconName   : "settings";
                                      text       : "Settings";
                                      onTriggered: pageStack.push(Qt.resolvedUrl("MyCustomPage.qml"));
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
            text                    : "I gave you my phone because I can't use or process speech right now but I am still capable of text communication.\n\nMy hearing and tactile senses are extremely sensitive in this state so please refrain from touching me. Please keep calm and proceed to the next screen that has a simple chat client through which we can communicate.";
            width                   : parent.width * .9;
            wrapMode                : Label.WordWrap;
            textSize                : Label.Large;
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
            onClicked               : pageStack.push(page1);
          }
        }
      }
    }

    Page {
      id            : page1;
      title         : "Rectangle";
      visible       : false;
      anchors.fill  : parent;
      anchors.bottom: parent.bottom;

      Column {
        anchors.fill  : parent;
        anchors.bottom: parent.bottom;

        ScrollView {
          id    : rectangle;
          width : root.width;

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


        }
      }
    }
  }
}
