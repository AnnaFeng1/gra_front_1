<template>
  <canvas ref="canvas" class="vines-canvas"></canvas>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue';

const props = defineProps({
  // 是否暂停动画
  paused: {
    type: Boolean,
    default: false
  },
  // 线条颜色
  lineColor: {
    type: String,
    default: '#409EFF'
  },
  // 节点颜色
  nodeColor: {
    type: String,
    default: '#409EFF'
  },
  // 背景点的数量
  dotsCount: {
    type: Number,
    default: 60
  },
  // 背景线条连接距离
  connectionDistance: {
    type: Number,
    default: 150
  },
  // 鼠标影响半径
  mouseRadius: {
    type: Number,
    default: 200
  },
  // 点的移动速度
  dotSpeed: {
    type: Number,
    default: 0.5
  },
  // 点向鼠标靠近的强度
  attractionStrength: {
    type: Number,
    default: 0.02
  },
  // 新增：景深层次数量
  depthLayers: {
    type: Number,
    default: 3
  }
});

const canvas = ref(null);
let ctx = null;
let animationFrameId = null;
let dots = [];
let mousePosition = { x: null, y: null };
let prevMousePosition = { x: null, y: null };
let mouseSpeed = 0;
let isMouseInCanvas = false;
let isMouseInLoginForm = false;
let loginBoxRect = null;
let mouseClicked = false;
let clickTime = 0;

// 点类
class Dot {
  constructor() {
    // 新增：添加深度层次属性(1=最远, depthLayers=最近)
    this.layer = Math.ceil(Math.random() * props.depthLayers);
    // 根据层次决定点的基本属性
    const layerFactor = this.layer / props.depthLayers; // 0.33, 0.66, 1.0 for 3 layers
    
    this.x = Math.random() * window.innerWidth;
    this.y = Math.random() * window.innerHeight;
    
    // 远处点更小，近处点更大
    const baseSize = 0.8 + (Math.random() * 2.2);
    this.size = baseSize * (0.5 + layerFactor * 0.8);
    this.originalSize = this.size;
    
    // 远处点移动更慢，近处点移动更快
    const speedFactor = 0.3 + (layerFactor * 0.8);
    this.speedX = (Math.random() - 0.5) * props.dotSpeed * speedFactor;
    this.speedY = (Math.random() - 0.5) * props.dotSpeed * speedFactor;
    this.baseSpeedX = this.speedX;
    this.baseSpeedY = this.speedY;
    
    // 远处点更透明，近处点更不透明
    const baseOpacity = 0.3 + Math.random() * 0.4;
    this.opacity = baseOpacity * (0.5 + layerFactor * 0.6);
    
    // 根据层次调整颜色：远处更浅，近处更深
    const hue = 210; // 基本蓝色
    const saturation = 60 + layerFactor * 20; // 近处点饱和度更高
    const lightness = 80 - layerFactor * 25; // 近处点更深
    this.color = `hsla(${hue}, ${saturation}%, ${lightness}%, ${this.opacity})`;
    
    // 每个点有其自然状态位置
    this.naturalX = this.x;
    this.naturalY = this.y;
    // 添加一个变量来存储是否正在被鼠标吸引
    this.isAttracted = false;
    // 新增变量：是否已被束缚（一旦被吸引就保持吸引状态）
    this.isBound = false;
    // 添加震动效果的偏移量
    this.offsetX = 0;
    this.offsetY = 0;
    // 添加花瓣位置偏移
    this.petalOffset = null;
    // 点是否处于散射状态
    this.isScattering = false;
    // 散射速度
    this.scatterSpeedX = 0;
    this.scatterSpeedY = 0;
    // 散射持续时间
    this.scatterTime = 0;
    // 添加随机偏移
    this.randomOffset = null;
  }

