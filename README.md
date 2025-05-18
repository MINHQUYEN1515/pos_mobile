//VIEW  
@override
  void initState() {
    FlutterForegroundTask.startService(notificationTitle:"",notificationText:"");
      init();
    _cubit = BlocProvider.of<HomeMobileCubit>(context);
    _user = _cubit.user;
    _device=_cubit.deviceLocal;
    _cubit.fetchData();
    super.initState();
  }
  void init()async{
     socket.initTcpSocket(onHandle:(value){
      _handleTcpSocket(value);
    });
    //MUTICAST SOCKET
   await socket.startListening(useSocket:true,useManagerKitchen:true,onHandle:(value){
      _handleMuticastAction(value);
    },);
  }

  @override
  void dispose() {
    socket.stopListening();
    _controller.dispose();
    super.dispose();
  }
  void _handleMuticastAction(Map<String,dynamic> data)async{
    logger.i(data['action']);
      switch(data['action']){
        case StringDBConstant.enterTableAction:
              TableActionRequest action=TableActionRequest.fromJson(data);
              _cubit.updateTable(tableName:action.data?.tableName??"",username: action.data?.username??'');
               if(mounted){
                setState((){});
                } 
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đây là SnackBar'),
                duration: Duration(seconds: 2),
              ),
            );

            break;
      }
  }
  void _handleTcpSocket(Map<String,dynamic> data)async{
     logger.i("ACTION TCP SOCKET:"+data['action']);
      switch(data['action']){
        case StringDBConstant.startOrderAction:
            break;
      }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // Đây là trạng thái cuối cùng trước khi app bị đóng hoàn toàn (có thể không luôn gọi được)
      print("App sắp bị huỷ!");
      socket.stopListening();
    } else if (state == AppLifecycleState.paused) {
      print("App vào nền");
    }
    super.didChangeAppLifecycleState(state);
  }


  <!-- SETUP MUTICAST -->


    <!-- ĐÂY LÀ NATIVE CODE  VIẾT BẰNG KOTLIN -->
                "acquireMulticastLock" -> {
                        val wifi = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                        multicastLock = wifi.createMulticastLock("flutter_multicast_lock")
                        multicastLock?.setReferenceCounted(true)
                        multicastLock?.acquire()
                        result.success(null)
                    }
    <!--  -->
    static Future<void> acquireMulticastLock() async {
    try {
      await platform.invokeMethod('startWifiLock');
      print("Bật thành công");

    } on PlatformException catch (e) {
      print("Lỗi bật multicast lock: ${e.message}");
    }
  }

   Future<void> startListening({
    required bool useSocket,
    required bool useManagerKitchen,
    Function(Map<String,dynamic> value)? onHandle
  }) async {
    if (useSocket || useManagerKitchen) {
      if (_validateInput(
          TcpConstant.SERVER_MULTICAST_IP, TcpConstant.SERVER_MULTICAST_PORT)) {
        await acquireMulticastLock(); // giả lập trên Android

        await _startMulticastListener(
          TcpConstant.SERVER_MULTICAST_IP,
          TcpConstant.SERVER_MULTICAST_PORT,
          onHandle:(value) {
            onHandle?.call(value);
          },
        );
          }
    }
  }
    Future<void> _startMulticastListener(String ip, int port,{Function(Map<String,dynamic> value)? onHandle}) async {
    try{
      _multicastSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4, port,
        reuseAddress: true,
        reusePort: true,
        );
    _multicastSocket!.joinMulticast(InternetAddress(ip));
    _multicastSocket!.multicastHops = 2;
    _multicastSocket!.broadcastEnabled = true;
    _multicastSocket!.writeEventsEnabled = true;
    
    _multicastSocket!.timeout(Duration(seconds: 3));
    _multicastSocket!.listen((RawSocketEvent event) {
      logger.i("SOCKET $event");
      if (event == RawSocketEvent.read) {
        final datagram = _multicastSocket!.receive();
        logger.i(datagram);
        if (datagram != null) {
          final message = String.fromCharCodes(datagram.data);
          onHandle?.call(jsonDecode(message));
          logger.i(
              "📥 Multicast received from ${datagram.address.address}:${datagram.port} ➜ $message");
        }
      }
    });

    logger.i('✅ Multicast listener started on $ip:$port');
      }
      catch(e){
        logger.e(e);
      }
   
  }