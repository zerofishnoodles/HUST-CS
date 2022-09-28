//
// Created by Ray on 2021/10/17.
//

#ifndef TCPEXP_SRRDTRECEIVER_H
#define TCPEXP_SRRDTRECEIVER_H
#include "RdtReceiver.h"
#include "Global.h"


class SRRdtReceiver : public RdtReceiver {
private:
    struct receiveWin{
        Packet packet;
        bool hasPacket;
    }receiveWin[WINDOW_SIZE]; //增加hasPacket,方便发连续报文
    int base;

public:
    SRRdtReceiver();
    virtual ~SRRdtReceiver();

public:

    void receive(const Packet &packet) ;	//接收报文，将被NetworkService调用

};


#endif //TCPEXP_SRRDTRECEIVER_H
