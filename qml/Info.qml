import QtQuick           2.7;
import Ubuntu.Components 1.3;

Page {
  id          : info_page;
  header      : PageHeader {
                  id   : info_header;
                  title: i18n.tr('App. Info.');
                }
  visible     : false;
  anchors.fill: parent;

  Flickable {
    id           : info_flickable;
    clip         : true;
    contentHeight: info_col.height + units.gu(2);

    anchors {
      top   : info_header.bottom;
      left  : parent.left;
      right : parent.right;
      bottom: parent.bottom;
    }

    Column {
      id: info_col;

      anchors {
        top  : parent.top;
        left : parent.left;
        right: parent.right;
      }

      Item {
        id    : icon;
        width : parent.width;
        height: app_icon.height + units.gu(1);

        UbuntuShape {
          id              : app_icon;
          width           : Math.min(info_page.width / 3, 256);
          height          : width;
          source          : Image {
                              id    : icon_image;
                              source: "../assets/icon.png";
                            }
          aspect          : UbuntuShape.Flat;
          anchors.centerIn: parent;
        }
      }

      Label {
        id                      : name;
        text                    : "Emergency Chat  v1.0";
        textSize                : Label.XLarge;
        horizontalAlignment     : Text.AlignHCenter;
        anchors.horizontalCenter: parent.horizontalCenter;
      }

      Label {
        id                      : inspiration_text;
        text                    : i18n.tr("Inspired from the app. by Seph De Busser.");
        width                   : parent.width - units.gu(4);
        wrapMode                : Text.WordWrap;
        anchors.topMargin       : units.gu(10);
        horizontalAlignment     : Text.AlignHCenter;
        anchors.horizontalCenter: parent.horizontalCenter;
      }

      ListItem {
        onClicked: Qt.openUrlExternally('https://github.com/WammKD/Emergency-Chat');

        ListItemLayout {
          title.text: i18n.tr("Source Code");

          ProgressionSlot {
          }
        }
      }

      ListItem {
        onClicked: Qt.openUrlExternally('https://opensource.org/licenses/GPL-3.0');

        ListItemLayout {
          title.text: i18n.tr("License");

          Label {
            text: i18n.tr("GNU General Public License v3");
          }

          ProgressionSlot {
          }
        }
      }

      ListItem {
        onClicked: Qt.openUrlExternally('mailto:jaft.r@outlook.com');

        ListItemLayout {
          title.text: i18n.tr("Author");

          Label {
            text: "Wamm K. D.";
          }

          ProgressionSlot {
          }
        }
      }
    }
  }
}
