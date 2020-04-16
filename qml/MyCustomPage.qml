import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
  anchors.fill: parent;

  header: PageHeader {
            id   : header;
            title: i18n.tr('Emergency Chat');
          }

  Label {
    anchors.centerIn: parent;
    text            : i18n.tr('Hello World!');
  }
}
