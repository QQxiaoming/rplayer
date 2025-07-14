import QtQuick

Item {
    property int particleCount: 60
    property real speedMultiplier: 1.0  // 运动速度倍数
    property real connectionDistance: 80  // 连线距离
    property bool showBorder: true       // 是否显示边框
    property real borderWidth: 2         // 边框宽度
    property var borderColor: "rgba(255, 255, 255, 1.0)"  // 边框颜色
    
    Canvas {
        id: particleCanvas2
        anchors.fill: parent
        
        property var particles: []
        property real time: 0
        
        Timer {
            interval: 16
            running: parent.visible
            repeat: true
            onTriggered: {
                parent.time += 0.016;
                parent.requestPaint();
            }
        }
        
        Component.onCompleted: {
            // 初始化粒子
            for (var i = 0; i < particleCount; i++) {
                particles.push({
                    x: Math.random() * width,
                    y: Math.random() * height,
                    vx: (Math.random() - 0.5) * 1.5 * speedMultiplier,
                    vy: (Math.random() - 0.5) * 1.5 * speedMultiplier,
                    size: Math.random() * 4 + 1,
                    alpha: Math.random() * 0.6 + 0.2,
                    phase: Math.random() * Math.PI * 2,
                    color: "rgba(255, 255, 255, "
                });
            }
        }
        
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            
            // 性能优化：预计算常用值
            var maxDistance = connectionDistance;
            var maxDistanceSquared = maxDistance * maxDistance;
            
            // 更新和绘制粒子
            for (var i = 0; i < particles.length; i++) {
                var p = particles[i];
                
                // 更新位置（应用速度倍数）
                p.x += p.vx * speedMultiplier;
                p.y += p.vy * speedMultiplier;
                
                // 边界处理 - 循环
                if (p.x < 0) p.x = width;
                if (p.x > width) p.x = 0;
                if (p.y < 0) p.y = height;
                if (p.y > height) p.y = 0;
                
                // 添加透明度波动效果，但保持大小固定
                var wave = Math.sin(time * 2.5 + p.phase) * 0.6 + 0.4;
                var currentAlpha = p.alpha * wave;
                
                // 绘制粒子（固定大小）
                ctx.fillStyle = p.color + currentAlpha + ")";
                ctx.beginPath();
                ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                ctx.fill();
            }
            
            // 绘制边框
            if (showBorder) {
                ctx.strokeStyle = borderColor;
                ctx.lineWidth = borderWidth;
                ctx.strokeRect(0, 0, width, height);
            }
        }
    }
}
