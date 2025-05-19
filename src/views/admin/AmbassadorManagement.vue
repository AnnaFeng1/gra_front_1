<template>
  <div class="ambassador-management">
    <AdminNavBar activePage="ambassador" />
    <div class="content-container">
      <div class="main-layout" ref="fullpageContainer">
        <!-- 左侧导航 -->
        <div class="side-nav">
          <div class="nav-container">
            <!-- 导航指示器 -->
            <div class="nav-steps">
              <div class="step-item" 
                  :class="{ active: currentPage === 0 }" 
                  @click="navigateToPage(0)">
                <div class="step-icon individual">
                  <i class="el-icon-user"></i>
                </div>
                <div class="step-label">独立大使</div>
              </div>
              
              <div class="step-line-container">
                <!-- 静态背景线 -->
                <div class="step-line-bg"></div>
                <!-- 动态前景线，通过颜色变化展示动画 -->
                <div class="step-line-active" 
                     :class="{ 
                       'individual-active': currentPage === 0,
                       'team-active': currentPage === 1,
                       'transition-animation': isTransitioning
                     }">
                </div>
              </div>
              
              <div class="step-item" 
                  :class="{ active: currentPage === 1 }" 
                  @click="navigateToPage(1)">
                <div class="step-icon team">
                  <i class="el-icon-user-solid"></i>
                </div>
                <div class="step-label">团队管理</div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 全屏页面容器 -->
        <div class="fullpage-wrapper">
          <!-- 独立推广大使管理页 -->
          <div class="fullpage-section" :class="{ active: currentPage === 0 }">
            <div class="content-area">
              <IndividualAmbassadorManagement />
            </div>
          </div>
          
          <!-- 推广大使团队管理页 -->
          <div class="fullpage-section" :class="{ active: currentPage === 1 }">
            <div class="content-area">
              <TeamAmbassadorManagement v-if="currentPage === 1" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import AdminNavBar from '@/components/AdminNavBar.vue';
import IndividualAmbassadorManagement from './IndividualAmbassadorManagement.vue';
import TeamAmbassadorManagement from './TeamAmbassadorManagement.vue';
import { ref, onMounted, onUnmounted, watch } from 'vue';

// 当前页面索引，默认为1（团队管理）
const currentPage = ref(1);
const fullpageContainer = ref(null);
const isScrolling = ref(false);
const isTransitioning = ref(false); // 标记连接线是否正在过渡动画中
const totalPages = 2; // 总页数
const scrollDelay = 800; // 滚动延迟时间，以毫秒为单位
const transitionDuration = 1500; // 线条过渡动画持续时间，与CSS中的动画时间一致

// 处理页面切换时的线条动画
watch(currentPage, () => {
  // 触发过渡动画
  isTransitioning.value = true;
  
  // 动画完成后移除过渡动画状态
  setTimeout(() => {
    isTransitioning.value = false;
  }, transitionDuration);
});

// 导航到指定页面
const navigateToPage = (pageIndex) => {
  if (currentPage.value !== pageIndex) {
    currentPage.value = pageIndex;
  }
};

// 处理鼠标滚轮事件
const handleWheel = (event) => {
  if (isScrolling.value) return;
  
  // 延迟执行，防止连续滚动
  isScrolling.value = true;
  setTimeout(() => {
    isScrolling.value = false;
  }, scrollDelay);
  
  // 向下滚动，前进到下一页
  if (event.deltaY > 0) {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    }
  } 
  // 向上滚动，后退到上一页
  else if (event.deltaY < 0) {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }
};

// 处理键盘事件
const handleKeyDown = (event) => {
  if (isScrolling.value) return;
  
  isScrolling.value = true;
  setTimeout(() => {
    isScrolling.value = false;
  }, scrollDelay);
  
  // 向下键或Page Down，前进到下一页
  if (event.key === 'ArrowDown' || event.key === 'PageDown') {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
    }
    event.preventDefault();
  } 
  // 向上键或Page Up，后退到上一页
  else if (event.key === 'ArrowUp' || event.key === 'PageUp') {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
    event.preventDefault();
  }
};

// 组件加载时的逻辑
onMounted(() => {
  console.log('管理员推广大使管理页面已加载');
  // 添加滚轮和键盘事件监听
  window.addEventListener('wheel', handleWheel, { passive: false });
  window.addEventListener('keydown', handleKeyDown);
});

// 组件卸载时清理事件监听
onUnmounted(() => {
  window.removeEventListener('wheel', handleWheel);
  window.removeEventListener('keydown', handleKeyDown);
});
</script>

<style scoped>
.ambassador-management {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f7fa;
}

.content-container {
  padding: 20px;
  margin-top: 10px;
  flex: 1;
  overflow: hidden; /* 防止滚动条出现 */
}

