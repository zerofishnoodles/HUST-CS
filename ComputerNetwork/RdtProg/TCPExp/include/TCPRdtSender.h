//
// Created by Ray on 2021/10/23.
//

#ifndef TCPEXP_TCPRDTSENDER_H
#define TCPEXP_TCPRDTSENDER_H
#include "RdtSender.h"
#include "Global.h"



class TCPRdtSender: public RdtSender{
private:
    int expectSequenceNumberSend;	// 下一个发送序号 需要循环
    bool waitingState;				// 是否处于等待Ack的状态
    Packet win[WINDOW_SIZE];     // 已发送并等待Ack的数据包窗口
    int base;
    int accumulate_num;

public:

    bool getWaitingState() override;
    bool send(const Message &message) override;						//发送应用层下来的Message，由NetworkServiceSimulator调用,如果发送方成功地将Message发送到网络层，返回true;如果因为发送方处于等待正确确认状态而拒绝发送Message，则返回false
    void receive(const Packet &ackPkt) override;						//接受确认Ack，将被NetworkServiceSimulator调用
    void timeoutHandler(int seqNum) override;					//Timeout handler，将被NetworkServiceSimulator调用

public:
    TCPRdtSender();
    virtual ~TCPRdtSender();

};


#endif //TCPEXP_TCPRDTSENDER_H
