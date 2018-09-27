#ifndef CALIBRATOR_WORKER_H
#define CALIBRATOR_WORKER_H

#include <QObject>
#include <QScopedPointer>

class Calibrator;
class CalibratorWorker : public QObject
{
    Q_OBJECT
public:
    CalibratorWorker(int argc, char **argv, QObject *parent = nullptr);
    ~CalibratorWorker();

    Q_INVOKABLE void init();

    Q_INVOKABLE void onClicked(int x, int y, int displayWidth, int displayHeight);

signals:
    void stateChanged(int state);
    void initialized(int newWidth, int newHeight, int numBlocks);

private:
    QScopedPointer<Calibrator> m_calibrator;
};

#endif
