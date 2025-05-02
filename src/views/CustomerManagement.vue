<template>
  <div class="customer-management-container">
    <!-- 顶部导航栏 -->
    <LeaderNavBar activePage="customer" />
    
    <!-- 页面内容 -->
    <div class="page-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <h1>客户管理</h1>
        <p class="subtitle">管理潜在客户信息，跟踪转化情况</p>
      </div>
      
      <!-- 筛选工具栏 -->
      <div class="filter-toolbar">
        <div class="search-box">
          <el-input
            v-model="searchParams.keyword"
            placeholder="搜索客户名称/电话/邮箱"
            @keyup.enter="handleSearch"
            clearable
            @clear="handleClear"
          >
            <template #prefix>
              <el-icon><search /></el-icon>
            </template>
          </el-input>
          <el-button type="primary" @click="handleSearch" class="search-btn">搜索</el-button>
        </div>
      </div>
      
      <!-- 客户数据表格 -->
      <div class="customer-table-card">
        <div class="table-container">
          <el-table
            v-loading="loading"
            :data="customers"
            border
            stripe
            class="customer-table"
            :header-cell-style="{ backgroundColor: '#f5f7fa', color: '#606266', fontWeight: 'bold' }"
            @row-click="viewCustomerDetail"
            @sort-change="handleSortChange"
          >
            <!-- ID列 -->
            <el-table-column prop="id" label="ID" width="100" align="center" sortable="custom" />
            
            <!-- 客户名称 -->
            <el-table-column prop="name" label="客户名称" min-width="220" sortable="custom">
              <template #default="scope">
                <div class="customer-name-cell">
                  <span class="customer-name">{{ scope.row.name }}</span>
                  <el-tag v-if="scope.row.status === 'converted'" size="small" type="success">已转化</el-tag>
                  <el-tag v-else size="small" type="info">潜在</el-tag>
                </div>
              </template>
            </el-table-column>
            
            <!-- 联系电话 -->
            <el-table-column prop="phone" label="联系电话" min-width="180" sortable="custom">
              <template #default="scope">
                <span>{{ scope.row.phone || '未提供' }}</span>
              </template>
            </el-table-column>
            
            <!-- 电子邮箱 -->
            <el-table-column prop="email" label="电子邮箱" min-width="220" sortable="custom">
              <template #default="scope">
                <span>{{ scope.row.email || '未提供' }}</span>
              </template>
            </el-table-column>
            
            <template #empty>
              <el-empty description="暂无客户数据" />
            </template>
          </el-table>
        </div>
        
        <!-- 分页器 -->
        <div class="pagination-container">
          <el-pagination
            v-model:current-page="searchParams.page"
            v-model:page-size="searchParams.size"
            :page-sizes="[10, 20, 30, 50]"
            layout="total, sizes, prev, pager, next, jumper"
            :total="totalCustomers"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
          />
        </div>
      </div>
    </div>
    
    <!-- 客户详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="客户详情"
      width="650px"
      :close-on-click-modal="false"
      :destroy-on-close="true"
    >
      <template v-if="selectedCustomer">
        <div class="customer-detail">
          <!-- 基础信息卡片 -->
          <el-card class="detail-card">
            <template #header>
              <div class="card-header">
                <span>基础信息</span>
              </div>
            </template>
            <div class="info-grid">
              <div class="info-item">
                <span class="info-label">客户ID</span>
                <span class="info-value">{{ selectedCustomer.id }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">客户名称</span>
                <span class="info-value">{{ selectedCustomer.name }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">联系电话</span>
                <span class="info-value">{{ selectedCustomer.phone || '未提供' }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">电子邮箱</span>
                <span class="info-value">{{ selectedCustomer.email || '未提供' }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">客户状态</span>
                <span class="info-value">
                  <el-tag v-if="selectedCustomer.status === 'converted'" type="success">已转化</el-tag>
                  <el-tag v-else type="info">潜在客户</el-tag>
                </span>
              </div>
              <div class="info-item">
                <span class="info-label">所属团队成员</span>
                <span class="info-value">{{ selectedCustomer.team_member || '直接客户' }}</span>
              </div>
            </div>
          </el-card>
          
          <!-- 转化记录 -->
          <el-card class="detail-card">
            <template #header>
              <div class="card-header">
                <span>转化记录</span>
              </div>
            </template>
            <div v-if="selectedCustomer.status === 'converted'">
              <div class="conversion-info">
                <p><strong>转化时间：</strong> {{ formatDate(selectedCustomer.converted_at) }}</p>
                <p><strong>转化产品：</strong> {{ selectedCustomer.product_name }}</p>
                <p><strong>订单金额：</strong> ¥{{ selectedCustomer.order_amount }}</p>
              </div>
            </div>
            <el-empty v-else description="暂无转化记录" />
          </el-card>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue';
import { Search } from '@element-plus/icons-vue';
import { ElMessage } from 'element-plus';
import LeaderNavBar from '@/components/LeaderNavBar.vue';
import { getCustomers } from '@/api/leader';
import { formatDate as formatDateUtil } from '@/utils/format';

// 状态变量
const loading = ref(false);
const customers = ref([]);
const totalCustomers = ref(0);
const detailDialogVisible = ref(false);
const selectedCustomer = ref(null);

// 客户统计数据
const customerStats = reactive({
  total: 0,
  potential: 0,
  converted: 0,
  newThisWeek: 0
});

// 搜索参数
const searchParams = reactive({
  page: 1,
  size: 10,
  keyword: '',
  sort: 'name',
  order: 'desc',
  status: '',
  teamOnly: false
});

// 处理表格排序变化
const handleSortChange = ({ prop, order }) => {
  if (prop) {
    // 将el-table的排序值转换为API所需的排序参数
    searchParams.sort = prop;
    searchParams.order = order === 'ascending' ? 'asc' : 
                        order === 'descending' ? 'desc' : 'desc';

    console.log('排序变更:', prop, searchParams.order);
    fetchCustomers();
  } else {
    // 如果取消排序，恢复默认排序
    searchParams.sort = 'name';
    searchParams.order = 'desc';
    fetchCustomers();
  }
};

// 获取客户数据
const fetchCustomers = async () => {
  loading.value = true;
  try {
    console.log('发送请求参数:', {
      sort: searchParams.sort,
      order: searchParams.order
    });

    const response = await getCustomers({
      page: searchParams.page,
      size: searchParams.size,
      keyword: searchParams.keyword,
      sort: searchParams.sort,
      order: searchParams.order,
      status: searchParams.status,
      team_only: searchParams.teamOnly
    });
    
    // 检查API返回结构
    if (response && response.code === 1) {
      // 根据API实际返回结构调整
      let customersData = response.data.customers || [];
      totalCustomers.value = response.data.total || 0;
      
      // 确保本地再次排序，以防后端API没有正确处理排序
      if (customersData.length > 0 && searchParams.sort) {
        customersData = sortCustomers(customersData, searchParams.sort, searchParams.order);
      }
      
      customers.value = customersData;
      
      // 如果API返回了统计数据就使用，否则手动计算
      if (response.data.stats) {
        customerStats.total = response.data.stats.total || 0;
        customerStats.potential = response.data.stats.potential || 0;
        customerStats.converted = response.data.stats.converted || 0;
        customerStats.newThisWeek = response.data.stats.new_this_week || 0;
      } else {
        // 手动计算统计数据
        calculateCustomerStats();
      }
    } else {
      ElMessage.warning(response?.msg || '获取客户数据失败');
      customers.value = [];
      totalCustomers.value = 0;
      resetCustomerStats();
    }
  } catch (error) {
    console.error('获取客户数据失败', error);
    ElMessage.error('获取客户数据失败，请稍后重试');
    customers.value = [];
    totalCustomers.value = 0;
    resetCustomerStats();
  } finally {
    loading.value = false;
  }
};

// 本地排序函数
const sortCustomers = (data, prop, order) => {
  return [...data].sort((a, b) => {
    let aValue = a[prop];
    let bValue = b[prop];
    
    // 处理空值情况
    if (aValue === null || aValue === undefined) aValue = '';
    if (bValue === null || bValue === undefined) bValue = '';
    
    // 字符串类型，不区分大小写
    if (typeof aValue === 'string' && typeof bValue === 'string') {
      aValue = aValue.toLowerCase();
      bValue = bValue.toLowerCase();
    }
    
    // 升序排序
    if (order === 'asc') {
      return aValue > bValue ? 1 : aValue < bValue ? -1 : 0;
    } 
    // 降序排序
    else {
      return aValue < bValue ? 1 : aValue > bValue ? -1 : 0;
    }
  });
};

// 计算客户统计数据
const calculateCustomerStats = () => {
  // 总数直接使用API返回的总记录数
  customerStats.total = totalCustomers.value;
  
  if (customers.value.length === 0) {
    customerStats.potential = 0;
    customerStats.converted = 0;
    customerStats.newThisWeek = 0;
    return;
  }
  
  // 计算已转化和潜在客户数量
  // 注意：当前页的数据可能不代表全部数据，所以这里只是一个估计
  const convertedCustomers = customers.value.filter(customer => customer.status === 'converted');
  const potentialCustomers = customers.value.filter(customer => customer.status !== 'converted');
  
  // 如果当前页数据条数等于每页显示数量，说明可能有更多数据
  if (customers.value.length === searchParams.size) {
    // 计算比例并估算总体数量
    const convertedRatio = convertedCustomers.length / customers.value.length;
    customerStats.converted = Math.round(totalCustomers.value * convertedRatio);
    customerStats.potential = totalCustomers.value - customerStats.converted;
  } else {
    // 如果数据量小于一页，可以直接统计
    customerStats.converted = convertedCustomers.length;
    customerStats.potential = potentialCustomers.length;
  }
  
  // 计算本周新增客户
  const oneWeekAgo = new Date();
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
  
  customerStats.newThisWeek = customers.value.filter(customer => {
    if (!customer.created_at) return false;
    const createDate = new Date(customer.created_at);
    return createDate >= oneWeekAgo;
  }).length;
};

// 重置客户统计数据
const resetCustomerStats = () => {
  customerStats.total = 0;
  customerStats.potential = 0;
  customerStats.converted = 0;
  customerStats.newThisWeek = 0;
};

// 搜索处理
const handleSearch = () => {
  searchParams.page = 1; // 重置到第一页
  fetchCustomers();
};

// 清除搜索
const handleClear = () => {
  searchParams.keyword = '';
  fetchCustomers();
};

// 分页处理
const handleSizeChange = (size) => {
  searchParams.size = size;
  fetchCustomers();
};

const handleCurrentChange = (page) => {
  searchParams.page = page;
  fetchCustomers();
};

// 查看客户详情
const viewCustomerDetail = (row) => {
  selectedCustomer.value = row;
  detailDialogVisible.value = true;
};

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return '未知';
  return formatDateUtil(dateString, 'YYYY-MM-DD HH:mm:ss');
};

// 客户来源标签类型
const getSourceTagType = (source) => {
  const types = {
    website: 'primary',
    referral: 'success',
    social: 'warning',
    event: 'danger',
    other: 'info'
  };
  return types[source] || 'info';
};

// 客户来源标签文本
const getSourceLabel = (source) => {
  const labels = {
    website: '官网',
    referral: '推荐',
    social: '社交媒体',
    event: '活动',
    other: '其他'
  };
  return labels[source] || '其他';
};

// 生命周期钩子
onMounted(() => {
  fetchCustomers();
});
</script>

<style scoped>
.customer-management-container {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.page-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 24px 16px;
}

.page-header {
  margin-bottom: 16px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.05);
  padding: 16px;
  margin-bottom: 16px;
}

.page-header h1 {
  font-size: 22px;
  color: #303133;
  margin-bottom: 4px;
}

.subtitle {
  color: #909399;
  font-size: 13px;
}

.filter-toolbar {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-bottom: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.05);
  padding: 12px 16px;
}

.search-box {
  display: flex;
  gap: 5px;
  width: 100%;
  max-width: 550px;
}

.search-box :deep(.el-input__wrapper) {
  padding-right: 8px;
}

@media (max-width: 768px) {
  .filter-toolbar {
    flex-direction: column;
    gap: 12px;
  }
  
  .search-box {
    max-width: 100%;
    width: 100%;
  }
}

.customer-table-card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
  margin-bottom: 16px;
  max-width: 900px;
  margin-left: auto;
  margin-right: auto;
  overflow: hidden;
  margin-top: 16px;
}

