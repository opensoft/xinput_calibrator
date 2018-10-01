#include "qt.hpp"

// Because another include order break build
// clang-format off
#include <QGuiApplication>

#include "calibrator.hh"

// clang-format on

//TODO: Make Qt version respective to timeout parameter
CalibratorWorker::CalibratorWorker(int argc, char **argv, QObject *parent) : QObject(parent)
{
    m_calibrator.reset(Calibrator::make_calibrator(argc, argv));
}

CalibratorWorker::~CalibratorWorker()
{}

void CalibratorWorker::init()
{
    const char *geo = m_calibrator->get_geometry();
    if (geo != nullptr) {
        int width, height;
        int res = sscanf(geo, "%dx%d", &width, &height);
        if (res != 2) {
            fprintf(stderr, "Warning: error parsing geometry string - using defaults.\n");
            geo = nullptr;
        } else {
            emit initialized(width, height, num_blocks);
            m_calibrator->reset();
        }
    }
    if (geo == nullptr) {
        emit initialized(0, 0, num_blocks);
        m_calibrator->reset();
    }
}

void CalibratorWorker::abort()
{
    qApp->exit(1);
}

void CalibratorWorker::onClicked(int x, int y, int displayWidth, int displayHeight)
{
    if (!m_calibrator->add_click(x, y) && m_calibrator->get_numclicks() <= 0) {
        emit stateChanged(0);
        return;
    }

    if (m_calibrator->get_numclicks() >= 4) {
        if (!m_calibrator->finish(displayWidth, displayHeight)) {
            fprintf(stderr, "Error: unable to apply or save configuration values");
            qApp->exit(2);
        }

        qApp->quit();
        return;
    }

    emit stateChanged(m_calibrator->get_numclicks());
}
