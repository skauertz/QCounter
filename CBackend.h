#ifndef CBACKEND_H
#define CBACKEND_H

#include <QObject>
#include <QShortcut>

class CBackend : public QObject
{
    Q_OBJECT  // IMPORTANT - without it e.g. signals won't work

public:
    explicit CBackend(QObject *parent = nullptr);
    ~CBackend();

private:

};

#endif // CBACKEND_H
