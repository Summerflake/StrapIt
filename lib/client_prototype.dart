import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'background.dart';
import 'home_page.dart'; // 引入以复用 Footer 组件

class ClientPrototypePage extends StatelessWidget {
  const ClientPrototypePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;
    
    // 设置手机模型的基础高度
    double phoneHeight = isMobile ? 400 : 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: GlobalBackground()),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const NavBar(isHome: false),
                  const SizedBox(height: 60),
                  
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: isMobile ? 20 : 40),
                    child: Column(
                      children: [
                        const Text(
                          "CLIENT PROTOTYPE", 
                          style: TextStyle(color: Colors.blueAccent, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 4)
                        ),
                        const SizedBox(height: 80),
                        
                        SizedBox(
                          height: isMobile ? 550 : 700, // 设定一个固定的画幅高度来容纳重叠的手机
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // 左侧手机模型 (倾斜30度，展示静态设计图)
                              Transform.translate(
                                offset: Offset(isMobile ? -40 : -140, 0),
                                child: Transform.rotate(
                                  angle: -30 * math.pi / 180,
                                  child: PhoneMockup(imagePath: 'assets/image/slanted.png', height: phoneHeight),
                                ),
                              ),
                              // 右侧手机模型 (覆盖在上方，嵌入原生交互式的 App Demo)
                              Transform.translate(
                                offset: Offset(isMobile ? 40 : 100, 0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    PhoneMockup(
                                      height: phoneHeight,
                                      child: const InteractiveAppDemo(), // 可交互的组件
                                    ),
                                    // 新增的交互提示词，置于手机正下方
                                    Positioned(
                                      bottom: isMobile ? -50 : -60,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.touch_app, color: Colors.blueAccent, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              "Click to interact", 
                                              style: TextStyle(
                                                color: Colors.blueAccent, 
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // 复用底部的 Download & Footer 组件
                  const FooterCombinedSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 手机外壳模型组件 (支持传入图片 或 真实的交互式 Widget)
// ============================================================================
class PhoneMockup extends StatelessWidget {
  final String? imagePath;
  final Widget? child;
  final double height;

  const PhoneMockup({super.key, this.imagePath, this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    // 采用类似现代智能手机的标准长宽比 (约为 19.5:9)
    double width = height * 0.47; 
    
    Widget screenContent;
    if (child != null) {
      // 如果传入了真实的 Widget，为了适配不同大小的手机模型，我们将其固定在一个标准的逻辑分辨率下，然后缩放填充。
      screenContent = FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 375, // 标准 iPhone 逻辑宽度
          height: 375 / 0.47, 
          child: child!,
        ),
      );
    } else if (imagePath != null) {
      screenContent = Image.asset(
        imagePath!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    } else {
      screenContent = const SizedBox();
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black, // 物理边框底色
        borderRadius: BorderRadius.circular(height * 0.08), // 手机外边角圆润度
        border: Border.all(color: const Color(0xFF333333), width: height * 0.012), // 模拟边框的反光/材质
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: const Offset(15, 20), // 让手机有悬浮在页面上的立体感
          ),
        ],
      ),
      child: Stack(
        children: [
          // 屏幕显示区域
          ClipRRect(
            borderRadius: BorderRadius.circular(height * 0.065), // 屏幕内显示区的倒角
            child: screenContent,
          ),
          // 模拟顶部刘海 / 灵动岛 (Notch / Dynamic Island) 增加代入感
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: height * 0.02),
              width: width * 0.35,
              height: height * 0.035,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(height * 0.02),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 原生复刻的 index.html (完全可交互的 Flutter 智能家居控制面板)
// ============================================================================
class DeviceData {
  String id;
  String name;
  String type;
  bool secured;
  DateTime? lastUnlockedAt;
  DateTime? unlockedSince;

  DeviceData({
    required this.id,
    required this.name,
    required this.type,
    required this.secured,
    this.lastUnlockedAt,
    this.unlockedSince,
  });
}

class InteractiveAppDemo extends StatefulWidget {
  const InteractiveAppDemo({super.key});

  @override
  State<InteractiveAppDemo> createState() => _InteractiveAppDemoState();
}

class _InteractiveAppDemoState extends State<InteractiveAppDemo> {
  final String username = "Camille";
  late List<DeviceData> devices;
  Timer? _timer;

  // 颜色配置 (精准还原 HTML 中的 CSS 变量)
  final Color cBg = const Color(0xFFF2F2F2);
  final Color cPanel = const Color(0xFFFFFFFF);
  final Color cText = const Color(0xFF151515);
  final Color cMuted = const Color(0xFF6D6D6D);
  final Color cLine = const Color(0x14000000); // rgba(0,0,0,.08)
  final Color cAccent = const Color(0xFF3B82F6);
  
  final Color cChipSecureBg = const Color(0x1A16A34A);
  final Color cChipSecureInk = const Color(0xFF0F6B34);
  final Color cChipOpenBg = const Color(0x1E3B82F6);
  final Color cChipOpenInk = const Color(0xFF1D4ED8);

  @override
  void initState() {
    super.initState();
    // 初始化设备数据
    final now = DateTime.now();
    devices = [
      DeviceData(id: "main-door", name: "Main Door", type: "door", secured: true, lastUnlockedAt: now.subtract(const Duration(minutes: 42))),
      // 修复：补全了 side-door 的 lastUnlockedAt
      DeviceData(id: "side-door", name: "Side Door", type: "door", secured: false, lastUnlockedAt: now.subtract(const Duration(minutes: 3)), unlockedSince: now.subtract(const Duration(minutes: 3))),
      DeviceData(id: "basement-window", name: "Basement Window", type: "window", secured: true, lastUnlockedAt: now.subtract(const Duration(minutes: 120))),
      DeviceData(id: "garage-entry", name: "Garage Entry", type: "door", secured: true, lastUnlockedAt: now.subtract(const Duration(minutes: 16))),
    ];

    // 启动定时器，每秒刷新一次以便更新 "Unlocked for Xm Xs"
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void toggle(String id) {
    setState(() {
      var d = devices.firstWhere((e) => e.id == id);
      if (d.secured) {
        d.secured = false;
        d.unlockedSince = DateTime.now();
        d.lastUnlockedAt = DateTime.now();
      } else {
        d.secured = true;
        d.unlockedSince = null;
      }
    });
  }

  void secureAll() {
    setState(() {
      for (var d in devices) {
        if (!d.secured) {
          d.secured = true;
          d.unlockedSince = null;
        }
      }
    });
  }

  String formatTime(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String h = dt.hour.toString().padLeft(2, '0');
    String m = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, $h:$m';
  }

  String formatDuration(Duration d) {
    int m = d.inMinutes;
    int s = d.inSeconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Material( // 使用 Material 避免文字样式继承出错
      color: cBg,
      child: Stack(
        children: [
          Column(
            children: [
              // --- 1. Topbar ---
              Container(
                color: const Color(0xFFDCDCDC),
                padding: const EdgeInsets.only(top: 55, bottom: 15, left: 20, right: 20), // Top 55 适配刘海
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // 使用你请求的 logo.png 替换了原来的 Icon
                        Image.asset('assets/image/logo.png', height: 24, fit: BoxFit.contain),
                        const SizedBox(width: 8),
                        Text("STRAPIT", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: cText, letterSpacing: 1.2)),
                      ],
                    ),
                    Text("SECURE ANYDOOR", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: cText, letterSpacing: 1.5)),
                  ],
                ),
              ),
              
              // --- 2. Main Scrollable Content ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text("$username’s home", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: cText)),
                      const SizedBox(height: 5),
                      Text("${devices.length} locks connected", style: TextStyle(fontSize: 15, color: cMuted)),
                      const SizedBox(height: 20),
                      
                      // Panel
                      Container(
                        decoration: BoxDecoration(
                          color: cPanel,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: cLine),
                        ),
                        child: Column(
                          children: [
                            // Panel Header
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Access points", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: cText)),
                                      Text("Doors & windows", style: TextStyle(fontSize: 14, color: cMuted)),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () => setState((){}), // Refresh effect
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: cLine),
                                      ),
                                      child: const Icon(Icons.refresh, size: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            
                            // Device List
                            ...devices.asMap().entries.map((entry) => _buildDeviceRow(entry.value, entry.key == 0)).toList(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          // --- 3. Sticky Lockdown Button ---
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [cBg.withOpacity(0), cBg.withOpacity(0.92), cBg],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
              child: ElevatedButton(
                onPressed: secureAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.security, size: 18),
                    SizedBox(width: 8),
                    Text("Lockdown", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- Device Row Builder ---
  Widget _buildDeviceRow(DeviceData d, bool isFirst) {
    // 修复：添加判断，防止时间为 null 时强制解包引发崩溃
    String subTitleText = "";
    if (d.secured) {
      subTitleText = d.lastUnlockedAt != null 
          ? "Last unlocked ${formatTime(d.lastUnlockedAt!)}" 
          : "Secured safely";
    } else {
      subTitleText = d.unlockedSince != null 
          ? "Unlocked for ${formatDuration(DateTime.now().difference(d.unlockedSince!))}" 
          : "Currently unlocked";
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: isFirst ? null : Border(top: BorderSide(color: cLine)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cLine),
            ),
            child: Icon(
              d.type == 'door' ? (d.secured ? Icons.door_front_door : Icons.sensor_door) : Icons.window,
              color: cText,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          
          // Details & Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: cText)),
                          const SizedBox(height: 2),
                          Text(
                            subTitleText,
                            style: TextStyle(color: cMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Status Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: d.secured ? cChipSecureBg : cChipOpenBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: d.secured ? const Color(0x3816A34A) : const Color(0x403B82F6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(d.secured ? Icons.lock : Icons.lock_open, size: 12, color: d.secured ? cChipSecureInk : cChipOpenInk),
                          const SizedBox(width: 4),
                          Text(
                            d.secured ? "Secured" : "Unlocked", 
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: d.secured ? cChipSecureInk : cChipOpenInk)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Toggle Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => toggle(d.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(d.secured ? "Unlock" : "Secure", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}