  update() {
    // 处理散射状态
    if (this.isScattering) {
      // 计算散射已经持续的时间
      const scatterElapsed = Date.now() - this.scatterTime;
      
      // 散射效果持续1秒
      if (scatterElapsed < 1000) {
        // 应用散射速度，但随时间衰减
        const decayFactor = 1 - (scatterElapsed / 1000);
        this.x += this.scatterSpeedX * decayFactor;
        this.y += this.scatterSpeedY * decayFactor;
        
        // 在散射状态中，不应用正常的移动逻辑
        // 但仍然应用边界检查
      } else {
        // 散射结束
        this.isScattering = false;
        // 散射结束后，重置束缚状态
        this.isBound = false;
      }
    } else {
      // 正常移动逻辑
      this.x += this.speedX;
      this.y += this.speedY;
    }

    // 检测与登录框的碰撞
    if (loginBoxRect && !isMouseInLoginForm) {
      const nextX = this.x + (this.isScattering ? this.scatterSpeedX : this.speedX);
      const nextY = this.y + (this.isScattering ? this.scatterSpeedY : this.speedY);
      const dotRadius = this.size;
      
      // 扩大一点碰撞范围，让效果更明显
      const collisionMargin = 2;
      
      // 检查小球是否与登录框的边缘碰撞
      // 左边缘碰撞
      if (nextX + dotRadius + collisionMargin > loginBoxRect.left && 
          this.x + dotRadius <= loginBoxRect.left + collisionMargin && 
          nextY > loginBoxRect.top - dotRadius && 
          nextY < loginBoxRect.bottom + dotRadius) {
        if (this.isScattering) {
          this.scatterSpeedX = -Math.abs(this.scatterSpeedX) * 0.8;
        } else {
          this.speedX = -Math.abs(this.speedX) * 0.8;
        }
        this.x = loginBoxRect.left - dotRadius - collisionMargin;
      }
      // 右边缘碰撞
      else if (nextX - dotRadius - collisionMargin < loginBoxRect.right && 
               this.x - dotRadius >= loginBoxRect.right - collisionMargin && 
               nextY > loginBoxRect.top - dotRadius && 
               nextY < loginBoxRect.bottom + dotRadius) {
        if (this.isScattering) {
          this.scatterSpeedX = Math.abs(this.scatterSpeedX) * 0.8;
        } else {
          this.speedX = Math.abs(this.speedX) * 0.8;
        }
        this.x = loginBoxRect.right + dotRadius + collisionMargin;
      }
      // 上边缘碰撞
      else if (nextY + dotRadius + collisionMargin > loginBoxRect.top && 
               this.y + dotRadius <= loginBoxRect.top + collisionMargin && 
               nextX > loginBoxRect.left - dotRadius && 
               nextX < loginBoxRect.right + dotRadius) {
        if (this.isScattering) {
          this.scatterSpeedY = -Math.abs(this.scatterSpeedY) * 0.8;
        } else {
          this.speedY = -Math.abs(this.speedY) * 0.8;
        }
        this.y = loginBoxRect.top - dotRadius - collisionMargin;
      }
      // 下边缘碰撞
      else if (nextY - dotRadius - collisionMargin < loginBoxRect.bottom && 
               this.y - dotRadius >= loginBoxRect.bottom - collisionMargin && 
               nextX > loginBoxRect.left - dotRadius && 
               nextX < loginBoxRect.right + dotRadius) {
        if (this.isScattering) {
          this.scatterSpeedY = Math.abs(this.scatterSpeedY) * 0.8;
        } else {
          this.speedY = Math.abs(this.speedY) * 0.8;
        }
        this.y = loginBoxRect.bottom + dotRadius + collisionMargin;
      }
    }

    // 如果点击了鼠标，且点处于束缚状态，将其设置为散射状态
    if (mouseClicked && (this.isAttracted || this.isBound) && !this.isScattering) {
      this.startScattering();
      // 重置吸引状态
      this.isAttracted = false;
      this.isBound = false;
    }

    // 鼠标不在画布内或在登录框内时，重置束缚状态
    if (!isMouseInCanvas || isMouseInLoginForm) {
      this.isAttracted = false;
      this.isBound = false;
      this.size = Math.max(this.size * 0.95, this.originalSize);
      this.offsetX = 0;
      this.offsetY = 0;
      this.petalOffset = null; // 重置花瓣位置偏移
    }
    // 如果不是散射状态，并且鼠标在画布内，检查是否被吸引
    else if (!this.isScattering && mousePosition.x !== null) {
      const dx = mousePosition.x - this.x;
      const dy = mousePosition.y - this.y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      
      // 根据层次调整鼠标影响范围，近处层次响应更灵敏
      const layerFactor = this.layer / props.depthLayers;
      const effectiveMouseRadius = props.mouseRadius * (0.6 + layerFactor * 0.5);
      
      // 检查是否在鼠标影响范围内，或者已经处于束缚状态
      if (distance < effectiveMouseRadius || this.isBound) {
        // 点被鼠标吸引
        this.isAttracted = true;
        // 设为束缚状态，即使鼠标移开也保持吸引状态
        this.isBound = true;
        
        // 在鼠标周围生成蒲公英形状
        // 蒲公英主要形状是一个圆形，周围有飘散的小种子
        const r = effectiveMouseRadius * 0.7; // 基本圆形半径
        
        // 为每个点固定一个位置偏移，避免随机跳动
        if (!this.petalOffset) {
          // 种子基本角度 - 使用更均匀的分布
          const baseAngle = ((this.x * 10 + this.y * 10) % 100) / 100 * Math.PI * 2;
          
          // 生成距离变化 - 小点更可能被安排在外围形成飘散效果
          const distanceFactor = this.originalSize < 1.8 ? 
            0.85 + Math.random() * 0.55 : // 小点会被放在外围
            0.15 + Math.random() * 0.55;  // 大点更可能在靠近中心区域
            
          // 角度偏移 - 使点更均匀分布在圆周上
          const angleOffset = this.originalSize < 1.8 ? 
            Math.random() * 0.4 - 0.2 : // 小点有更大的角度偏移范围
            Math.random() * 0.2 - 0.1;  // 大点角度偏移较小
            
            // 添加随机相位偏移，使各点的周期性移动不同步
            const phaseOffset = Math.random() * Math.PI * 2;
            
            this.petalOffset = {
              angle: baseAngle + angleOffset,
              distance: distanceFactor,
              phase: phaseOffset,
              angleOffset: 0 // 新增：用于切向运动的角度偏移量
            };
        }
        
        // 计算在蒲公英形状上的目标位置
        // 小点距离中心较远，模拟蒲公英的飘散种子
        const time = Date.now() / 1000;
        
        // 基础目标半径
        let targetRadius = r * this.petalOffset.distance;
        
        // 为所有点添加呼吸效果 - 整体周期性扩张和收缩
        // 使用不同的相位，让不同点的呼吸效果有差异
        const breathFactor = Math.sin(time * 0.5 + this.petalOffset.phase) * 0.08 + 1.0;
        targetRadius *= breathFactor;
        
        // 为小点添加更多样的飘散效果
        if (this.originalSize < 1.8) {
          // 根据层次调整浮动幅度，越近的层次浮动越明显
          const layerFactor = this.layer / props.depthLayers;
          const movementScale = 0.5 + layerFactor * 0.8;
          
          // 沿径向（前后）的飘动
          const radialMovement = 
            (Math.sin(time * 1.5 + this.petalOffset.phase) * 15 + 
             Math.sin(time * 0.8 + this.petalOffset.phase * 3) * 8) * movementScale;
          
          // 新增：沿切向（左右环绕）的飘动
          const tangentialMovement = 
            (Math.sin(time * 1.2 + this.petalOffset.phase * 2) * 20 + 
             Math.cos(time * 0.6 + this.petalOffset.phase * 5) * 12) * movementScale;
          
          // 新增：螺旋式的环绕运动
          const spiralEffect = Math.sin(time * 0.3 + this.petalOffset.phase * 4) * 8 * movementScale;
          
          // 距离中心越远的点，飘动越明显
          targetRadius += radialMovement * this.petalOffset.distance;
          
          // 更新角度，使点在切向（圆周方向）上也有运动
          this.petalOffset.angleOffset = 
            (Math.sin(time * 0.7 + this.petalOffset.phase * 3) * 0.15 +
             Math.cos(time * 0.4 + this.petalOffset.phase * 2) * 0.1) * 
            this.petalOffset.distance * movementScale;
        } else {
          // 大点也有轻微的移动，但幅度更小
          const layerFactor = this.layer / props.depthLayers;
          const movementScale = 0.6 + layerFactor * 0.6;
          
          const smallRadialMovement = 
            (Math.sin(time * 0.9 + this.petalOffset.phase) * 5 + 
             Math.sin(time * 0.4 + this.petalOffset.phase * 2) * 3) * movementScale;
          
          // 新增：大点也有轻微的切向运动
          const smallTangentialMovement = 
            (Math.sin(time * 0.5 + this.petalOffset.phase * 1.5) * 3 + 
             Math.cos(time * 0.3 + this.petalOffset.phase * 3) * 2) * movementScale;
          
          targetRadius += smallRadialMovement * 0.7;
          
          // 更新角度，使大点也有轻微的切向运动
          this.petalOffset.angleOffset = 
            (Math.sin(time * 0.4 + this.petalOffset.phase * 2) * 0.05 +
             Math.cos(time * 0.25 + this.petalOffset.phase) * 0.03) * movementScale;
        }
        
        // 角度也会随时间轻微变化，模拟绕着中心点的缓慢旋转
        // 将基础角度变化和新增的角度偏移结合起来，创造更丰富的运动
        const angleVariation = Math.sin(time * 0.3 + this.petalOffset.phase) * 0.08;
        const currentAngle = this.petalOffset.angle + angleVariation + (this.petalOffset.angleOffset || 0);
        
        const targetX = mousePosition.x + Math.cos(currentAngle) * targetRadius;
        const targetY = mousePosition.y + Math.sin(currentAngle) * targetRadius;
        
        // 计算距离，并根据大小设置不同的移动行为
        const distToTarget = Math.sqrt(
          Math.pow(this.x - targetX, 2) + 
          Math.pow(this.y - targetY, 2)
        );
        
        // 添加轻微的随机偏移，使运动更自然
        if (Math.random() < 0.05 && !this.randomOffset) {
          this.randomOffset = {
            x: (Math.random() - 0.5) * 3 * (this.originalSize < 1.8 ? 1.5 : 0.8),
            y: (Math.random() - 0.5) * 3 * (this.originalSize < 1.8 ? 1.5 : 0.8),
            duration: Math.random() * 1000 + 500,
            startTime: Date.now()
          };
        }
        
        // 应用随机偏移，并在一定时间后消失
        let offsetX = 0;
        let offsetY = 0;
        if (this.randomOffset) {
          const elapsed = Date.now() - this.randomOffset.startTime;
          if (elapsed < this.randomOffset.duration) {
            // 使偏移随时间平滑地减小
            const factor = 1 - (elapsed / this.randomOffset.duration);
            offsetX = this.randomOffset.x * factor;
            offsetY = this.randomOffset.y * factor;
          } else {
            this.randomOffset = null;
          }
        }
        
        // 检查目标位置是否在登录框内
        if (loginBoxRect && 
            targetX > loginBoxRect.left && targetX < loginBoxRect.right &&
            targetY > loginBoxRect.top && targetY < loginBoxRect.bottom) {
          // 如果目标位置在登录框内，不移动到那里
          // 而是稍微远离登录框
          const boxCenterX = loginBoxRect.left + loginBoxRect.width / 2;
          const boxCenterY = loginBoxRect.top + loginBoxRect.height / 2;
          const awayAngle = Math.atan2(this.y - boxCenterY, this.x - boxCenterX);
          this.x += Math.cos(awayAngle) * 1;
          this.y += Math.sin(awayAngle) * 1;
        } else {
          // 根据鼠标速度和距离调整移动速度
          // 鼠标移动越快，点的移动速度也越快，确保能跟上鼠标
          let moveSpeed;
          
          if (mouseSpeed > 10) {
            // 鼠标快速移动时，增加跟随速度
            const speedFactor = Math.min(1, mouseSpeed / 50); // 限制加速度上限
            moveSpeed = 0.1 + speedFactor * 0.3 + (distToTarget / 200) * 0.2;
          } else if (distToTarget < 5) {
            // 已经很接近目标位置，使用非常小的速度微调，避免抖动
            moveSpeed = 0.02 + (distToTarget / 10) * 0.05;
          } else {
            // 正常情况下的移动速度
            moveSpeed = 0.05 + (distance / props.mouseRadius) * 0.1;
          }
          
          // 根据点的大小调整移动速度，较小的点移动速度更慢
          // 这会使小点的旋转速度减慢，看起来更稳定
          const sizeFactor = Math.min(1, this.originalSize / 2);
          // 进一步降低小点移动速度，最小可降至原速度的30%
          moveSpeed *= 0.3 + (sizeFactor * 0.5);
          
          // 根据层次调整移动速度，近层移动速度更快
          const layerSpeedFactor = 0.7 + (this.layer / props.depthLayers) * 0.5;
          moveSpeed *= layerSpeedFactor;
          
          // 点逐渐移向花朵轮廓位置
          this.x += (targetX - this.x) * moveSpeed;
          this.y += (targetY - this.y) * moveSpeed;
        }
        
        // 根据与鼠标的距离调整点的大小
        // 使用Math.max确保大小因子不会为负值
        const sizeFactor = Math.max(0, 1 + (1 - Math.min(distance / props.mouseRadius, 2)) * 1.5);
        this.size = this.originalSize * sizeFactor;
        
        // 为被吸引的点添加轻微的震动效果
        // 根据到目标位置的距离来调整震动幅度，距离越近震动越小
        // 当鼠标快速移动时，减少震动以避免视觉混乱
        const vibrationScale = mouseSpeed > 10 
          ? Math.min(distToTarget / 50, 0.5) * 0.6
          : Math.min(distToTarget / 30, 1) * 1.2;
        
        // 根据点的大小调整震动幅度，较小的点震动幅度更小
        const sizeAdjustedVibration = vibrationScale * Math.min(1, this.originalSize / 2);
        
        // 使震动更自然，添加时间依赖性
        if (Math.random() < 0.5) {  // 增加更新频率，使运动更流畅
          // 轻微增加震动幅度
          const adjustedVibration = sizeAdjustedVibration * 0.8;
          
          // 添加时间依赖的抖动，使小球的抖动看起来更自然
          const timeInfluence = (Math.sin(time * 3 + this.petalOffset.phase * 5) + 1) * 0.7;
          this.offsetX = (Math.random() - 0.5) * adjustedVibration * timeInfluence;
          this.offsetY = (Math.random() - 0.5) * adjustedVibration * timeInfluence;
        }
        
        // 减缓吸引状态下的速度，但鼠标快速移动时保持较高的响应性
        if (mouseSpeed < 5) {
          // 进一步降低小点在吸引状态下的速度变化率
          this.speedX *= 0.95;
          this.speedY *= 0.95;
        } else {
          // 鼠标快速移动时保持更高的基础速度，但仍降低小点的速度变化率
          this.speedX = this.speedX * 0.97 + (Math.sign(dx) * 0.03 * mouseSpeed/10);
          this.speedY = this.speedY * 0.97 + (Math.sign(dy) * 0.03 * mouseSpeed/10);
        }
      } else if (!this.isBound) {
        // 点不被鼠标吸引，并且不是束缚状态
        this.isAttracted = false;
        this.size = Math.max(this.size * 0.95, this.originalSize);
        this.offsetX = 0;
        this.offsetY = 0;
        this.petalOffset = null; // 重置花瓣位置偏移
      }
    }
    
    // 边界检查 - 反弹
    if (this.x > window.innerWidth) {
      this.x = window.innerWidth;
      if (this.isScattering) {
        this.scatterSpeedX = -Math.abs(this.scatterSpeedX);
      } else {
        this.speedX = -Math.abs(this.speedX);
      }
    } else if (this.x < 0) {
      this.x = 0;
      if (this.isScattering) {
        this.scatterSpeedX = Math.abs(this.scatterSpeedX);
      } else {
        this.speedX = Math.abs(this.speedX);
      }
    }
    
    if (this.y > window.innerHeight) {
      this.y = window.innerHeight;
      if (this.isScattering) {
        this.scatterSpeedY = -Math.abs(this.scatterSpeedY);
      } else {
        this.speedY = -Math.abs(this.speedY);
      }
    } else if (this.y < 0) {
      this.y = 0;
      if (this.isScattering) {
        this.scatterSpeedY = Math.abs(this.scatterSpeedY);
      } else {
        this.speedY = Math.abs(this.speedY);
      }
    }
    
    // 随机改变方向，让移动更自然
    // 但如果是被吸引状态或散射状态，则减少随机改变以避免抖动
    if (!this.isAttracted && !this.isBound && !this.isScattering && Math.random() < 0.005) {
      // 减小随机方向变化频率和幅度
      this.speedX += (Math.random() - 0.5) * 0.05;
      this.speedY += (Math.random() - 0.5) * 0.05;
    }
    
    // 限制最大速度 - 根据鼠标速度调整
    if (!this.isScattering) {
      const maxSpeed = props.dotSpeed * (this.isAttracted ? 
        (mouseSpeed < 5 ? 0.8 : 2.0) : 1.5);
      const currentSpeed = Math.sqrt(this.speedX * this.speedX + this.speedY * this.speedY);
      if (currentSpeed > maxSpeed) {
        this.speedX = (this.speedX / currentSpeed) * maxSpeed;
        this.speedY = (this.speedY / currentSpeed) * maxSpeed;
      }
      
      // 确保点不会完全停止移动，除非被吸引状态
      if (!this.isAttracted && !this.isBound) {
        if (Math.abs(this.speedX) < 0.05) {
          this.speedX = Math.sign(this.speedX || 1) * 0.05;
        }
        if (Math.abs(this.speedY) < 0.05) {
          this.speedY = Math.sign(this.speedY || 1) * 0.05;
        }
      }
    }
  }

