<template>
  <div class="customer-data">
    <AdminNavBar activePage="customer" />
    <div class="content-container">
      <!-- 标题和全局刷新按钮 -->
      <div class="page-header">
        <h1 class="page-title">客户数据管理</h1>
        <el-tooltip
          content="刷新所有数据"
          placement="left"
          :disabled="loading || statsLoading"
        >
          <el-button 
            class="global-refresh-btn" 
            :disabled="loading || statsLoading"
            @click="refreshAllData"
            type="primary"
            circle
            :loading="loading || statsLoading">
            <el-icon :size="22"><RefreshRight /></el-icon>
          </el-button>
        </el-tooltip>
      </div>
      <div class="customer-content">
        <!-- 客户数据统计卡片 -->
        <div class="customer-stats-card" v-loading="statsLoading">
          <div class="stats-header">
            <h3>客户数据概览</h3>
          </div>
          <div class="stats-content">
            <div class="stats-item">
              <div class="stats-value">{{ statistics.total_customers || 0 }}</div>
              <div class="stats-label">总客户数</div>
            </div>
            <div class="stats-item">
              <div class="stats-value">{{ statistics.potential_customers || 0 }}</div>
              <div class="stats-label">潜在客户</div>
            </div>
            <div class="stats-item">
              <div class="stats-value">{{ statistics.converted_customers || 0 }}</div>
              <div class="stats-label">已转化客户</div>
            </div>
            <div class="stats-item">
              <div class="stats-value">{{ statistics.new_customers_7days || 0 }}</div>
              <div class="stats-label">近7天新增</div>
            </div>
          </div>
        </div>
        
        <!-- 客户列表卡片 -->
        <div class="customer-list-card">
          <!-- 列表标题和刷新按钮 -->
          <div class="list-header">
            <div class="title-section">
              <h3>客户列表</h3>
            </div>
          </div>
          
          <!-- 过滤和搜索条件 -->
          <div class="filter-search-bar">
            <div class="search-area">
              <div class="search-box">
                <el-input
                  v-model="searchKeyword"
                  placeholder="搜索姓名/电话/邮箱"
                  :prefix-icon="Search"
                  clearable
                  @clear="handleSearch"
                  @keyup.enter="handleSearch"
                >
                  <template #append>
                    <el-button :icon="Search" @click="handleSearch"></el-button>
                  </template>
                </el-input>
              </div>
              <div class="filter-options">
                <el-select v-model="filterStatus" placeholder="客户状态" clearable @change="handleFilterChange">
                  <el-option label="全部" value=""></el-option>
                  <el-option label="潜在客户" value="potential"></el-option>
                  <el-option label="已转化客户" value="converted"></el-option>
                </el-select>
              </div>
            </div>
          </div>
          
          <!-- 客户列表表格 -->
          <el-table
            v-loading="loading"
            :data="customerList"
            style="width: 100%"
            @sort-change="handleSortChange"
            :header-cell-style="{ background: '#f5f7fa', color: '#606266' }"
            :cell-style="{ padding: '12px 0' }"
          >
            <el-table-column prop="id" label="ID" width="80" sortable="custom"></el-table-column>
            <el-table-column prop="name" label="客户姓名" sortable="custom"></el-table-column>
            <el-table-column prop="email" label="电子邮箱" min-width="180"></el-table-column>
            <el-table-column prop="phone" label="电话" min-width="140"></el-table-column>
            <el-table-column prop="status" label="状态" width="120" sortable="custom">
              <template #default="scope">
                <el-tag :type="scope.row.status === 'converted' ? 'success' : 'info'">
                  {{ scope.row.status === 'converted' ? '已转化' : '潜在客户' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="created_time" label="创建时间" min-width="180" sortable="custom">
              <template #default="scope">
                {{ formatDate(scope.row.created_time) }}
              </template>
            </el-table-column>
            
            <!-- 操作列 -->
            <el-table-column label="操作" width="120" fixed="right">
              <template #default="scope">
                <div class="action-buttons-group">
                  <el-button type="primary" size="small" plain @click="handleViewDetails(scope.row)">查看</el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
          
          <!-- 分页区域 -->
          <div class="pagination-area">
            <el-pagination
              background
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
              :current-page="currentPage"
              :page-sizes="[10, 20, 50]"
              :page-size="pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="total"
            >
            </el-pagination>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 客户详情对话框 -->
    <el-dialog
      title="客户详情"
      v-model="detailVisible"
      width="700px"
      destroy-on-close
      class="customer-detail-dialog"
    >
      <div v-loading="detailLoading" class="detail-container">
        <template v-if="customerDetail">
          <!-- 客户状态标识 -->
          <div class="detail-header">
            <el-tag :type="customerDetail.status === 'converted' ? 'success' : 'info'" size="large" effect="dark" class="status-tag">
              {{ customerDetail.status === 'converted' ? '已转化客户' : '潜在客户' }}
            </el-tag>
            <div class="customer-id">客户ID: <span class="id-value">{{ customerDetail.id }}</span></div>
          </div>

          <!-- 基本信息部分 -->
          <div class="detail-section">
            <h3 class="detail-title">
              <el-icon class="section-icon"><UserFilled /></el-icon>
              基本信息
            </h3>
            <el-descriptions :column="2" size="large" border class="customer-descriptions">
              <el-descriptions-item label="客户姓名" label-class-name="label-bold">
                <span class="customer-name">{{ customerDetail.name }}</span>
              </el-descriptions-item>
              <el-descriptions-item label="联系电话" label-class-name="label-bold">
                <span v-if="customerDetail.phone">{{ customerDetail.phone }}</span>
                <el-tag v-else size="small" type="info">未设置</el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="电子邮箱" label-class-name="label-bold">
                <span v-if="customerDetail.email">{{ customerDetail.email }}</span>
                <el-tag v-else size="small" type="info">未设置</el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="客户状态" label-class-name="label-bold">
                <el-tag :type="customerDetail.status === 'converted' ? 'success' : 'info'">
                  {{ customerDetail.status === 'converted' ? '已转化' : '潜在客户' }}
                </el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="创建时间" label-class-name="label-bold">
                {{ formatDate(customerDetail.created_at) }}
              </el-descriptions-item>
              <el-descriptions-item label="更新时间" label-class-name="label-bold">
                {{ formatDate(customerDetail.updated_at) }}
              </el-descriptions-item>
            </el-descriptions>
          </div>
          
          <!-- 如果是已转化客户，显示转化记录 -->
          <div class="detail-section" v-if="customerDetail.status === 'converted' && customerDetail.camp_conversions && customerDetail.camp_conversions.length > 0">
            <h3 class="detail-title">
              <el-icon class="section-icon"><DataAnalysis /></el-icon>
              转化记录
              <span class="record-count">共 {{ customerDetail.camp_conversions.length }} 条</span>
            </h3>
            <el-table 
              :data="customerDetail.camp_conversions" 
              style="width: 100%" 
              border 
              stripe
              :header-cell-style="{ background: '#f5f7fa', color: '#606266', fontWeight: 'bold' }"
            >
              <el-table-column prop="camp_description" label="营期" min-width="180">
                <template #default="scope">
                  <div class="camp-info">
                    <span class="camp-name">{{ scope.row.camp_description }}</span>
                    <el-tooltip effect="dark" placement="top">
                      <template #content>
                        <div>开始: {{ formatDate(scope.row.camp_start_date) }}</div>
                        <div>结束: {{ formatDate(scope.row.camp_end_date) }}</div>
                      </template>
                      <el-tag size="small" type="info">ID: {{ scope.row.camp_id }}</el-tag>
                    </el-tooltip>
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="转化时间" min-width="150">
                <template #default="scope">
                  <div class="conversion-time">
                    {{ formatDate(scope.row.conversion_time) }}
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="推广大使" min-width="150">
                <template #default="scope">
                  <div class="promoter-info">
                    <span class="promoter-name">{{ scope.row.promoter_name }}</span>
                    <el-tag size="small" type="primary">ID: {{ scope.row.promoter_id }}</el-tag>
                  </div>
                </template>
              </el-table-column>
              <el-table-column prop="order_id" label="订单ID" width="100" align="center">
                <template #default="scope">
                  <el-tag type="warning">{{ scope.row.order_id }}</el-tag>
                </template>
              </el-table-column>
            </el-table>
          </div>

          <!-- 潜在客户状态提示 -->
          <div v-else-if="customerDetail.status === 'potential'" class="detail-section potential-customer-section">
            <div class="potential-customer-info">
              <el-icon class="info-icon"><InfoFilled /></el-icon>
              <div class="info-text">
                <h4>潜在客户</h4>
                <p>该客户尚未完成转化，可以通过推广大使进行进一步跟进。</p>
              </div>
            </div>
          </div>
        </template>
      </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="detailVisible = false">关闭</el-button>
          <el-button type="primary" @click="exportCustomerDetail" :disabled="!customerDetail">
            <el-icon><Download /></el-icon> 导出数据
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import AdminNavBar from '@/components/AdminNavBar.vue';
import { ref, reactive, onMounted, onBeforeUnmount, nextTick } from 'vue';
import { Search, Refresh, UserFilled, DataAnalysis, InfoFilled, Download, RefreshRight } from '@element-plus/icons-vue';
import { getCustomerList, getCustomerDetail, getCustomerStatistics } from '@/api/admin';
import { ElMessage } from 'element-plus';

// 客户列表数据
const customerList = ref([]);
const loading = ref(false);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);
const searchKeyword = ref('');
const sortField = ref('created_at');
const sortOrder = ref('desc');
const filterStatus = ref('');

// 客户统计数据
const statistics = reactive({
  total_customers: 0,
  potential_customers: 0,
  converted_customers: 0,
  new_customers_7days: 0,
  new_conversions_7days: 0
});
const statsLoading = ref(false);

// 客户详情数据
const customerDetail = ref(null);
const detailVisible = ref(false);
const detailLoading = ref(false);

// 状态标志，用于防止组件卸载后的调用
const isComponentMounted = ref(true);

// 全局刷新 - 同时刷新客户数据概览和客户列表数据
const refreshAllData = async () => {
  if (!isComponentMounted.value) return;
  
  // 避免重复调用
  if (loading.value || statsLoading.value) return;
  
  // 显示提示消息
  ElMessage.info('正在刷新所有数据...');
  
  // 同时加载两个数据源
  Promise.all([
    loadStatistics(),
    loadCustomers()
  ])
    .then(() => {
      ElMessage.success('数据刷新成功');
    })
    .catch(error => {
      console.error('刷新数据失败:', error);
      ElMessage.error('刷新数据失败，请稍后重试');
    });
};

// 加载客户列表数据
const loadCustomers = async () => {
  if (!isComponentMounted.value) return;
  
  loading.value = true;
  
  // 构建请求参数
  const params = {
    page: currentPage.value,
    size: pageSize.value,
    sort_field: sortField.value,
    sort_order: sortOrder.value
  };
  
  // 添加筛选条件
  if (searchKeyword.value && searchKeyword.value.trim() !== '') {
    params.keyword = searchKeyword.value.trim();
  }
  
  if (filterStatus.value) {
    params.status = filterStatus.value;
  }
  
  try {
    const response = await getCustomerList(params);
    
    if (!isComponentMounted.value) return;
    
    if (response && response.data) {
      const data = response.data;
      
      // 处理响应数据，支持多种可能的结构
      if (data.customers) {
        customerList.value = data.customers;
        total.value = data.total || 0;
        currentPage.value = data.current || currentPage.value;
      } else if (data.records) {
        customerList.value = data.records;
        total.value = data.total || 0;
        currentPage.value = data.current || currentPage.value;
      } else if (Array.isArray(data)) {
        customerList.value = data;
        total.value = data.length;
      } else {
        ElMessage.warning('API返回了成功状态，但数据结构不符合预期');
        customerList.value = [];
        total.value = 0;
      }
    } else {
      customerList.value = [];
      total.value = 0;
    }
  } catch (error) {
    console.error('获取客户列表失败:', error);
    if (isComponentMounted.value) {
      customerList.value = [];
      total.value = 0;
    }
  } finally {
    if (isComponentMounted.value) {
      loading.value = false;
    }
  }
};

// 加载客户统计数据
const loadStatistics = async () => {
  if (!isComponentMounted.value) return;
  
  statsLoading.value = true;
  
  try {
    const response = await getCustomerStatistics();
    
    if (!isComponentMounted.value) return;
    
    if (response && response.data) {
      Object.assign(statistics, response.data);
    }
  } catch (error) {
    console.error('获取客户统计数据失败:', error);
  } finally {
    if (isComponentMounted.value) {
      statsLoading.value = false;
    }
  }
};

// 查看客户详情
const handleViewDetails = async (row) => {
  if (!isComponentMounted.value) return;
  
  detailVisible.value = true;
  detailLoading.value = true;
  customerDetail.value = null;
  
  try {
    const response = await getCustomerDetail(row.id);
    
    if (!isComponentMounted.value) return;
    
    if (response && response.data) {
      customerDetail.value = response.data;
    } else {
      ElMessage.warning('获取客户详情失败，数据为空');
    }
  } catch (error) {
    console.error('获取客户详情失败:', error);
  } finally {
    if (isComponentMounted.value) {
      detailLoading.value = false;
    }
  }
};

// 分页和排序处理
const handleCurrentChange = (page) => {
  currentPage.value = page;
  loadCustomers();
};

const handleSizeChange = (size) => {
  pageSize.value = size;
  currentPage.value = 1; // 重置到第一页
  loadCustomers();
};

const handleSortChange = ({ prop, order }) => {
  if (prop) {
    sortField.value = prop;
    sortOrder.value = order === 'ascending' ? 'asc' : 'desc';
    loadCustomers();
  }
};

// 搜索和筛选处理
const handleSearch = () => {
  currentPage.value = 1; // 重置到第一页
  loadCustomers();
};

const handleFilterChange = () => {
  currentPage.value = 1; // 重置到第一页
  loadCustomers();
};

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '';
  
  try {
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) return ''; // 检查日期是否有效
    
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    
    return `${year}-${month}-${day} ${hours}:${minutes}`;
  } catch (error) {
    console.error('日期格式化错误:', error);
    return '';
  }
};

