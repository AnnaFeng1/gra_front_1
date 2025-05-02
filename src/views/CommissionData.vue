<template>
  <div class="commission-data-container">
    <!-- 使用公共导航栏组件 -->
    <LeaderNavBar activePage="commission" />

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <h2 class="page-title">佣金数据展示</h2>
        <div class="page-actions">
          <el-button-group>
            <el-button type="primary">
              <i class="el-icon-refresh"></i> 刷新数据
            </el-button>
            <el-button type="success">
              <i class="el-icon-download"></i> 导出数据
            </el-button>
          </el-button-group>
        </div>
      </div>

      <!-- 内容区域 -->
      <el-card class="data-card">
        <template #header>
          <div class="card-header">
            <span><i class="el-icon-data-analysis"></i> 佣金数据统计</span>
          </div>
        </template>
        <div class="placeholder-content">
          <el-empty description="佣金数据展示功能开发中..." />
        </div>
      </el-card>
    </div>
  </div>
</template>

<script>
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import LeaderNavBar from '@/components/LeaderNavBar.vue';

export default {
  name: 'CommissionData',
  components: {
    LeaderNavBar
  },
  setup() {
    const router = useRouter();
    
    return {};
  }
}
</script>

<style scoped>
.commission-data-container {
  min-height: 100vh;
  background-color: #f5f9fc;
  display: flex;
  flex-direction: column;
  font-family: 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
}

.main-content {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-title {
  font-size: 24px;
  color: #303133;
  margin: 0;
}

.data-card {
  border-radius: 8px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
}

.placeholder-content {
  padding: 50px 0;
}
</style> 