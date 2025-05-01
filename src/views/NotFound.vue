<template>
  <div class="not-found-container">
    <div class="not-found-content">
      <div class="not-found-title">404</div>
      <div class="not-found-subtitle">页面未找到</div>
      <div class="not-found-message">很抱歉，您访问的页面不存在</div>
      <el-button type="primary" @click="goHome" class="go-home-btn">返回首页</el-button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

const goHome = () => {
  router.push('/');
};
</script>

<style scoped>
.not-found-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #f5f9fc;
  font-family: 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
}

.not-found-content {
  text-align: center;
  padding: 40px;
}

.not-found-title {
  font-size: 120px;
  font-weight: bold;
  color: #409EFF;
  line-height: 1.2;
  margin-bottom: 20px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
}

.not-found-subtitle {
  font-size: 30px;
  color: #2c3e50;
  margin-bottom: 20px;
}

.not-found-message {
  font-size: 16px;
  color: #606266;
  margin-bottom: 30px;
}

.go-home-btn {
  padding: 12px 25px;
  font-size: 16px;
}
</style> 