.table-container {
  padding: 16px;
}

.customer-table {
  width: 100%;
}

.customer-table :deep(th) {
  background-color: #f5f7fa !important;
  color: #606266 !important;
  font-weight: 600 !important;
  font-size: 14px;
  padding: 12px 0;
  cursor: pointer;
  transition: all 0.2s;
}

.customer-table :deep(th:hover) {
  background-color: #ecf5ff !important;
}

.customer-table :deep(.sort-caret) {
  border-width: 5px;
}

.customer-table :deep(.ascending .sort-caret.ascending) {
  border-bottom-color: #409EFF;
}

.customer-table :deep(.descending .sort-caret.descending) {
  border-top-color: #409EFF;
}

.customer-table :deep(td) {
  padding: 12px 8px;
}

.customer-name-cell {
  display: flex;
  align-items: center;
  gap: 10px;
}

.customer-name {
  font-weight: 500;
  color: #303133;
  font-size: 14px;
}

.pagination-container {
  padding: 16px;
  display: flex;
  justify-content: center;
  border-top: 1px solid #ebeef5;
}

.pagination-container :deep(.el-pagination) {
  font-weight: normal;
  padding: 0;
}

.pagination-container :deep(.el-pagination button) {
  background-color: transparent;
}

.pagination-container :deep(.el-pagination .el-pager li) {
  border-radius: 4px;
  margin: 0 2px;
}

.pagination-container :deep(.el-pagination .el-pager li.active) {
  background-color: #409EFF;
  color: #fff;
}

.customer-detail {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.detail-card {
  margin-bottom: 16px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: bold;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.info-label {
  font-size: 14px;
  color: #909399;
}

.info-value {
  font-size: 16px;
  color: #303133;
  font-weight: 500;
}

.conversion-info {
  line-height: 1.8;
}

.search-btn {
  height: 40px;
  padding: 0 15px;
}
</style> 