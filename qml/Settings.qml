import QtQuick                   2.7;
import Ubuntu.Components         1.3;
import "databaseFunctions.js" as DatabaseFunctions;

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
        model                 : [i18n.tr("Extra, Extra Small"),
                                 i18n.tr("Extra Small"),
                                 i18n.tr("Small"),
                                 i18n.tr("Medium"),
                                 i18n.tr("Large")];
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

    Column {
      width  : parent.width;
      spacing: units.gu(1);

      Label {
        text     : i18n.tr('Theme');
        font.bold: true;
      }

      OptionSelector {
        id                    : app_theme;
        width                 : parent.width;
        model                 : [i18n.tr("System Theme"),
                                 i18n.tr("Ambiance"),
                                 i18n.tr("Suru Dark")];
        selectedIndex         : DatabaseFunctions.getSettingsValue("theme");
        onSelectedIndexChanged: {
          DatabaseFunctions.updateSettingsValue("theme",
                                                app_theme.selectedIndex);

          setTheme();
        }
      }
    }
  }
}
