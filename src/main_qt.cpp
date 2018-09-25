#include "gui/qt.hpp"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("worker", new CalibratorWorker(argc, argv, &engine));
    engine.load(QUrl("qrc:/qml/main.qml"));

    return app.exec();
}
