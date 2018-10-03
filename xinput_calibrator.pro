TEMPLATE = app
TARGET = xinput_calibrator
INCLUDEPATH += . src
DEFINES += VERSION='\\"0.18.10.3\\"'
QT += qml

CONFIG += c++14
LIBS += -lX11 -lXi
QMAKE_CXXFLAGS_WARN_ON += -Wno-ignored-qualifiers -Wno-unused-parameter

HEADERS += src/calibrator.hh \
           src/calibrator/Evdev.hpp \
           src/calibrator/Usbtouchscreen.hpp \
           src/calibrator/XorgPrint.hpp \
           src/gui/qt.hpp \
           src/gui/gui_common.hpp

SOURCES += src/calibrator.cpp \
           src/main_common.cpp \
           src/main_qt.cpp \
           src/calibrator/Evdev.cpp \
           src/calibrator/Usbtouchscreen.cpp \
           src/calibrator/XorgPrint.cpp \
           src/gui/qt.cpp \
           src/gui/gui_common.cpp

RESOURCES += \
    src/gui/qml/xinput_qml.qrc \
    src/gui/images/xinput_images.qrc