  // 添加散射方法
  startScattering() {
    this.isScattering = true;
    this.scatterTime = Date.now();
    
    // 计算从鼠标位置散射出去的方向
    const dx = this.x - mousePosition.x;
    const dy = this.y - mousePosition.y;
    const distance = Math.sqrt(dx * dx + dy * dy);
    
    // 标准化方向向量
    const dirX = distance > 0 ? dx / distance : (Math.random() - 0.5);
    const dirY = distance > 0 ? dy / distance : (Math.random() - 0.5);
    
    // 散射速度，小点散射更快模拟蒲公英种子飘散
    const scatterSpeed = this.originalSize < 1.8 ? 
      8 + Math.random() * 12 : // 小点散射快
      5 + Math.random() * 8;   // 大点散射慢
      
    this.scatterSpeedX = dirX * scatterSpeed;
    this.scatterSpeedY = dirY * scatterSpeed;
    
    // 复位其他状态
    this.petalOffset = null;
  }

  draw() {
    // 根据点是否被吸引或散射改变颜色透明度和颜色
    let displayOpacity = this.isAttracted ? Math.min(this.opacity + 0.3, 1) : this.opacity;
    
    // 确保半径始终为正值
    this.size = Math.max(0.1, this.size);
    
    // 如果是散射状态，使用更明亮的颜色
    if (this.isScattering) {
      // 散射时间越短，颜色越亮
      const elapsed = Date.now() - this.scatterTime;
      const factor = 1 - Math.min(1, elapsed / 1000);
      
      // 所有点散射时使用相同的蓝白渐变
      const hue = 210 + factor * 30; // 浅蓝色到白色
      const saturation = 60 + factor * 20; // 不那么饱和
      const lightness = 70 + factor * 20; // 更亮
      this.color = `hsla(${hue}, ${saturation}%, ${lightness}%, ${displayOpacity})`;
    }
    // 如果被吸引，根据点的位置在蒲公英中变化颜色
    else if (this.isAttracted) {
      // 所有点使用统一的蓝色渐变，不再区分小点/大点
      const baseHue = 210; // 基本蓝色
      // 计算到中心的距离，用于调整色相
      const dx = this.x - mousePosition.x;
      const dy = this.y - mousePosition.y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      const distFactor = Math.min(1, distance / (props.mouseRadius * 0.5));
      
      // 根据层次调整颜色
      const layerFactor = this.layer / props.depthLayers;
      const hue = baseHue + distFactor * 30 - layerFactor * 10; // 深层更蓝
      const saturation = 80 - distFactor * 20 + layerFactor * 10; // 深层更饱和
      const lightness = 70 - layerFactor * 10; // 深层更深
      
      this.color = `hsla(${hue}, ${saturation}%, ${lightness}%, ${displayOpacity})`;
    } else {
      // 正常状态下，根据层次使用不同的颜色
      const layerFactor = this.layer / props.depthLayers;
      const hue = 210; // 基本蓝色
      const saturation = 60 + layerFactor * 20; // 近处点饱和度更高
      const lightness = 80 - layerFactor * 25; // 近处点更深
      this.color = `hsla(${hue}, ${saturation}%, ${lightness}%, ${displayOpacity})`;
    }
    
    ctx.fillStyle = this.color;
    ctx.beginPath();
    // 添加轻微震动效果
    ctx.arc(this.x + this.offsetX, this.y + this.offsetY, this.size, 0, Math.PI * 2);
    ctx.fill();
  }
}

