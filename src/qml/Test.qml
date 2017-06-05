import QtQuick 2.7
  import QtQuick.Controls 2.1

  ApplicationWindow {
      id: window
      width: 200
      height: 228
      visible: true

      Drawer {
          id: drawer
          width: 0.66 * window.width
          height: window.height
          Text {
              text: "text"
          }
      }

      Label {
          id: content

          text: "Aa"
          font.pixelSize: 96
          anchors.fill: parent
          verticalAlignment: Label.AlignVCenter
          horizontalAlignment: Label.AlignHCenter

          transform: Translate {
              x: drawer.position * content.width * 0.33
          }
          MouseArea {
              anchors.fill: parent
              onClicked: {
                  drawer.open()
              }
          }
      }
  }