// 导出客户详情数据
const exportCustomerDetail = () => {
  if (!customerDetail.value) return;
  
  try {
    const customer = customerDetail.value;
    
    // 构建导出数据
    const data = {
      基本信息: {
        客户ID: customer.id,
        客户姓名: customer.name,
        联系电话: customer.phone || '未设置',
        电子邮箱: customer.email || '未设置',
        客户状态: customer.status === 'converted' ? '已转化' : '潜在客户',
        创建时间: formatDate(customer.created_at),
        更新时间: formatDate(customer.updated_at)
      }
    };
    
    // 如果有转化记录，添加到导出数据中
    if (customer.status === 'converted' && customer.camp_conversions && customer.camp_conversions.length > 0) {
      data.转化记录 = customer.camp_conversions.map((record, index) => ({
        序号: index + 1,
        营期: record.camp_description,
        营期ID: record.camp_id,
        转化时间: formatDate(record.conversion_time),
        推广大使: record.promoter_name,
        推广大使ID: record.promoter_id,
        订单ID: record.order_id
      }));
    }
    
    // 将数据转换为JSON字符串
    const jsonString = JSON.stringify(data, null, 2);
    
    // 创建Blob对象
    const blob = new Blob([jsonString], { type: 'application/json' });
    
    // 创建URL
    const url = URL.createObjectURL(blob);
    
    // 创建下载链接
    const link = document.createElement('a');
    link.href = url;
    link.download = `客户详情_${customer.id}_${customer.name}.json`;
    
    // 触发下载
    document.body.appendChild(link);
    link.click();
    
    // 清理
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
    
    ElMessage.success('客户详情数据导出成功');
  } catch (error) {
    console.error('导出客户详情失败:', error);
    ElMessage.error('导出客户详情失败');
  }
};

