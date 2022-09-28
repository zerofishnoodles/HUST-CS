#pragma once
#include "winsock2.h"
#include <WS2tcpip.h>
#include <stdio.h>
#include <iostream>
#include "config.h"
#include "global.h"
#include "httpParser.h"

#pragma comment(lib,"ws2_32.lib")

using namespace std;

void main()
{
	WSADATA wsaData;
	FD_SET rfds;
	FD_SET wfds;

	int nRc = WSAStartup(0x0202, &wsaData);
	if (nRc) {
		printf("Winsock  startup failed with error!\n");
	}
	if (wsaData.wVersion != 0x0202) {
		printf("Winsock version is not correct!\n");
	}
	printf("Winsock startup Ok!\n");

	//create socket
	SOCKET srvSocket,cliSocket;
	SOCKADDR_IN addr, clientAddr;
	SOCKET sessionSocket;
	int clAddrLen;
	srvSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (srvSocket != INVALID_SOCKET) {
		printf("server socket create ok!\n");
	}


	//set port and ip
	const char ConfigFile[] = "config.txt";
	Config configSettings(ConfigFile);

	port = configSettings.Read("port", 0);
	ipAddress = configSettings.Read<string>("ipAddress");
	Home = configSettings.Read<string>("Home");
	cout << "port:" << port << endl;
	cout << "ipAddress:" << ipAddress << endl;
	cout << "Home:" << Home << endl;

	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	inet_pton(AF_INET, ipAddress.c_str(), &addr.sin_addr.S_un.S_addr);
	//addr.sin_addr.S_un.S_addr = INADDR_ANY;

	clientAddr.sin_family = AF_INET;
	clAddrLen = sizeof(clientAddr);


	//binding
	int rtn = bind(srvSocket, (LPSOCKADDR)&addr, sizeof(addr));
	if (rtn != SOCKET_ERROR) {
		printf("binding OK!\n");
	}

	//listen
	rtn = listen(srvSocket, 5);
	if (rtn != SOCKET_ERROR) {
		printf("listening!\n");
	}

	/*将srvSock设为非阻塞模式以监听客户连接请求*/
	u_long blockMode = 1;
	if ((rtn = ioctlsocket(srvSocket, FIONBIO, &blockMode) == SOCKET_ERROR)) { //FIONBIO：允许或禁止套接口s的非阻塞模式。
		cout << "ioctlsocket() failed with error!\n";
		return;
	}
	cout << "ioctlsocket() for server socket ok!	Waiting for client connection and data\n";

	/*清空read,write描述符，对rfds和wfds进行了初始化，必须用FD_ZERO先清空，下面才能FD_SET,
	fd_等命令时搭配select使用的，用于非阻塞模式*/
	//设置等待客户连接请求
	bool firstConnect = true;
	//FD_SET(srvSocket, &rfds);
	char recvBuf[4096] = { 0 };

	int debug = 0;
	while (1) {
		
		//clear the fds (init)
		FD_ZERO(&rfds);
		FD_ZERO(&wfds);
		

		if (!firstConnect) {
			FD_SET(sessionSocket, &rfds);
			FD_SET(sessionSocket, &wfds);
		}
		else {
			FD_SET(srvSocket, &rfds);
		}

		//判断各个描述符中有没有阻塞
		int nTotal = select(0, &rfds, &wfds, NULL, NULL);
		//cout << debug << "  " << nTotal << endl;
		//debug++;


		if (FD_ISSET(srvSocket, &rfds)) {
			//第一次连接服务器，创建session socket，后面在sessionsocket中操作
			nTotal--;

			sessionSocket = accept(srvSocket, (LPSOCKADDR)&clientAddr, &clAddrLen);
			if (sessionSocket == INVALID_SOCKET) {
				cout << "session Socket created failed" << endl;
				cout << "WSA ERROR:" << WSAGetLastError() << endl;
				return;
			}

			/*把session socket设置成非阻塞模式*/
			if (rtn = ioctlsocket(sessionSocket, FIONBIO, &blockMode) == SOCKET_ERROR) {
				cout << "ioctlsocket() failed with error!\n";
				return;
			}
			cout << "ioctlsocket() for session socket ok!	Waiting for client connection and data\n";

			FD_SET(sessionSocket, &rfds);
			FD_SET(sessionSocket, &wfds);
			firstConnect = false;
		}

		//第一次之后和sessionSocket连接nTotal记录sessionSocket（此时默认没有其他来连server）
		if (FD_ISSET(sessionSocket, &rfds) && nTotal>0) {
			rtn = recv(sessionSocket, recvBuf, 4096, 0);
			char cliIP[20] = { 0 };
			inet_ntop(AF_INET, &clientAddr.sin_addr, cliIP, 16);
			if (rtn > 0) {
				printf("Received %d bytes from client(ip:%s:%d): \n%s\n", rtn, cliIP, clientAddr.sin_port, recvBuf);
				httpParser par(recvBuf);
				string response = par.httpResponse();
				if (FD_ISSET(sessionSocket, &wfds)) {
					rtn = send(sessionSocket, response.c_str(), response.size(), 0);
				}
				else {
					cout << "sessionSocket can't write!" << endl;
				}
				if (rtn == SOCKET_ERROR) {
					printf("send failed!");
				}
				else {
					printf("send %d bytes\n", rtn);
					par.printInfo();
				}
			}
			else {
				printf("Client leaving ...\n");
				closesocket(sessionSocket);  //既然client离开了，就关闭sessionSocket
				firstConnect = true;
			}
		}
	}
}



	

	

