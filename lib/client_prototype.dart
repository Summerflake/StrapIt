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
    double phoneHeight = isMobile ? 350 : 500;

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
                              // 左侧手机模型 (倾斜30度，位于底层/偏左，垂直居中)
                              Transform.translate(
                                offset: Offset(isMobile ? -40 : -120, 0), // 将 Y 轴偏移量设为 0
                                child: Transform.rotate(
                                  angle: -30 * math.pi / 180,
                                  child: PhoneMockup(imagePath: 'assets/image/slanted.png', height: phoneHeight),
                                ),
                              ),
                              // 右侧手机模型 (正向网站展示，覆盖在上方/偏右，垂直居中)
                              Transform.translate(
                                offset: Offset(isMobile ? 40 : 80, 0), // 将 Y 轴偏移量设为 0，与左侧保持一致
                                child: PhoneMockup(imagePath: 'assets/image/client.png', height: phoneHeight),
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
// 新增：极具质感的手机外壳模型组件
// ============================================================================
class PhoneMockup extends StatelessWidget {
  final String imagePath;
  final double height;

  const PhoneMockup({super.key, required this.imagePath, required this.height});

  @override
  Widget build(BuildContext context) {
    // 采用类似现代智能手机的标准长宽比 (约为 19.5:9)
    double width = height * 0.47; 
    
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
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
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