// 页面加载时执行
onMounted(() => {
  isComponentMounted.value = true;
  nextTick(() => {
    refreshAllData(); // 使用合并的刷新函数替代单独调用
  });
});

// 组件卸载前调用
onBeforeUnmount(() => {
  isComponentMounted.value = false;
});
</script>

<style scoped>
.customer-data {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f7fa;
}

.content-container {
  padding: 20px;
  margin-top: 10px;
}

/* 页面标题和全局刷新按钮 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-title {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
  margin: 0;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}

/* 全局刷新按钮样式 */
.global-refresh-btn {
  transition: all 0.4s ease;
  box-shadow: 0 2px 10px rgba(64, 158, 255, 0.4);
  width: 56px !important;
  height: 56px !important;
  background: linear-gradient(145deg, #409EFF, #53a8ff) !important;
  border: none !important;
  margin-left: 15px;
}

.global-refresh-btn:hover:not(:disabled) {
  transform: rotate(180deg) scale(1.05);
  box-shadow: 0 5px 15px rgba(64, 158, 255, 0.7);
  background: linear-gradient(145deg, #53a8ff, #409EFF) !important;
}

.global-refresh-btn:active:not(:disabled) {
  transform: rotate(180deg) scale(0.95);
}

.global-refresh-btn:not(:disabled):not(.is-loading) {
  animation: global-pulse 2.5s infinite;
}

/* 添加加载动画效果 */
.global-refresh-btn.is-loading {
  background: linear-gradient(145deg, #67a3e0, #5a95d8) !important;
  animation: none;
  opacity: 0.9;
}

.global-refresh-btn :deep(.is-loading) {
  animation: rotate 1s linear infinite;
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes global-pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(64, 158, 255, 0.5);
  }
  70% {
    box-shadow: 0 0 0 12px rgba(64, 158, 255, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(64, 158, 255, 0);
  }
}

.customer-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* 客户数据统计卡片样式 */
.customer-stats-card {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.stats-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.stats-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 12px;
}

.stats-header h3:before {
  content: '';
  position: absolute;
  left: 0;
  top: 4px;
  height: 16px;
  width: 4px;
  background: linear-gradient(to bottom, #409EFF, #1677FF);
  border-radius: 2px;
}

.stats-content {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 10px;
}

.stats-item {
  flex: 1;
  min-width: 150px;
  background-color: #f8f9fb;
  border-radius: 8px;
  padding: 15px;
  text-align: center;
  transition: all 0.3s;
}

.stats-item:hover {
  background-color: #ecf5ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.stats-value {
  font-size: 24px;
  font-weight: bold;
  color: #409EFF;
  margin-bottom: 5px;
}

.stats-label {
  font-size: 14px;
  color: #606266;
}

/* 客户列表卡片样式 */
.customer-list-card {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.title-section h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 12px;
}

.title-section h3:before {
  content: '';
  position: absolute;
  left: 0;
  top: 4px;
  height: 16px;
  width: 4px;
  background: linear-gradient(to bottom, #409EFF, #1677FF);
  border-radius: 2px;
}

.header-actions {
  display: flex;
  justify-content: flex-end;
}

.filter-search-bar {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  margin-bottom: 20px;
  padding-right: 8px;
}

.search-area {
  display: flex;
  align-items: center;
  gap: 15px;
}

.search-box {
  width: 300px;
}

.filter-options {
  width: 180px;
}

.filter-options :deep(.el-input__wrapper) {
  border-radius: 4px;
}

.pagination-area {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.action-buttons-group {
  display: flex;
  gap: 5px;
}

/* 客户详情样式 */
.detail-container {
  padding: 10px;
}

.detail-section {
  margin-bottom: 20px;
}

.detail-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 15px;
  color: #303133;
  position: relative;
  padding-left: 10px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.detail-title:before {
  content: '';
  position: absolute;
  left: 0;
  top: 4px;
  height: 14px;
  width: 3px;
  background: #409EFF;
  border-radius: 2px;
}

.section-icon {
  font-size: 18px;
  color: #409EFF;
}

.record-count {
  font-size: 14px;
  font-weight: normal;
  color: #909399;
  margin-left: 10px;
}

.label-bold {
  font-weight: bold !important;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.status-tag {
  margin-right: 10px;
}

.customer-id {
  font-size: 14px;
  color: #606266;
}

.id-value {
  font-weight: bold;
}

.customer-descriptions {
  margin-bottom: 20px;
}

.customer-name {
  font-weight: bold;
}

.conversion-time {
  font-size: 14px;
  color: #606266;
}

.camp-info {
  display: flex;
  align-items: center;
}

.camp-name {
  margin-right: 10px;
}

.promoter-info {
  display: flex;
  align-items: center;
}

.promoter-name {
  margin-right: 10px;
}

.potential-customer-section {
  text-align: center;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.potential-customer-info {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.info-icon {
  font-size: 24px;
  margin-bottom: 10px;
}

.info-text {
  text-align: center;
}

.info-text h4 {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 10px;
}

.info-text p {
  font-size: 14px;
  color: #606266;
}

.customer-detail-dialog .el-dialog__body {
  padding: 20px;
}
</style> 