// 连接点函数
const connectDots = () => {
  // 创建蒲公英中心点
  let dandelionCenter = null;
  
  // 如果鼠标在画布内且不在登录框内，绘制蒲公英形态
  if (isMouseInCanvas && !isMouseInLoginForm && mousePosition.x !== null) {
    dandelionCenter = mousePosition;
    
    // 寻找靠近鼠标的点
    const nearbyDots = dots.filter(dot => {
      const dx = dot.x - mousePosition.x;
      const dy = dot.y - mousePosition.y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      return distance < props.mouseRadius * 0.75 && dot.isAttracted;
    });
    
    // 如果有足够的点在附近，绘制蒲公英效果
    if (nearbyDots.length >= 3) {
      // 找出靠近中心的大点，它们形成蒲公英中心球体
      const centerDots = nearbyDots.filter(dot => 
        dot.originalSize >= 1.8 && dot.petalOffset && dot.petalOffset.distance < 0.5
      );
      
      // 不再绘制中心球体，删除蓝色光圈
      
      // 为所有被吸引的点都绘制连接线到中心点
      for (const dot of nearbyDots) {
        // 根据距离中心的远近调整线条透明度
        const dx = dot.x - mousePosition.x;
        const dy = dot.y - mousePosition.y;
        const distance = Math.sqrt(dx * dx + dy * dy);
        
        // 统一线条透明度计算方式，不再区分小点/大点
        const alpha = Math.max(0.2, 0.3 + distance / (props.mouseRadius * 1.5) * 0.4);
        
        // 所有线条使用统一的渐变效果
        const gradient = ctx.createLinearGradient(
          dot.x, dot.y,
          mousePosition.x, mousePosition.y
        );
        gradient.addColorStop(0, `rgba(120, 180, 255, ${alpha * 0.9})`);
        gradient.addColorStop(1, `rgba(64, 158, 255, ${alpha * 0.8})`);
        
        // 绘制细线 - 保持线宽差异以增加层次感
        ctx.strokeStyle = gradient;
        ctx.lineWidth = dot.originalSize < 1.8 ? 0.5 : 0.7;
        ctx.beginPath();
        ctx.moveTo(dot.x + dot.offsetX * 0.3, dot.y + dot.offsetY * 0.3);
        ctx.lineTo(mousePosition.x, mousePosition.y);
        ctx.stroke();
      }
    }
  }
  
  // 常规连接点（针对非蒲公英部分）
  // 先按层次排序点，以确保近处的点绘制在远处点之上
  const sortedDots = [...dots].sort((a, b) => a.layer - b.layer);
  
  // 连接同层或相邻层的点，避免连接相距太远的层
  for (let i = 0; i < sortedDots.length; i++) {
    for (let j = i + 1; j < sortedDots.length; j++) {
      // 跳过已经是花朵一部分的点之间的连接
      if (dandelionCenter && sortedDots[i].isAttracted && sortedDots[j].isAttracted) {
        continue;
      }
      
      // 只连接层次差异不超过1的点，增强景深效果
      if (Math.abs(sortedDots[i].layer - sortedDots[j].layer) > 1) {
        continue;
      }
      
      const dx = sortedDots[i].x - sortedDots[j].x;
      const dy = sortedDots[i].y - sortedDots[j].y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      
      // 连接距离调整：远处层次的点连接距离较小，近处层次的点连接距离较大
      const avgLayer = (sortedDots[i].layer + sortedDots[j].layer) / 2;
      const layerFactor = avgLayer / props.depthLayers;
      const effectiveDistance = props.connectionDistance * (0.6 + layerFactor * 0.5);
      
      // 连接距离较近的点
      if (distance < effectiveDistance) {
        // 根据距离设置线条透明度
        const alpha = 1 - (distance / effectiveDistance);
        
        // 如果两个点中至少有一个被吸引，线条会更明显
        const isEitherAttracted = sortedDots[i].isAttracted || sortedDots[j].isAttracted;
        const strokeOpacity = isEitherAttracted ? Math.min(alpha * 1.5, 0.8) : alpha * 0.3;
        
        // 根据层次调整线条透明度，远处层次更透明
        const layerOpacityFactor = 0.3 + layerFactor * 0.7;
        const finalOpacity = strokeOpacity * layerOpacityFactor;
        
        // 设置线宽根据吸引状态和层次
        const layerWidthFactor = 0.6 + layerFactor * 0.8;
        const lineWidth = isEitherAttracted ? 0.8 * layerWidthFactor : 0.5 * layerWidthFactor;
        
        // 为吸引状态的点设置彩色连线
        if (isEitherAttracted) {
          // 计算线条颜色 - 根据两点位置插值
          const dx1 = sortedDots[i].x - mousePosition.x;
          const dy1 = sortedDots[i].y - mousePosition.y;
          const dx2 = sortedDots[j].x - mousePosition.x;
          const dy2 = sortedDots[j].y - mousePosition.y;
          
          const angle1 = Math.atan2(dy1, dx1);
          const angle2 = Math.atan2(dy2, dx2);
          
          const hue1 = (((angle1 + Math.PI) / (2 * Math.PI)) * 60) + 200;
          const hue2 = (((angle2 + Math.PI) / (2 * Math.PI)) * 60) + 200;
          
          const gradient = ctx.createLinearGradient(
            sortedDots[i].x, sortedDots[i].y,
            sortedDots[j].x, sortedDots[j].y
          );
          gradient.addColorStop(0, `hsla(${hue1}, 80%, 60%, ${finalOpacity})`);
          gradient.addColorStop(1, `hsla(${hue2}, 80%, 60%, ${finalOpacity})`);
          
          ctx.strokeStyle = gradient;
        } else {
          ctx.strokeStyle = `rgba(64, 158, 255, ${finalOpacity})`;
        }
        
        ctx.lineWidth = lineWidth;
        ctx.beginPath();
        
        // 减少震动偏移的影响
        const offsetScale = isEitherAttracted ? 0.3 : 1.0;
        ctx.moveTo(
          sortedDots[i].x + sortedDots[i].offsetX * offsetScale, 
          sortedDots[i].y + sortedDots[i].offsetY * offsetScale
        );
        ctx.lineTo(
          sortedDots[j].x + sortedDots[j].offsetX * offsetScale, 
          sortedDots[j].y + sortedDots[j].offsetY * offsetScale
        );
        ctx.stroke();
      }
    }
  }
  
  // 如果鼠标在画布内且不在登录框内，连接鼠标附近的点到鼠标
  if (isMouseInCanvas && !isMouseInLoginForm && mousePosition.x !== null) {
    for (const dot of dots) {
      // 跳过已经是花朵部分的点
      if (dot.isAttracted) continue;
      
      const dx = mousePosition.x - dot.x;
      const dy = mousePosition.y - dot.y;
      const distance = Math.sqrt(dx * dx + dy * dy);
      
      if (distance < props.mouseRadius && distance > props.mouseRadius * 0.8) {
        // 距离越近，线条越明显
        const alpha = (1 - distance / props.mouseRadius) * 0.8;
        
        // 计算角度，用于渐变色
        const angle = Math.atan2(dot.y - mousePosition.y, dot.x - mousePosition.x);
        const hue = (((angle + Math.PI) / (2 * Math.PI)) * 60) + 200;
        
        ctx.strokeStyle = `hsla(${hue}, 80%, 60%, ${alpha})`;
        ctx.lineWidth = 0.8;
        ctx.beginPath();
        ctx.moveTo(dot.x + dot.offsetX * 0.3, dot.y + dot.offsetY * 0.3);
        ctx.lineTo(mousePosition.x, mousePosition.y);
        ctx.stroke();
      }
    }
  }
};

