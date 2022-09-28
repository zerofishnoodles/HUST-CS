// TCPExp.cpp : �������̨Ӧ�ó������ڵ㡣
//


#include "Global.h"
#include "RdtSender.h"
#include "RdtReceiver.h"
#include "StopWaitRdtSender.h"
#include "StopWaitRdtReceiver.h"
#include "GBNRdtSender.h"
#include "GBNRdtReceiver.h"
#include "SRRdtReceiver.h"
#include "SRRdtSender.h"
#include "TCPRdtReceiver.h"
#include "TCPRdtSender.h"


int main(int argc, char* argv[])
{
//	RdtSender *ps = new StopWaitRdtSender();
//	RdtReceiver * pr = new StopWaitRdtReceiver();
//    RdtSender *ps = new GBNRdtSender();
//    RdtReceiver * pr = new GBNRdtReceiver();
//    RdtSender *ps = new SRRdtSender();
//    RdtReceiver * pr = new SRRdtReceiver();
    RdtSender *ps = new TCPRdtSender();
    RdtReceiver * pr = new TCPRdtReceiver();
	pns->setRunMode(0);  //VERBOSģʽ
//	pns->setRunMode(1);  //����ģʽ
	pns->init();
	pns->setRtdSender(ps);
	pns->setRtdReceiver(pr);
	pns->setInputFile(R"(D:\Documents\course\junior\ComputerNetwork\RdtProg\input.txt)");
	pns->setOutputFile(R"(D:\Documents\course\junior\ComputerNetwork\RdtProg\output.txt)");

	pns->start();

	delete ps;
	delete pr;
	delete pUtils;									//ָ��Ψһ�Ĺ�����ʵ����ֻ��main��������ǰdelete
	delete pns;										//ָ��Ψһ��ģ�����绷����ʵ����ֻ��main��������ǰdelete
	
	return 0;
}

