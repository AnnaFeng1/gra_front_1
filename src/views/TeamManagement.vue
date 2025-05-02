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
          <el-button-group>
            <el-button type="primary" @click="refreshData" :loading="loading">
              <i class="el-icon-refresh"></i> 刷新数据
            </el-button>
            <el-button type="success" @click="showAddMemberDialog">
              <i class="el-icon-plus"></i> 添加成员
            </el-button>
          </el-button-group>
        </div>
      </div>

      <!-- 营期选择器与数据概览卡片区域 -->
      <div class="top-cards-row">
        <!-- 营期选择器卡片 -->
        <el-card class="camp-selector-card">
          <div class="camp-selector">
            <div class="camp-selector-content">
              <div class="camp-selector-title">当前营期ID</div>
              <div class="camp-period-switcher">
                <button 
                  class="switcher-btn prev-btn" 
                  @click="changeCampPeriod(-1)" 
                  :disabled="loading"
                  title="减少营期ID"
                >
                  <span class="btn-text">-</span>
                </button>
                <div class="camp-period-value">{{ currentCampId }}</div>
                <button 
                  class="switcher-btn next-btn" 
                  @click="changeCampPeriod(1)" 
                  :disabled="loading"
                  title="增加营期ID"
                >
                  <span class="btn-text">+</span>
                </button>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 团队统计卡片 -->
        <el-card class="stats-card">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-data-analysis"></i> 团队概览</span>
            </div>
          </template>
          <div class="stats-wrapper">
            <div class="stat-box">
              <div class="stat-icon member-icon">
                <i class="el-icon-s-custom"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ teamStats.memberCount }}</div>
                <div class="stat-label">团队成员</div>
              </div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-box">
              <div class="stat-icon conversion-icon">
                <i class="el-icon-s-data"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value">{{ teamStats.conversionCount }}</div>
                <div class="stat-label">总转化数</div>
              </div>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-box">
              <div class="stat-icon commission-icon">
                <i class="el-icon-money"></i>
              </div>
              <div class="stat-info">
                <div class="stat-value commission-value">¥{{ formatAmount(teamStats.totalCommission) }}</div>
                <div class="stat-label">团队佣金</div>
              </div>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 团队成员表格 -->
      <el-card class="team-table-card">
        <template #header>
          <div class="card-header">
            <span><i class="el-icon-user"></i> 团队成员</span>
            <div class="table-actions">
              <el-input
                v-model="searchQuery"
                placeholder="搜索成员..."
                prefix-icon="el-icon-search"
                clearable
                class="search-input"
              />
            </div>
          </div>
        </template>
        
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-container">
          <el-skeleton :rows="5" animated />
        </div>
        
        <!-- 数据表格 -->
        <div v-else class="table-container">
          <el-table 
            :data="filteredTableData" 
            style="width: 100%"
            :border="false"
            stripe
            v-loading="tableLoading"
            row-class-name="member-table-row"
            header-row-class-name="member-table-header"
            cell-class-name="member-table-cell"
            class="member-table"
            highlight-current-row>
            <el-table-column prop="user_id" label="ID" width="100" align="center">
              <template #default="scope">
                <span class="id-cell">{{ scope.row.user_id }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="username" label="用户名" min-width="220" align="left">
              <template #default="scope">
                <div class="member-name-cell">
                  <span class="member-name">{{ scope.row.username }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="conversionCount" label="转化数量" min-width="180" align="center" sortable>
              <template #default="scope">
                <div class="conversion-cell">
                  <span class="conversion-number">{{ scope.row.conversionCount }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="commission" label="佣金金额" min-width="220" align="right" sortable>
              <template #default="scope">
                <div class="commission-cell">
                  <span class="commission-text">¥{{ formatAmount(scope.row.commission) }}</span>
                  <el-tooltip content="查看佣金明细" placement="top" effect="light">
                    <el-button 
                      type="primary" 
                      size="small" 
                      class="commission-btn"
                      @click.stop="viewMemberCommission(scope.row)"
                      icon="el-icon-more"
                      circle
                    ></el-button>
                  </el-tooltip>
                </div>
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
      </el-card>
    </div>
    
    <!-- 添加成员对话框 -->
    <el-dialog
      v-model="addMemberDialogVisible"
      title="添加团队成员"
      width="500px"
      :close-on-click-modal="false"
      custom-class="custom-dialog"
    >
      <div class="dialog-icon">
        <i class="el-icon-plus"></i>
      </div>
      <el-form 
        ref="addMemberFormRef" 
        :model="addMemberForm" 
        :rules="addMemberRules" 
        label-width="100px"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="addMemberForm.username" placeholder="请输入用户名">
            <template #prefix><i class="el-icon-user"></i></template>
          </el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="addMemberForm.email" placeholder="请输入邮箱">
            <template #prefix><i class="el-icon-message"></i></template>
          </el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="addMemberForm.phone" placeholder="请输入手机号">
            <template #prefix><i class="el-icon-mobile-phone"></i></template>
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
import { ref, reactive, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import { getTeamOverview, getTeamMembers, removeTeamMember, addTeamMember, getMemberCommissions } from '@/api/leader';
import LeaderNavBar from '@/components/LeaderNavBar.vue';

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
/* 全局变量 */
:root {
  --primary-color: #409EFF;
  --warning-color: #E6A23C;
  --success-color: #67C23A;
  --danger-color: #F56C6C;
  --text-color: #2c3e50;
  --border-color: #dcdfe6;
  --background-color: #f5f9fc;
}

.team-management-container {
  min-height: 100vh;
  background-color: var(--background-color);
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
  margin-bottom: 24px;
  background: linear-gradient(to right, rgba(255,255,255,0.7), rgba(255,255,255,0.9));
  padding: 16px 20px;
  border-radius: 10px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  backdrop-filter: blur(5px);
}

.page-title-wrapper {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.page-title {
  font-size: 26px;
  color: var(--text-color);
  margin: 0;
  font-weight: 600;
  position: relative;
}

.page-title::after {
  content: '';
  position: absolute;
  bottom: -4px;
  left: 0;
  width: 40px;
  height: 3px;
  background: var(--primary-color);
  border-radius: 3px;
}

.team-leader {
  margin-top: 2px;
}

.page-actions {
  display: flex;
  gap: 10px;
}

.top-cards-row {
  display: flex;
  gap: 24px;
  margin-bottom: 10px;
}

.camp-selector-card {
  flex: 0 0 260px;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  border: none;
  transition: all 0.3s ease;
  overflow: hidden;
  background: linear-gradient(135deg, #ffffff, #f7faff);
}

.camp-selector-card:hover {
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.07);
  transform: translateY(-2px);
}

.camp-selector {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.camp-selector-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
}

.camp-selector-title {
  font-weight: 600;
  color: var(--text-color);
  font-size: 16px;
  text-align: center;
}

.camp-period-switcher {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
}

.switcher-btn {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: #4080ff;
  color: white;
  border: none;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  font-size: 18px;
  transition: all 0.2s ease;
  position: relative;
}

.btn-text {
  font-size: 24px;
  font-weight: bold;
}

.switcher-btn:hover {
  background: #3373e5;
  transform: scale(1.05);
}

.switcher-btn:active {
  transform: scale(0.98);
}

.switcher-btn:disabled {
  background: #a0b4e0;
  cursor: not-allowed;
  opacity: 0.7;
}

.camp-period-value {
  font-size: 20px;
  font-weight: 600;
  color: #333;
  padding: 0 20px;
  min-width: 70px;
  text-align: center;
}

.stats-card {
  flex: 1;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  border: none;
  transition: all 0.3s ease;
  overflow: hidden;
  background: linear-gradient(135deg, #ffffff, #f7faff);
}

.stats-card:hover {
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.07);
  transform: translateY(-2px);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  padding: 16px;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.card-header span {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 16px;
  color: var(--text-color);
}

.stats-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
}

.stat-box {
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 1;
  padding: 10px;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.stat-box:hover {
  background-color: rgba(0, 0, 0, 0.01);
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 28px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.member-icon {
  background: linear-gradient(135deg, #26de81, #20bf6b);
  color: white;
}

.conversion-icon {
  background: linear-gradient(135deg, #4b7bec, #3867d6);
  color: white;
}

.commission-icon {
  background: linear-gradient(135deg, #f7b731, #e67e22);
  color: white;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: var(--text-color);
}

.commission-value {
  color: #e67e22;
}

.stat-label {
  font-size: 14px;
  color: #606266;
  margin-top: 4px;
}

.stat-divider {
  width: 1px;
  height: 60px;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.01), rgba(0, 0, 0, 0.06), rgba(0, 0, 0, 0.01));
  margin: 0 20px;
}

.team-table-card {
  border-radius: 12px;
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.05);
  border: none;
  transition: all 0.3s ease;
  background: linear-gradient(135deg, #ffffff, #f7faff);
  overflow: hidden;
  padding-bottom: 10px;
  max-width: 1200px;
  margin: 0 auto;
  width: 90%;
}

.table-container {
  padding: 10px 20px;
  display: flex;
  justify-content: center;
}

.member-table {
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 16px;
  border: none;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
  width: 100%;
  max-width: 900px;
  margin: 0 auto 16px;
}

/* 覆盖element-ui表格样式 */
:deep(.member-table-header) {
  background: linear-gradient(to right, #f7faff, #f0f7ff) !important;
  color: #606266;
  font-weight: 600;
  font-size: 15px;
  height: 50px;
}

:deep(.member-table-row) {
  transition: all 0.3s;
  height: 60px;
}

:deep(.member-table-row:hover) {
  background-color: #f0f7ff !important;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

:deep(.member-table-row.el-table__row--striped) {
  background-color: #f9fbff;
}

:deep(.member-table-cell) {
  padding: 14px 0;
  border: none;
}

:deep(.el-table__body) td {
  border: none;
  border-bottom: 1px solid #f0f2f5;
}

:deep(.el-table__header-wrapper) {
  border-bottom: 1px solid #ebeef5;
}

:deep(.el-table::before) {
  display: none;
}

:deep(.el-table__fixed-right::before),
:deep(.el-table__fixed::before) {
  display: none;
}

.member-name-cell {
  display: flex;
  align-items: center;
}

/* 表格中的用户名样式 */
:deep(.member-name-cell .member-name) {
  font-size: 14px;
  font-weight: 500;
}

.id-cell {
  display: inline-block;
  background-color: #f5f7fa;
  padding: 6px 10px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 500;
  color: #606266;
}

.conversion-cell {
  position: relative;
}

.conversion-number {
  font-weight: 600;
  color: #4b7bec;
  font-size: 18px;
}

.commission-cell {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  padding-right: 10px;
}

.commission-text {
  color: #e67e22;
  font-weight: 600;
  font-size: 18px;
  transition: all 0.2s;
}

.status-tag {
  padding: 6px 12px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 500;
}

.action-buttons {
  display: flex;
  justify-content: center;
  gap: 12px;
}

.view-btn, .remove-btn {
  border-radius: 6px;
  padding: 6px 12px;
  font-size: 13px;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 5px;
  min-width: 72px;
}

.view-btn i, .remove-btn i {
  font-size: 14px;
  margin-right: 2px;
}

.view-btn span, .remove-btn span {
  display: inline-block;
  line-height: 1;
}

.view-btn {
  background-color: #409EFF;
  border-color: #409EFF;
  box-shadow: 0 2px 5px rgba(64, 158, 255, 0.2);
}

.view-btn:hover {
  background-color: #337ecc;
  border-color: #337ecc;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(64, 158, 255, 0.3);
}

.remove-btn {
  background-color: #F56C6C;
  border-color: #F56C6C;
  box-shadow: 0 2px 5px rgba(245, 108, 108, 0.2);
}

.remove-btn:hover {
  background-color: #d33d3d;
  border-color: #d33d3d;
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(245, 108, 108, 0.3);
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
  padding: 0 20px 10px;
}

.loading-container {
  padding: 24px;
}

/* 成员详情样式 */
.member-detail {
  padding: 20px;
}

.dialog-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #26de81, #20bf6b);
  color: white;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 28px;
  margin: 0 auto 20px;
  box-shadow: 0 4px 10px rgba(38, 222, 129, 0.3);
}

.member-header {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
  padding: 20px;
  background-color: rgba(0, 0, 0, 0.01);
  border-radius: 10px;
}

.member-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

/* 详情对话框中的用户名样式 */
.member-info .member-name {
  font-size: 24px;
  margin: 0 0 5px;
  color: var(--text-color);
}

.member-id {
  margin: 0 0 5px;
  color: #909399;
  font-size: 14px;
}

.detail-section {
  margin-bottom: 30px;
}

.detail-title {
  font-size: 18px;
  color: var(--text-color);
  margin: 0 0 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
  position: relative;
}

.detail-title::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 40px;
  height: 3px;
  background: var(--primary-color);
  border-radius: 3px;
}

.performance-stats {
  display: flex;
  justify-content: space-between;
  gap: 20px;
}

.performance-item {
  background: linear-gradient(135deg, #ffffff, #f7faff);
  border-radius: 10px;
  padding: 20px;
  flex: 1;
  text-align: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.performance-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.07);
}

.performance-icon {
  font-size: 28px;
  margin-bottom: 12px;
  color: #4b7bec;
}

.performance-value {
  font-size: 24px;
  font-weight: 600;
  margin-bottom: 8px;
  background: linear-gradient(90deg, #e67e22, #f7b731);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.performance-label {
  font-size: 14px;
  color: #606266;
}

/* 响应式设计 */
@media (max-width: 992px) {
  .top-cards-row {
    flex-direction: column;
  }
  
  .camp-selector-card {
    flex: none;
    width: 100%;
  }
}

@media (max-width: 768px) {
  .stats-wrapper {
    flex-direction: column;
    gap: 16px;
  }
  
  .stat-divider {
    display: none;
  }
  
  .main-content {
    padding: 16px;
  }
  
  .search-input {
    width: 150px;
  }
  
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }
  
  .page-actions {
    align-self: flex-end;
  }
}

@media (max-width: 480px) {
  .performance-stats {
    flex-direction: column;
  }
}

/* 佣金单元格样式 */
.commission-cell {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
}

.commission-btn {
  opacity: 0.8;
  transition: all 0.2s;
  width: 32px;
  height: 32px;
  padding: 0;
  background-color: #409EFF;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
}

.commission-btn i {
  font-size: 16px;
  line-height: 1;
}

.commission-btn:hover {
  opacity: 1;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

/* 成员佣金明细对话框样式 */
.commission-dialog {
  .commission-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 24px;
    border-bottom: 1px solid #ebeef5;
    padding-bottom: 20px;
  }
  
  .commission-info {
    flex: 1;
  }
  
  .info-row {
    margin-bottom: 12px;
    display: flex;
    align-items: center;
  }
  
  .info-label {
    width: 120px;
    color: #606266;
    font-weight: 500;
    display: flex;
    align-items: center;
    gap: 5px;
  }
  
  .info-value {
    color: #333;
    font-weight: 500;
  }
  
  .commission-stats {
    display: flex;
    flex-direction: row;
    gap: 20px;
    width: 100%;
    margin-top: 15px;
  }
  
  .stat-box {
    padding: 20px;
    border-radius: 8px;
    display: flex;
    justify-content: center;
    flex: 1;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    transition: all 0.3s;
    min-width: 180px;
    text-align: center;
  }

  .stat-box:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
  }
  
  .commission-box {
    background-color: #fff8f0;
  }
  
  .conversion-box {
    background-color: #f0f8ff;
  }
  
  .stat-content {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  
  .stat-label {
    color: #606266;
    font-size: 14px;
    margin-top: 8px;
  }
  
  .stat-value {
    font-size: 30px;
    font-weight: 600;
    line-height: 1.2;
  }
  
  .commission-box .stat-value {
    color: #ff9800;
  }
  
  .conversion-box .stat-value {
    color: #2196f3;
  }
  
  .commission-table-wrapper {
    margin-top: 20px;
  }
  
  .commission-table {
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  }
  
  :deep(.commission-table-header) {
    background: linear-gradient(to right, #f9f9f9, #f5f5f5) !important;
    color: #606266;
    font-weight: 600;
  }
  
  :deep(.commission-table-row:hover) {
    background-color: #f9f9f9 !important;
  }
  
  .commission-amount {
    font-weight: 600;
    color: #e67e22;
  }
  
  .loading-container {
    padding: 30px 0;
  }
  
  .empty-data {
    display: flex;
    justify-content: center;
    padding: 40px 0;
  }
  
  .info-key {
    color: #606266;
    margin-right: 5px;
    display: inline-flex;
    align-items: center;
    gap: 3px;
  }
  
  .info-item {
    margin-bottom: 5px;
  }
}
</style> 