// 初始化
const init = () => {
  if (!canvas.value) return;
  
  ctx = canvas.value.getContext('2d');
  dots = [];
  resizeCanvas();

  // 创建点，确保各层次的点数量均衡
  const dotsPerLayer = Math.ceil(props.dotsCount / props.depthLayers);
  
  for (let layer = 1; layer <= props.depthLayers; layer++) {
    for (let i = 0; i < dotsPerLayer; i++) {
      const dot = new Dot();
      dot.layer = layer; // 确保每层有足够的点
      dots.push(dot);
      
      // 如果已经达到总数，提前结束
      if (dots.length >= props.dotsCount) break;
    }
    // 如果已经达到总数，提前结束
    if (dots.length >= props.dotsCount) break;
  }

  // 获取登录框位置
  updateLoginBoxPosition();

  // 设置鼠标事件 - 使用document而非canvas以确保所有区域都能捕获事件
  document.addEventListener('mousemove', handleMouseMove);
  document.addEventListener('mouseenter', handleMouseEnter);
  document.addEventListener('mouseleave', handleMouseLeave);
  document.addEventListener('click', handleMouseClick);
  window.addEventListener('resize', handleResize);

  // 监听登录框的鼠标事件
  const loginBox = document.querySelector('.login-box');
  if (loginBox) {
    // 使用命名函数以便后续可以正确移除
    const handleLoginBoxEnter = () => {
      isMouseInLoginForm = true;
    };
    
    const handleLoginBoxLeave = () => {
      isMouseInLoginForm = false;
    };
    
    // 存储引用以便卸载时使用
    window._handleLoginBoxEnter = handleLoginBoxEnter;
    window._handleLoginBoxLeave = handleLoginBoxLeave;
    
    loginBox.addEventListener('mouseenter', handleLoginBoxEnter);
    loginBox.addEventListener('mouseleave', handleLoginBoxLeave);
  }

  // 开始动画
  animate();
  
  // 立即触发一次动画帧，确保渲染
  requestAnimationFrame(() => {
    resizeCanvas();
    animate();
  });
};

