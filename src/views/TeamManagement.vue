<template>
  <div class="team-management-container">
    <!-- 使用公共导航栏组件 -->
    <LeaderNavBar activePage="team" />

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 页面标题 -->
      <div class="page-header">
        <div class="page-title-wrapper">
          <h2 class="page-title">{{ teamStats.teamName || '团队管理' }}</h2>
          <div class="team-leader" v-if="teamStats.leaderName">
            <el-tag type="warning" effect="dark">团队负责人: {{ teamStats.leaderName }}</el-tag>
          </div>
        </div>
        <div class="page-actions">
          <el-tooltip content="刷新数据" placement="top">
            <el-button 
              type="primary" 
              circle 
              @click="refreshData" 
              :loading="loading"
              class="action-btn">
              <el-icon><Refresh /></el-icon>
            </el-button>
          </el-tooltip>
          <el-tooltip content="添加成员" placement="top">
            <el-button 
              type="success" 
              circle 
              @click="showAddMemberDialog"
              class="action-btn">
              <el-icon><Plus /></el-icon>
            </el-button>
          </el-tooltip>
        </div>
      </div>

      <!-- 团队概览和营期选择区域 -->
      <div class="metrics-container">
        <!-- 营期选择器 -->
        <div class="metric-item camp-selector-item">
          <div class="camp-period-title">当前营期</div>
          <div class="camp-selector-value">
            <div class="selector-controls">
              <el-tooltip content="上一个营期" placement="top">
                <el-button 
                  class="selector-btn" 
                  type="primary" 
                  circle
                  @click="changeCampPeriod(-1)" 
                  :disabled="loading">
                  <el-icon><ArrowLeft /></el-icon>
                </el-button>
              </el-tooltip>
              <div class="selector-value">{{ currentCampId }}</div>
              <el-tooltip content="下一个营期" placement="top">
                <el-button 
                  class="selector-btn" 
                  type="primary" 
                  circle
                  @click="changeCampPeriod(1)" 
                  :disabled="loading">
                  <el-icon><ArrowRight /></el-icon>
                </el-button>
              </el-tooltip>
            </div>
          </div>
        </div>
        
        <div class="metric-item">
          <div class="metric-circle members-circle">
            <div class="metric-label">团队成员</div>
          </div>
          <div class="metric-value members-value">{{ teamStats.memberCount }}</div>
        </div>
        
        <div class="metric-item">
          <div class="metric-circle conversions-circle">
            <div class="metric-label">总转化数</div>
          </div>
          <div class="metric-value conversions-value">{{ teamStats.conversionCount }}</div>
        </div>
        
        <div class="metric-item">
          <div class="metric-circle commission-circle">
            <div class="metric-label">团队佣金</div>
          </div>
          <div class="metric-value commission-value">¥{{ formatAmount(teamStats.totalCommission) }}</div>
        </div>
      </div>

      <!-- 团队成员表格 -->
      <div class="team-members-section">
        <div class="section-header">
          <h3 class="section-title">团队成员</h3>
          <div class="search-area">
            <el-input
              v-model="searchQuery"
              placeholder="搜索成员..."
              class="search-input"
              clearable>
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
          </div>
        </div>
        
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-container">
          <el-skeleton :rows="5" animated />
        </div>
        
        <!-- 数据表格 -->
        <div v-else class="table-container">
          <el-table 
            :data="filteredTableData" 
            style="width: 100%"
            stripe
            v-loading="tableLoading"
            class="member-table"
            highlight-current-row>
            <el-table-column prop="user_id" label="ID" width="80" align="center" />
            <el-table-column prop="username" label="用户名" min-width="180" align="left" />
            <el-table-column prop="conversionCount" label="转化数量" width="120" align="center" sortable />
            <el-table-column prop="commission" label="佣金金额" width="150" align="right" sortable>
              <template #default="scope">
                <span class="commission-text">¥{{ formatAmount(scope.row.commission) }}</span>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="120" align="center">
              <template #default="scope">
                <el-tooltip content="查看佣金明细" placement="top">
                  <el-button 
                    type="primary" 
                    circle
                    size="small"
                    @click="viewMemberCommission(scope.row)">
                    <el-icon><Money /></el-icon>
                  </el-button>
                </el-tooltip>
                <el-tooltip content="移除成员" placement="top">
                  <el-button 
                    type="danger" 
                    circle
                    size="small"
                    @click="removeTeamMember(scope.row)">
                    <el-icon><Delete /></el-icon>
                  </el-button>
                </el-tooltip>
              </template>
            </el-table-column>
          </el-table>
        </div>
        
        <!-- 分页组件 -->
        <div class="pagination-container">
          <el-pagination
            v-if="!loading && tableData.length > 0"
            @size-change="handleSizeChange"
            @current-change="handleCurrentChange"
            :current-page="currentPage"
            :page-sizes="[10, 20, 50, 100]"
            :page-size="pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="tableData.length"
            background
          >
          </el-pagination>
        </div>
      </div>
    </div>
    
    <!-- 添加成员对话框 -->
    <el-dialog
      v-model="addMemberDialogVisible"
      title="添加团队成员"
      width="500px"
      :close-on-click-modal="false"
      custom-class="custom-dialog"
    >
      <el-form 
        ref="addMemberFormRef" 
        :model="addMemberForm" 
        :rules="addMemberRules" 
        label-width="100px"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="addMemberForm.username" placeholder="请输入用户名">
            <template #prefix><el-icon><User /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="addMemberForm.email" placeholder="请输入邮箱">
            <template #prefix><el-icon><Message /></el-icon></template>
          </el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="addMemberForm.phone" placeholder="请输入手机号">
            <template #prefix><el-icon><Phone /></el-icon></template>
          </el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addMemberDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitAddMember" :loading="submitLoading">
            确认添加
          </el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 成员详情对话框 -->
    <el-dialog
      v-model="memberDetailDialogVisible"
      title="成员详情"
      width="600px"
      custom-class="custom-dialog"
    >
      <div v-if="selectedMember" class="member-detail">
        <div class="member-header">
          <div class="member-info">
            <h3 class="member-name">{{ selectedMember.username }}</h3>
            <p class="member-id">ID: {{ selectedMember.user_id }}</p>
          </div>
        </div>
        
        <div class="detail-section">
          <h4 class="detail-title">业绩统计</h4>
          <div class="performance-stats">
            <div class="performance-item">
              <div class="performance-icon">
                <i class="el-icon-s-data"></i>
              </div>
              <div class="performance-value">{{ selectedMember.conversionCount }}</div>
              <div class="performance-label">转化数量</div>
            </div>
            <div class="performance-item">
              <div class="performance-icon">
                <i class="el-icon-money"></i>
              </div>
              <div class="performance-value">¥{{ formatAmount(selectedMember.commission) }}</div>
              <div class="performance-label">佣金金额</div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 成员佣金明细对话框 -->
    <el-dialog
      v-model="memberCommissionDialogVisible"
      :title="`${selectedMember?.username || '成员'} 的佣金明细`"
      width="900px"
      custom-class="commission-dialog"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <div v-if="selectedMember" class="commission-header">
        <div class="commission-info">
          <div class="info-row">
            <span class="info-label"><i class="el-icon-user"></i> 成员ID:</span>
            <span class="info-value">{{ memberCommissionData.userId }}</span>
          </div>
          <div class="info-row">
            <span class="info-label"><i class="el-icon-user"></i> 成员姓名:</span>
            <span class="info-value">{{ memberCommissionData.username }}</span>
          </div>
          <div class="info-row">
            <span class="info-label"><i class="el-icon-date"></i> 营期:</span>
            <span class="info-value">{{ memberCommissionData.campName || `营期${currentCampId}` }}</span>
          </div>
          <div class="info-row" v-if="memberCommissionData.startDate && memberCommissionData.endDate">
            <span class="info-label"><i class="el-icon-date"></i> 营期时间:</span>
            <span class="info-value">
              {{ formatDate(memberCommissionData.startDate) }} 至 {{ formatDate(memberCommissionData.endDate) }}
            </span>
          </div>
        </div>
        <div class="commission-stats">
          <div class="stat-box commission-box">
            <div class="stat-content">
              <div class="stat-value">¥{{ formatAmount(memberCommissionData.totalCommission) }}</div>
              <div class="stat-label">佣金总额</div>
            </div>
          </div>
          <div class="stat-box conversion-box">
            <div class="stat-content">
              <div class="stat-value">{{ memberCommissionData.conversionCount }}</div>
              <div class="stat-label">转化数量</div>
            </div>
          </div>
        </div>
      </div>
      
      <div v-if="memberCommissionLoading" class="loading-container">
        <el-skeleton :rows="5" animated />
      </div>
      
      <div v-else-if="memberCommissionData.details && memberCommissionData.details.length > 0" class="commission-table-wrapper">
        <el-table 
          :data="memberCommissionData.details" 
          style="width: 100%" 
          border 
          stripe
          max-height="400"
          class="commission-table"
          row-class-name="commission-table-row"
          header-row-class-name="commission-table-header"
        >
          <el-table-column prop="commission_id" label="ID" width="80" align="center" />
          <el-table-column label="佣金类型" width="150" align="center">
            <template #default="scope">
              <el-tag :type="getCommissionTypeTag(scope.row.commission_type)" effect="light">
                {{ getCommissionTypeLabel(scope.row.commission_type) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="相关信息" min-width="180">
            <template #default="scope">
              <div v-if="scope.row.order_id" class="info-item">
                <span class="info-key"><i class="el-icon-s-order"></i> 订单ID:</span> 
                <span class="info-value">{{ scope.row.order_id }}</span>
              </div>
              <div v-if="scope.row.customer_id" class="info-item">
                <span class="info-key"><i class="el-icon-user"></i> 客户ID:</span> 
                <span class="info-value">{{ scope.row.customer_id }}</span>
              </div>
              <div v-if="scope.row.tier" class="info-item">
                <span class="info-key"><i class="el-icon-medal"></i> 佣金层级:</span> 
                <span class="info-value">{{ getTierLabel(scope.row.tier) }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="commission_amount" label="佣金金额" width="120" align="right">
            <template #default="scope">
              <span class="commission-amount">¥{{ formatAmount(scope.row.commission_amount) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="created_time" label="创建时间" width="170" align="center">
            <template #default="scope">
              {{ formatDateTime(scope.row.created_time) }}
            </template>
          </el-table-column>
        </el-table>
      </div>
      
      <div v-else class="empty-data">
        <el-empty description="暂无佣金明细数据" />
      </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="memberCommissionDialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import { getTeamOverview, getTeamMembers, removeTeamMember, addTeamMember, getMemberCommissions } from '@/api/leader';
import LeaderNavBar from '@/components/LeaderNavBar.vue';
import { 
  Refresh, 
  Plus, 
  ArrowLeft, 
  ArrowRight, 
  Search, 
  Money, 
  Delete, 
  User, 
  Message, 
  Phone 
} from '@element-plus/icons-vue';

// 路由
const router = useRouter();

// 数据加载状态
const loading = ref(true);
const tableLoading = ref(false);
const submitLoading = ref(false);
const memberCommissionLoading = ref(false);

// 分页相关
const currentPage = ref(1);
const pageSize = ref(10);

// 搜索查询
const searchQuery = ref('');

// 对话框控制
const addMemberDialogVisible = ref(false);
const memberDetailDialogVisible = ref(false);
const memberCommissionDialogVisible = ref(false);

// 当前营期ID
const currentCampId = ref(1001);

// 团队统计
const teamStats = reactive({
  teamId: '',
  teamName: '',
  memberCount: 0,
  conversionCount: 0,
  totalCommission: 0,
  leaderId: '',
  leaderName: ''
});

// 表单引用
const addMemberFormRef = ref(null);

// 添加成员表单数据
const addMemberForm = reactive({
  username: '',
  email: '',
  phone: ''
});

// 表单验证规则
const addMemberRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ]
};

// 选中的成员
const selectedMember = ref(null);

// 团队成员数据
const tableData = ref([]);

// 成员佣金明细数据
const memberCommissionData = reactive({
  userId: '',
  username: '',
  totalCommission: 0,
  conversionCount: 0,
  campId: '',
  campName: '',
  startDate: '',
  endDate: '',
  details: []
});

// 过滤后的表格数据
const filteredTableData = computed(() => {
  if (!searchQuery.value) {
    return tableData.value;
  }
  
  const query = searchQuery.value.toLowerCase();
  return tableData.value.filter(row => {
    return row.username.toLowerCase().includes(query) || 
           row.user_id.toString().includes(query) ||
           (row.email && row.email.toLowerCase().includes(query)) ||
           (row.phone && row.phone.includes(query));
  });
});

// 格式化金额
const formatAmount = (amount) => {
  if (amount === undefined || amount === null) return '0.00';
  return Number(amount).toFixed(2);
};

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '暂无数据';
  const date = new Date(dateStr);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
};

// 获取状态标签样式
const getStatusType = (status) => {
  const typeMap = {
    'active': 'success',
    'pending': 'warning',
    'inactive': 'info'
  };
  return typeMap[status] || 'info';
};

// 获取状态标签文本
const getStatusLabel = (status) => {
  const labelMap = {
    'active': '活跃',
    'pending': '待审核',
    'inactive': '不活跃'
  };
  return labelMap[status] || '未知';
};

// 获取团队总览数据
const fetchTeamOverview = async () => {
  loading.value = true;
  try {
    const response = await getTeamOverview(currentCampId.value);
    if (response.code === 1) {
      // 更新团队统计信息
      teamStats.teamId = response.data.team_id;
      teamStats.teamName = response.data.team_name;
      teamStats.memberCount = response.data.member_count;
      teamStats.conversionCount = response.data.success_count;
      teamStats.totalCommission = response.data.total_commission;
      teamStats.leaderId = response.data.leader_id;
      teamStats.leaderName = response.data.leader_name;
    } else {
      ElMessage.warning(response.msg || '获取团队总览信息失败');
    }
  } catch (error) {
    console.error('获取团队总览信息失败:', error);
    ElMessage.error('获取团队总览信息失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 获取团队成员数据
const fetchTeamMembers = async () => {
  tableLoading.value = true;
  try {
    const response = await getTeamMembers(currentCampId.value);
    if (response.code === 1) {
      // 将API返回的数据映射到表格所需的格式
      tableData.value = response.data.map(member => ({
        id: member.user_id,
        user_id: member.user_id,
        username: member.username,
        // 假设加入时间是当前时间，API中没有提供
        joinTime: new Date().toISOString(),
        conversionCount: member.success_count,
        commission: member.total_commission,
        // 默认设置为活跃状态，API中没有提供
        status: 'active',
        // 以下字段API中没有，但UI需要
        phone: '',
        email: '',
        rank: 0
      }));
    } else {
      ElMessage.warning(response.msg || '获取团队成员失败');
    }
  } catch (error) {
    console.error('获取团队成员失败:', error);
    ElMessage.error('获取团队成员失败，请稍后重试');
  } finally {
    tableLoading.value = false;
  }
};

// 处理页码变化
const handleCurrentChange = (val) => {
  currentPage.value = val;
};

// 处理每页条数变化
const handleSizeChange = (val) => {
  pageSize.value = val;
  currentPage.value = 1;
};

// 跳转到大使长仪表盘
const goToLeaderDashboard = () => {
  router.push('/leader-dashboard');
};

// 刷新数据
const refreshData = () => {
  fetchTeamOverview();
  fetchTeamMembers();
};

// 显示添加成员对话框
const showAddMemberDialog = () => {
  addMemberForm.username = '';
  addMemberForm.email = '';
  addMemberForm.phone = '';
  addMemberDialogVisible.value = true;
};

// 提交添加成员
const submitAddMember = () => {
  addMemberFormRef.value.validate(async (valid) => {
    if (!valid) return;
    
    submitLoading.value = true;
    try {
      // API接口待完善
      // const response = await addTeamMember(addMemberForm);
      // if (response.code === 1) {
      //   ElMessage.success('添加成员成功');
      //   addMemberDialogVisible.value = false;
      //   fetchTeamMembers();
      // } else {
      //   ElMessage.warning(response.msg || '添加成员失败');
      // }
      
      // 模拟成功响应
      await new Promise(resolve => setTimeout(resolve, 1000));
      ElMessage.success('添加成员功能开发中...');
      addMemberDialogVisible.value = false;
    } catch (error) {
      console.error('添加成员失败:', error);
      ElMessage.error('添加成员失败，请稍后重试');
    } finally {
      submitLoading.value = false;
    }
  });
};

// 查看成员详情
const viewMemberDetail = (member) => {
  selectedMember.value = member;
  memberDetailDialogVisible.value = true;
};

// 处理移除成员
const handleRemoveMember = (member) => {
  ElMessageBox.confirm(
    `确定要将 ${member.username} 从团队中移除吗？`,
    '移除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    tableLoading.value = true;
    try {
      // API接口待完善
      // const response = await removeTeamMember(member.id);
      // if (response.code === 1) {
      //   ElMessage.success('移除成员成功');
      //   fetchTeamMembers();
      // } else {
      //   ElMessage.warning(response.msg || '移除成员失败');
      // }
      
      // 模拟成功响应
      await new Promise(resolve => setTimeout(resolve, 1000));
      ElMessage.success('移除成员功能开发中...');
    } catch (error) {
      console.error('移除成员失败:', error);
      ElMessage.error('移除成员失败，请稍后重试');
    } finally {
      tableLoading.value = false;
    }
  }).catch(() => {});
};

// 切换营期
const changeCampPeriod = (step) => {
  const newCampId = currentCampId.value + step;
  // 确保营期ID不小于1000
  if (newCampId >= 1000) {
    currentCampId.value = newCampId;
    refreshData();
  }
};

// 获取成员佣金明细
const fetchMemberCommissions = async (memberId) => {
  memberCommissionLoading.value = true;
  try {
    const response = await getMemberCommissions(currentCampId.value, memberId);
    if (response.code === 1) {
      memberCommissionData.userId = response.data.user_id;
      memberCommissionData.username = response.data.username;
      memberCommissionData.totalCommission = response.data.total_commission;
      memberCommissionData.conversionCount = response.data.conversion_count;
      memberCommissionData.campId = response.data.camp_id;
      memberCommissionData.campName = response.data.camp_name;
      memberCommissionData.startDate = response.data.start_date;
      memberCommissionData.endDate = response.data.end_date;
      memberCommissionData.details = response.data.details || [];
    } else {
      ElMessage.warning(response.msg || '获取成员佣金明细失败');
    }
  } catch (error) {
    console.error('获取成员佣金明细失败:', error);
    ElMessage.error('获取成员佣金明细失败，请稍后重试');
  } finally {
    memberCommissionLoading.value = false;
  }
};

// 查看成员佣金明细
const viewMemberCommission = (member) => {
  selectedMember.value = member;
  memberCommissionDialogVisible.value = true;
  fetchMemberCommissions(member.user_id);
};

// 获取佣金类型标签
const getCommissionTypeTag = (type) => {
  const tagMap = {
    'ambassador_conversion': 'success',
    'leader_team_conversion': 'primary'
  };
  return tagMap[type] || 'info';
};

// 获取佣金类型文本
const getCommissionTypeLabel = (type) => {
  const labelMap = {
    'ambassador_conversion': '直接推广佣金',
    'leader_team_conversion': '团队推广佣金'
  };
  return labelMap[type] || '未知类型';
};

// 获取层级标签
const getTierLabel = (tier) => {
  const tierMap = {
    'junior': '初级',
    'intermediate': '中级',
    'senior': '高级'
  };
  return tierMap[tier] || tier;
};

// 格式化日期时间
const formatDateTime = (dateStr) => {
  if (!dateStr) return '暂无数据';
  const date = new Date(dateStr);
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;
};

// 生命周期钩子
onMounted(() => {
  fetchTeamOverview();
  fetchTeamMembers();
});

</script>

<style scoped>
.team-management-container {
  min-height: 100vh;
  background-color: #f5f7fa;
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
  margin-bottom: 24px;
}

.page-title {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin: 0;
}

.page-title-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
}

.team-leader :deep(.el-tag) {
  margin-left: 12px;
}

.page-actions {
  display: flex;
  gap: 12px;
}

.action-btn {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

/* 概览部分样式 */
.metrics-container {
  display: flex;
  justify-content: space-around;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 40px 30px;
  margin-bottom: 24px;
}

/* 营期选择器样式 */
.camp-selector-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
  width: 22%;
}

.camp-period-title {
  font-size: 18px;
  font-weight: 600;
  color: #409EFF;
  height: 90px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.camp-period-title::after {
  content: '';
  position: absolute;
  bottom: 22px;
  left: 50%;
  transform: translateX(-50%);
  width: 30px;
  height: 3px;
  background-color: #409EFF;
  border-radius: 2px;
}

.camp-selector-value {
  display: flex;
  align-items: center;
}

.selector-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.selector-value {
  font-size: 32px;
  font-weight: 700;
  color: #409EFF;
  min-width: 80px;
  text-align: center;
  line-height: 1;
  margin: 0 12px;
}

.selector-btn {
  box-shadow: 0 2px 8px 0 rgba(0, 0, 0, 0.1);
  transform: scale(0.9);
  transition: all 0.3s;
}

.selector-btn:hover {
  transform: scale(1);
  box-shadow: 0 4px 12px 0 rgba(64, 158, 255, 0.3);
}

.metric-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  width: 22%;
}

.metric-circle {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s;
}

.metric-circle:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
}

.members-circle {
  background-color: #409EFF;
}

.conversions-circle {
  background-color: #67C23A;
}

.commission-circle {
  background-color: #E6A23C;
}

.metric-label {
  color: white;
  font-size: 14px;
  font-weight: 500;
  text-align: center;
  padding: 0 5px;
}

.metric-value {
  font-weight: 700;
  line-height: 1;
  text-align: center;
}

.members-value {
  font-size: 32px;
  color: #409EFF;
}

.conversions-value {
  font-size: 32px;
  color: #67C23A;
}

.commission-value {
  font-size: 28px;
  color: #E6A23C;
}

/* 团队成员部分样式 */
.team-members-section {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  margin: 0;
}

.search-area {
  display: flex;
  align-items: center;
}

.search-input {
  width: 250px;
}

.table-container {
  margin-bottom: 20px;
}

.member-table {
  border-radius: 8px;
  overflow: hidden;
}

.commission-text {
  color: #E6A23C;
  font-weight: 600;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.loading-container {
  padding: 40px 0;
}

.custom-dialog :deep(.el-dialog__body) {
  padding-top: 10px;
}

/* 响应式调整 */
@media (max-width: 768px) {
  .metrics-container {
    flex-direction: row;
    flex-wrap: wrap;
    gap: 20px;
    padding: 30px 20px;
  }
  
  .metric-item {
    width: 45%;
  }
  
  .camp-selector-item {
    width: 100%;
    margin-bottom: 20px;
    order: -1;
  }
  
  .camp-period-title {
    height: 80px;
    font-size: 17px;
  }
  
  .camp-period-title::after {
    bottom: 18px;
    width: 28px;
    height: 3px;
  }
  
  .metric-circle {
    width: 80px;
    height: 80px;
  }
  
  .metric-label {
    font-size: 13px;
  }
  
  .selector-value {
    font-size: 28px;
  }
}

@media (max-width: 576px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .page-title-wrapper {
    margin-bottom: 15px;
  }
  
  .metrics-container {
    flex-direction: column;
    align-items: center;
    padding: 25px 15px;
  }
  
  .metric-item, .camp-selector-item {
    width: 100%;
    margin-bottom: 20px;
  }
  
  .camp-period-title {
    height: 70px;
    font-size: 15px;
  }
  
  .camp-period-title::after {
    bottom: 18px;
    width: 28px;
    height: 3px;
  }
  
  .metric-circle {
    width: 70px;
    height: 70px;
  }
  
  .metric-label {
    font-size: 12px;
  }
  
  .selector-controls {
    justify-content: center;
  }
  
  .selector-value {
    font-size: 26px;
  }
}
</style> 