//
// Created by Ray on 2021/10/15.
//

#ifndef GBNRdtReceiver_H
#define GBNRdtReceiver_H

#include "RdtReceiver.h"
#include "Global.h"


class GBNRdtReceiver : public RdtReceiver{
private:
    int expectSequenceNumberRcvd;	// 期待收到的下一个报文序号
    Packet lastAckPkt;				//上次发送的确认报文

public:
    GBNRdtReceiver();
    virtual ~GBNRdtReceiver();

public:

    void receive(const Packet &packet) override;	//接收报文，将被NetworkService调用
};



#endif //GBNRdtReceiver_H