// 更新登录框位置的函数
const updateLoginBoxPosition = () => {
  const loginBox = document.querySelector('.login-box');
  if (loginBox) {
    loginBoxRect = loginBox.getBoundingClientRect();
  }
};

// 处理窗口大小变化
const handleResize = () => {
  resizeCanvas();
  updateLoginBoxPosition();
};

// 重设canvas大小
const resizeCanvas = () => {
  if (!canvas.value) return;
  canvas.value.width = window.innerWidth;
  canvas.value.height = window.innerHeight;
  
  // 确保在重设大小后重新绘制
  if (ctx) {
    ctx.clearRect(0, 0, canvas.value.width, canvas.value.height);
  }
  
  // 窗口大小变化时更新登录框位置
  updateLoginBoxPosition();
};

// 处理鼠标移动
const handleMouseMove = (e) => {
  // 保存前一个鼠标位置
  if (mousePosition.x !== null) {
    prevMousePosition.x = mousePosition.x;
    prevMousePosition.y = mousePosition.y;
  } else {
    prevMousePosition.x = e.clientX;
    prevMousePosition.y = e.clientY;
  }
  
  // 更新当前鼠标位置
  mousePosition.x = e.clientX;
  mousePosition.y = e.clientY;
  
  // 计算鼠标移动速度
  if (prevMousePosition.x !== null) {
    const dx = mousePosition.x - prevMousePosition.x;
    const dy = mousePosition.y - prevMousePosition.y;
    mouseSpeed = Math.sqrt(dx * dx + dy * dy);
    
    // 随时间衰减鼠标速度，使其更自然过渡
    setTimeout(() => {
      mouseSpeed *= 0.8;
    }, 50);
  }
  
  isMouseInCanvas = true; // 当鼠标移动时，认为它在画布内
};

