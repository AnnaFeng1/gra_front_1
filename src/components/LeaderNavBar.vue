<template>
  <div class="header">
    <div class="left-section">
      <div class="logo">营销推广管理系统</div>
    </div>
    <div class="nav-menu">
      <div class="nav-item" :class="{ active: activePage === 'home' }" @click="navigateTo('/')">仪表盘</div>
      <div class="nav-item" :class="{ active: activePage === 'team' }" @click="navigateTo('/team-management')">团队管理</div>
      <div class="nav-item" :class="{ active: activePage === 'customer' }" @click="navigateTo('/customer-data')">客户数据展示</div>
    </div>
    <div class="user-info">
      <el-button 
        class="user-center-btn"
        :class="{ 'active-btn': activePage === 'profile' }"
        @click="goToUserCenter">
        <i class="el-icon-user"></i> 个人中心
      </el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

// 路由
const router = useRouter();

// 当前活动页面，由父组件传入
const props = defineProps({
  activePage: {
    type: String,
    default: 'home'
  }
});

// 跳转到用户中心
const goToUserCenter = () => {
  router.push('/profile');
};

// 导航到指定页面
const navigateTo = (path) => {
  router.push(path);
};
</script>

<style scoped>
.header {
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
  padding: 0;
  display: flex;
  align-items: center;
  height: 60px;
  position: sticky;
  top: 0;
  z-index: 100;
  width: 100%;
  box-sizing: border-box;
  border-bottom: 1px solid #eaeaea;
}

.left-section {
  width: 200px;
  padding-left: 20px;
  display: flex;
  align-items: center;
}

.logo {
  font-size: 20px;
  font-weight: bold;
  color: #409EFF;
  white-space: nowrap;
  flex-shrink: 0;
}

.nav-menu {
  display: flex;
  align-items: center;
  flex: 1;
  justify-content: flex-end;
  margin-right: 30px;
}

.nav-item {
  padding: 0 15px;
  font-size: 16px;
  font-weight: 500;
  color: #606266;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  height: 60px;
  display: flex;
  align-items: center;
}

.nav-item:hover {
  color: #409EFF;
}

.nav-item.active {
  color: #409EFF;
  font-weight: 600;
}

.nav-item.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background-color: #409EFF;
}

.user-info {
  width: auto;
  padding-right: 20px;
  display: flex;
  justify-content: flex-end;
}

.user-center-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  background-color: #333;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 8px 16px;
  font-size: 14px;
  transition: all 0.3s;
  height: 36px;
}

.user-center-btn:hover {
  background-color: #444;
}

.user-center-btn.active-btn {
  background-color: #409EFF;
}

.user-center-btn.active-btn:hover {
  background-color: #66b1ff;
}
</style> 