.main-layout {
  display: flex;
  height: calc(100vh - 100px);
  position: relative;
  overflow: hidden;
}

.side-nav {
  width: 200px;
  flex-shrink: 0;
  position: relative;
  z-index: 10;
}

.nav-container {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 0 10px;
}

.nav-steps {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 100%;
  position: relative;
  margin-top: 30px; /* 添加顶部间距，补偿删除标题后的空间 */
}

.step-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  margin: 10px 0;
  position: relative;
  width: 100%;
  transition: all 0.3s ease;
}

.step-icon {
  width: 54px;
  height: 54px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 8px;
  color: white;
  font-size: 22px;
  position: relative;
  transition: all 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
  transform: translateZ(0) scale(0.85); /* 默认稍微缩小 */
  backface-visibility: hidden;
  will-change: transform, box-shadow, opacity;
  opacity: 0.75; /* 默认降低透明度 */
}

.step-icon.individual {
  background: linear-gradient(135deg, #67C23A, #85ce61);
}

.step-icon.team {
  background: linear-gradient(135deg, #409EFF, #79bbff);
}

.step-item.active .step-icon {
  transform: scale(1.2) translateZ(0); /* 放大比例从1.08增加到1.2 */
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
  opacity: 1; /* 选中项完全不透明 */
}

.step-item.active .step-label {
  color: #303133;
  font-weight: bold;
  transform: scale(1.1); /* 文字也稍微放大 */
}

/* 添加内部发光效果 */
.step-item.active .step-icon::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 12px;
  box-shadow: inset 0 0 15px rgba(255, 255, 255, 0.5);
  animation: pulse-glow 2s infinite alternate ease-in-out;
  z-index: 0;
}

@keyframes pulse-glow {
  0% {
    opacity: 0.3;
  }
  100% {
    opacity: 0.7;
  }
}

.step-label {
  font-size: 14px;
  color: #606266;
  margin-top: 5px;
  transition: all 0.4s ease;
  font-weight: 500;
}

/* 连接线效果 */
.step-line-container {
  height: 70px;
  width: 4px;
  position: relative;
  margin: 5px 0;
  display: flex;
  justify-content: center;
}

.step-line-bg {
  width: 3px;
  height: 100%;
  background-color: #f0f2f5;
  border-radius: 1.5px;
  position: absolute;
}

.step-line-active {
  width: 3px;
  height: 100%;
  border-radius: 1.5px;
  position: absolute;
  transition: background 0.8s ease;
}

/* 非过渡状态下的静态颜色 */
.step-line-active.individual-active {
  background: linear-gradient(to bottom, rgba(103, 194, 58, 0.9), rgba(64, 158, 255, 0.4));
}

.step-line-active.team-active {
  background: linear-gradient(to bottom, rgba(103, 194, 58, 0.4), rgba(64, 158, 255, 0.9));
}

/* 过渡动画效果，只在切换时激活 */
.step-line-active.transition-animation {
  background-size: 100% 200%;
  transition: background-position 1.5s ease-in-out;
}

.step-line-active.transition-animation.individual-active {
  background-position: 0 100%;
  animation: transition-down 1.5s ease-in-out;
}

.step-line-active.transition-animation.team-active {
  background-position: 0 0%;
  animation: transition-up 1.5s ease-in-out;
}

@keyframes transition-down {
  0% {
    background-position: 0 -100%;
  }
  100% {
    background-position: 0 100%;
  }
}

@keyframes transition-up {
  0% {
    background-position: 0 100%;
  }
  100% {
    background-position: 0 0%;
  }
}

.step-item:hover .step-icon {
  transform: scale(1.05) translateZ(0);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  opacity: 0.9; /* 悬停时提高透明度但不要完全不透明 */
}

/* 全屏翻页相关样式 */
.fullpage-wrapper {
  flex: 1;
  position: relative;
  height: 100%;
  overflow: hidden;
  margin-left: -15px;
  /* 确保不遮挡内容区域的圆角 */
  border-radius: 24px;
}

.fullpage-section {
  position: absolute;
  width: 100%;
  height: 100%;
  transition: transform 0.8s cubic-bezier(0.86, 0, 0.07, 1), opacity 0.6s ease;
  transform: translateY(100%);
  opacity: 0;
  visibility: hidden;
  /* 添加圆角确保不裁剪子元素 */
  border-radius: 24px;
}

.fullpage-section.active {
  transform: translateY(0);
  opacity: 1;
  visibility: visible;
  z-index: 1;
}

.content-area {
  width: 100%;
  height: 100%;
  background-color: #fff;
  /* 统一设置四个角的圆角 */
  border-radius: 24px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
  overflow: hidden;
  padding: 28px;
  margin-left: 15px;
  position: relative;
  z-index: 1;
}
</style> 