// 鼠标进入文档
const handleMouseEnter = () => {
  isMouseInCanvas = true;
};

// 鼠标离开文档
const handleMouseLeave = () => {
  isMouseInCanvas = false;
  mousePosition = { x: null, y: null };
  prevMousePosition = { x: null, y: null };
  
  // 重置所有粒子的束缚状态
  dots.forEach(dot => {
    dot.isBound = false;
    dot.isAttracted = false;
  });
};

// 鼠标点击处理
const handleMouseClick = (e) => {
  // 检查是否点击在Canvas上，且不在登录框内
  const rect = canvas.value.getBoundingClientRect();
  if (e.clientX >= rect.left && e.clientX <= rect.right &&
      e.clientY >= rect.top && e.clientY <= rect.bottom &&
      !isMouseInLoginForm) {
    
    mouseClicked = true;
    clickTime = Date.now();
    
    // 点击位置产生爆炸效果
    const clickX = e.clientX - rect.left;
    const clickY = e.clientY - rect.top;
    
    // 重置所有粒子的束缚状态
    dots.forEach(dot => {
      // 如果粒子被吸引，则应用散射效果
      if (dot.isAttracted || dot.isBound) {
        const dx = dot.x - clickX;
        const dy = dot.y - clickY;
        const distance = Math.sqrt(dx * dx + dy * dy);
        
        // 只影响点击半径内的点
        if (distance < props.mouseRadius * 0.8) {
          // 随机方向的偏移
          const angle = Math.atan2(dy, dx);
          const strength = (props.mouseRadius - distance) / props.mouseRadius * 20;
          
          // 设置随机偏移，并记录开始时间
          dot.randomOffset = {
            x: Math.cos(angle) * strength * (Math.random() + 0.5),
            y: Math.sin(angle) * strength * (Math.random() + 0.5),
            startTime: Date.now(),
            duration: Math.random() * 1000 + 500 // 偏移持续时间
          };
        }
        
        // 启动散射
        dot.startScattering();
      }
      
      // 重置束缚状态
      dot.isBound = false;
      dot.isAttracted = false;
    });
  }
  
  // 500毫秒后重置点击状态
    setTimeout(() => {
      mouseClicked = false;
  }, 500);
};

// 动画循环
const animate = () => {
  if (!canvas.value || !ctx) {
    animationFrameId = requestAnimationFrame(animate);
    return;
  }
  
  ctx.clearRect(0, 0, canvas.value.width, canvas.value.height);

  // 根据props.paused更新点的行为
  if (props.paused) {
    isMouseInLoginForm = true;
  }

  // 更新并绘制点
  for (const dot of dots) {
    dot.update();
    dot.draw();
  }
  
  // 连接点
  connectDots();

  animationFrameId = requestAnimationFrame(animate);
};

// 组件挂载时初始化
onMounted(() => {
  // 延迟初始化以确保DOM完全加载
  setTimeout(() => {
    if (canvas.value) {
      console.log('初始化Canvas');
      init();
    } else {
      console.error('Canvas元素不存在');
    }
  }, 300);
});

// 监听props变化
watch(() => props.paused, (newVal) => {
  if (!newVal && !animationFrameId) {
    animate();
  }
});

// 组件卸载时清理
onUnmounted(() => {
  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId);
  }
  document.removeEventListener('mousemove', handleMouseMove);
  document.removeEventListener('mouseenter', handleMouseEnter);
  document.removeEventListener('mouseleave', handleMouseLeave);
  document.removeEventListener('click', handleMouseClick);
  window.removeEventListener('resize', handleResize);
  
  // 移除登录框事件监听
  const loginBox = document.querySelector('.login-box');
  if (loginBox && window._handleLoginBoxEnter && window._handleLoginBoxLeave) {
    loginBox.removeEventListener('mouseenter', window._handleLoginBoxEnter);
    loginBox.removeEventListener('mouseleave', window._handleLoginBoxLeave);
    
    // 清理引用
    delete window._handleLoginBoxEnter;
    delete window._handleLoginBoxLeave;
  }
});
</script>

<style scoped>
.vines-canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 1;
  pointer-events: none;
  display: block;
}
</style>

