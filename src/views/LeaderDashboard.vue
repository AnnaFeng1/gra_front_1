<template>
  <div class="dashboard-container">
    <!-- 使用公共导航栏组件 -->
    <LeaderNavBar :activePage="activePage" />

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 欢迎信息 -->
      <div class="welcome-section">
        <!-- 添加动效背景 Canvas -->
        <canvas ref="welcomeCanvas" class="welcome-canvas"></canvas>
        <div class="welcome-content">
          <h2 class="welcome-text">欢迎，{{ userInfo.username }} <el-tag type="warning">大使长</el-tag></h2>
        </div>
      </div>
      
      <!-- 内容区域 - 上下排列 -->
      <div class="content-container-vertical">
        <!-- 当前营期和业绩数据卡片 -->
        <el-card class="combined-card" v-loading="loading">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-date"></i> 营期与业绩</span>
              <el-tooltip
                content="刷新数据"
                placement="top"
              >
                <el-button 
                  class="refresh-btn" 
                  :loading="loading" 
                  @click="refreshData" 
                  type="primary" 
                  circle>
                  <el-icon :size="16"><Refresh /></el-icon>
                </el-button>
              </el-tooltip>
            </div>
          </template>
          <div class="combined-content">
            <!-- 营期信息部分 -->
            <div class="camp-section">
              <h3 class="section-title">当前目标营期</h3>
              <div class="camp-info">
                <div class="camp-name-row">
                  <span class="camp-name">{{ performanceData.campName }}</span>
                </div>
                
                <div class="camp-timeline-container">
                  <div class="camp-timeline">
                    <div class="timeline-dates">
                      <span class="start-date">{{ formatDate(performanceData.startDate) }}</span>
                      <span class="end-date">{{ formatDate(performanceData.endDate) }}</span>
                    </div>
                    <div class="timeline-track">
                      <div class="timeline-progress" :style="{ width: calculateProgress() + '%' }"></div>
                      <div class="timeline-indicator" :style="{ left: calculateProgress() + '%' }"></div>
                    </div>
                  </div>
                </div>
                
                <div class="camp-progress-info">
                  <div class="progress-stat">
                    <span class="progress-label">已进行:</span>
                    <span class="progress-value">{{ calculateDaysElapsed() }}天</span>
                  </div>
                  <div class="progress-divider"></div>
                  <div class="progress-stat">
                    <span class="progress-label">剩余:</span>
                    <span class="progress-value">{{ calculateDaysLeft() }}天</span>
                  </div>
                  <div class="progress-divider"></div>
                  <div class="camp-id-display">
                    <span class="camp-id-label">营期ID:</span>
                    <div class="editable-camp-id">
                      <span class="camp-id-value">{{ currentCampId }}</span>
                      <div class="camp-id-input-wrapper">
                        <el-input 
                          v-model="currentCampId" 
                          size="small"
                          @blur="handleCampChange"
                          @keyup.enter="handleCampChange"
                          class="camp-id-input-hover"
                        ></el-input>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div class="camp-navigation">
                  <el-tooltip
                    content="查看上一个营期"
                    placement="top"
                  >
                    <el-button 
                      class="camp-nav-btn prev-btn" 
                      :disabled="loading"
                      @click="navigateToPrevCamp"
                      type="primary"
                      circle>
                      <el-icon :size="20"><ArrowLeft /></el-icon>
                    </el-button>
                  </el-tooltip>
                  <el-tooltip
                    content="查看下一个营期"
                    placement="top"
                  >
                    <el-button 
                      class="camp-nav-btn next-btn" 
                      :disabled="loading"
                      @click="navigateToNextCamp"
                      type="primary"
                      circle>
                      <el-icon :size="20"><ArrowRight /></el-icon>
                    </el-button>
                  </el-tooltip>
                </div>
              </div>
            </div>
            
            <!-- 分隔线 -->
            <div class="section-divider"></div>
            
            <!-- 业绩数据部分 -->
            <div class="stats-section">
              <h3 class="section-title">个人业绩数据</h3>
              <div class="stats-content">
                <div class="stat-item">
                  <div class="stat-title">成功推广数</div>
                  <div class="stat-value">{{ performanceData.totalConversions || 0 }}</div>
                  <div class="stat-desc">本营期推广</div>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item commission-item">
                  <div class="stat-title">佣金总额</div>
                  <div class="stat-value">¥{{ formatAmount(performanceData.totalCommission) }}</div>
                  <div class="stat-desc">累计收益</div>
                  <div class="commission-detail-btn-wrapper">
                    <el-button 
                      type="primary" 
                      size="default" 
                      class="commission-detail-btn"
                      @click="handleViewCommissionDetails">
                      <i class="el-icon-document"></i> 佣金明细
                    </el-button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 团队管理卡片 -->
        <el-card class="team-card">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-s-custom"></i> 团队管理</span>
              <el-button type="primary" size="small" @click="goToTeamManagement">
                <i class="el-icon-s-unfold"></i> 进入团队管理
              </el-button>
            </div>
          </template>
          <div class="team-summary">
            <h3 class="section-title">团队数据概览</h3>
            <div class="team-stat">
              <div class="team-stat-title">团队成员</div>
              <div class="team-stat-value">{{ teamSummary.memberCount || 0 }}</div>
              <div class="team-stat-desc">在册推广大使</div>
            </div>
            <div class="team-stat">
              <div class="team-stat-title">团队业绩</div>
              <div class="team-stat-value">{{ teamSummary.totalConversions || 0 }}</div>
              <div class="team-stat-desc">总转化数量</div>
            </div>
            <div class="team-stat">
              <div class="team-stat-title">团队佣金</div>
              <div class="team-stat-value">¥{{ formatAmount(teamSummary.totalCommission) }}</div>
              <div class="team-stat-desc">总佣金金额</div>
            </div>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 佣金明细弹窗 -->
    <el-dialog
      v-model="commissionDialogVisible"
      title="佣金明细"
      width="900px"
      class="commission-dialog"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <div class="commission-header">
        <div class="commission-info">
          <div class="info-row">
            <span class="info-label">营期ID:</span>
            <span class="info-value">{{ commissionData.campId || currentCampId }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">营期名称:</span>
            <span class="info-value">{{ commissionData.campName || performanceData.campName }}</span>
          </div>
          <div class="info-row" v-if="commissionData.startDate && commissionData.endDate">
            <span class="info-label">营期时间:</span>
            <span class="info-value">
              {{ formatDate(commissionData.startDate) }} 至 {{ formatDate(commissionData.endDate) }}
            </span>
          </div>
          <div class="info-row camp-id-input">
            <span class="info-label">切换营期:</span>
            <el-input 
              v-model="currentCampId" 
              size="small" 
              style="width: 120px;" 
              placeholder="营期ID" 
              type="number"
            ></el-input>
            <el-tooltip
              content="刷新数据"
              placement="top"
            >
              <el-button 
                class="refresh-btn" 
                type="primary" 
                @click="refreshData" 
                :loading="commissionLoading"
                circle>
                <el-icon :size="16"><Refresh /></el-icon>
              </el-button>
            </el-tooltip>
          </div>
        </div>
        <div class="commission-total">
          <span class="total-label">总佣金:</span>
          <span class="total-value">
            ￥{{ formatAmount(performanceData.totalCommission) }}
          </span>
        </div>
      </div>
      
      <div v-if="commissionLoading" class="loading-container">
        <el-skeleton :rows="5" animated />
      </div>
      
      <div v-else-if="commissionData.details && commissionData.details.length > 0" class="commission-table-wrapper">
        <el-table 
          :data="commissionData.details" 
          style="width: 100%" 
          border 
          stripe
          max-height="400"
          class="commission-table"
        >
          <el-table-column prop="commission_id" label="ID" width="80" align="center" />
          <el-table-column label="佣金类型" width="150" align="center">
            <template #default="scope">
              <el-tag :type="getCommissionTypeTag(scope.row.commission_type)">
                {{ getCommissionTypeLabel(scope.row.commission_type) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="相关信息" min-width="180">
            <template #default="scope">
              <div v-if="scope.row.promoted_ambassador_id">
                <span class="info-key">晋升推广大使ID:</span> 
                <span class="info-value">{{ scope.row.promoted_ambassador_id }}</span>
              </div>
              <div v-if="scope.row.order_id">
                <span class="info-key">订单ID:</span> 
                <span class="info-value">{{ scope.row.order_id }}</span>
              </div>
              <div v-if="scope.row.customer_id">
                <span class="info-key">客户ID:</span> 
                <span class="info-value">{{ scope.row.customer_id }}</span>
              </div>
              <div v-if="scope.row.tier">
                <span class="info-key">佣金层级:</span> 
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
          <el-button type="primary" @click="commissionDialogVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { ArrowLeft, ArrowRight, Refresh } from '@element-plus/icons-vue';
import { getLeaderPerformanceStatistics, getTeamOverview, getLeaderCommissions } from '@/api/leader';
import { getUserInfo } from '@/api/auth';
import LeaderNavBar from '@/components/LeaderNavBar.vue';

// 路由
const router = useRouter();

// 当前活动页面
const activePage = ref('home');

// 数据加载状态
const loading = ref(false);
const commissionLoading = ref(false);

// 用户信息
const userInfo = ref({
  username: '加载中...',
  role: 'leader'
});

// Canvas引用
const welcomeCanvas = ref(null);

// 佣金明细弹窗
const commissionDialogVisible = ref(false);

// 当前营期ID
const currentCampId = ref(1001);

// 性能数据
const performanceData = reactive({
  campId: '',
  campName: '加载中...',
  startDate: '',
  endDate: '',
  totalCommission: 0,
  totalConversions: 0
});

// 团队摘要数据（示例数据，实际应从API获取）
const teamSummary = reactive({
  memberCount: 5,
  totalConversions: 178,
  totalCommission: 15680.50
});

// 佣金明细数据
const commissionData = reactive({
  campId: '',
  campName: '',
  startDate: '',
  endDate: '',
  details: []
});

// 格式化日期
const formatDate = (dateStr) => {
  // 当营期ID为1001时，覆盖日期显示
  if (currentCampId.value === 1001) {
    // 检查是否是开始日期或结束日期
    if (dateStr === performanceData.startDate) {
      return '2025-05-03';
    } else if (dateStr === performanceData.endDate) {
      return '2025-06-05';
    }
  }
  // 当营期ID为1000时，覆盖日期显示
  else if (currentCampId.value === 1000) {
    // 检查是否是开始日期或结束日期
    if (dateStr === performanceData.startDate) {
      return '2025-04-10';
    } else if (dateStr === performanceData.endDate) {
      return '2025-05-03';
    }
  }
  
  if (!dateStr) return '暂无数据';
  try {
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) return '无效日期';
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
  } catch (e) {
    console.error('日期格式化错误:', e);
    return '日期错误';
  }
};

// 格式化金额
const formatAmount = (amount) => {
  if (amount === undefined || amount === null) return '0.00';
  return Number(amount).toFixed(2);
};

// 获取用户信息
const fetchUserInfo = async () => {
  try {
    const response = await getUserInfo();
    if (response.code === 1) {
      userInfo.value = response.data;
    }
  } catch (error) {
    console.error('获取用户信息失败:', error);
    ElMessage.error('获取用户信息失败');
  }
};

// 获取业绩数据
const fetchPerformanceData = async () => {
  loading.value = true;
  try {
    const response = await getLeaderPerformanceStatistics(currentCampId.value);
    if (response.code === 1) {
      // 将下划线格式转换为驼峰格式
      performanceData.campId = response.data.camp_id;
      performanceData.campName = response.data.camp_name;
      performanceData.startDate = response.data.start_date;
      performanceData.endDate = response.data.end_date;
      performanceData.totalCommission = response.data.total_commission;
      performanceData.totalConversions = response.data.total_conversions;
    } else {
      ElMessage.warning(response.msg || '获取业绩数据失败');
    }
  } catch (error) {
    console.error('获取业绩数据失败:', error);
    ElMessage.error('获取业绩数据失败，请稍后重试');
  } finally {
    loading.value = false;
  }
};

// 获取团队信息
const fetchTeamData = async () => {
  try {
    const response = await getTeamOverview(currentCampId.value);
    if (response.code === 1) {
      teamSummary.memberCount = response.data.member_count;
      teamSummary.totalConversions = response.data.success_count;
      teamSummary.totalCommission = response.data.total_commission;
    } else {
      console.warn('获取团队数据失败:', response.msg);
    }
  } catch (error) {
    console.error('获取团队数据失败:', error);
  }
};

// 获取佣金明细数据
const fetchCommissionDetails = async (campId) => {
  commissionLoading.value = true;
  try {
    const response = await getLeaderCommissions(campId);
    if (response.code === 1) {
      commissionData.campId = response.data.camp_id;
      commissionData.campName = response.data.camp_name;
      commissionData.startDate = response.data.start_date;
      commissionData.endDate = response.data.end_date;
      commissionData.details = response.data.details || [];
    } else {
      ElMessage.warning(response.msg || '获取佣金明细失败');
    }
  } catch (error) {
    console.error('获取佣金明细失败:', error);
    ElMessage.error('获取佣金明细失败，请稍后重试');
  } finally {
    commissionLoading.value = false;
  }
};

// 处理营期变更
const handleCampChange = () => {
  fetchPerformanceData();
  fetchTeamData();
};

// 查看佣金明细
const handleViewCommissionDetails = () => {
  commissionDialogVisible.value = true;
  fetchCommissionDetails(currentCampId.value);
};

// 刷新数据
const refreshData = () => {
  fetchPerformanceData();
  fetchTeamData();
  if (commissionDialogVisible.value) {
    fetchCommissionDetails(currentCampId.value);
  }
};

// 跳转到用户中心
const goToUserCenter = () => {
  router.push('/profile');
};

// 导航到指定页面
const navigateTo = (path) => {
  router.push(path);
  
  // 更新当前活动页面
  if (path === '/') {
    activePage.value = 'home';
  } else if (path === '/team-management') {
    activePage.value = 'team';
  } else if (path === '/commission-data') {
    activePage.value = 'commission';
  } else if (path === '/customer-data') {
    activePage.value = 'customer';
  }
};

// 跳转到团队管理页面
const goToTeamManagement = () => {
  navigateTo('/team-management');
};

// 初始化粒子动画
const initParticleAnimation = () => {
  const canvas = welcomeCanvas.value;
  if (!canvas) return;
  
  const ctx = canvas.getContext('2d');
  const particles = [];
  let animationFrame = null;
  
  // 设置Canvas尺寸
  const resizeCanvas = () => {
    const welcomeSection = canvas.parentElement;
    canvas.width = welcomeSection.offsetWidth;
    canvas.height = welcomeSection.offsetHeight;
  };
  
  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();
  
  // 粒子类
  class Particle {
    constructor() {
      this.x = Math.random() * canvas.width;
      this.y = Math.random() * canvas.height;
      this.size = Math.random() * 2 + 0.5;
      this.speedX = Math.random() * 0.5 - 0.25;
      this.speedY = Math.random() * 0.5 - 0.25;
      this.color = `rgba(64, 158, 255, ${Math.random() * 0.4 + 0.1})`; // 修改为蓝色系，与推广大使一致
    }
    
    update() {
      if (this.x > canvas.width || this.x < 0) {
        this.speedX = -this.speedX;
      }
      if (this.y > canvas.height || this.y < 0) {
        this.speedY = -this.speedY;
      }
      
      this.x += this.speedX;
      this.y += this.speedY;
    }
    
    draw() {
      ctx.fillStyle = this.color;
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
      ctx.fill();
    }
  }
  
  // 初始化粒子
  const init = () => {
    for (let i = 0; i < 15; i++) {
      particles.push(new Particle());
    }
  };
  
  // 动画循环
  const animate = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // 更新并绘制粒子
    particles.forEach(particle => {
      particle.update();
      particle.draw();
    });
    
    // 连接临近的粒子
    connectParticles();
    
    animationFrame = requestAnimationFrame(animate);
  };
  
  // 连接临近的粒子
  const connectParticles = () => {
    for (let i = 0; i < particles.length; i++) {
      for (let j = i + 1; j < particles.length; j++) {
        const dx = particles[i].x - particles[j].x;
        const dy = particles[i].y - particles[j].y;
        const distance = Math.sqrt(dx * dx + dy * dy);
        
        if (distance < 100) {
          ctx.beginPath();
          ctx.strokeStyle = `rgba(64, 158, 255, ${0.2 - distance/500})`; // 修改为蓝色系，与推广大使一致
          ctx.lineWidth = 0.8;
          ctx.moveTo(particles[i].x, particles[i].y);
          ctx.lineTo(particles[j].x, particles[j].y);
          ctx.stroke();
        }
      }
    }
  };
  
  init();
  animate();
  
  // 返回清理函数
  return () => {
    window.removeEventListener('resize', resizeCanvas);
    if (animationFrame) {
      cancelAnimationFrame(animationFrame);
    }
  };
};

// 存储清理函数
const cleanupAnimation = ref(null);

// 生命周期钩子
onMounted(() => {
  fetchUserInfo();
  fetchPerformanceData();
  fetchTeamData();
  cleanupAnimation.value = initParticleAnimation();
  
  // 设置当前活动页面
  const path = router.currentRoute.value.path;
  if (path === '/') {
    activePage.value = 'home';
  } else if (path.includes('team')) {
    activePage.value = 'team';
  } else if (path.includes('commission')) {
    activePage.value = 'commission';
  } else if (path.includes('customer')) {
    activePage.value = 'customer';
  }
});

// 组件卸载时清理资源
onUnmounted(() => {
  if (cleanupAnimation.value && typeof cleanupAnimation.value === 'function') {
    cleanupAnimation.value();
  }
});

// 获取佣金类型标签
const getCommissionTypeTag = (type) => {
  const tagMap = {
    'ambassador_conversion': 'success',
    'leader_team_conversion': 'primary',
    'promotion_bonus_fixed': 'warning',
    'promotion_bonus_percentage': 'danger'
  };
  return tagMap[type] || 'info';
};

// 获取佣金类型文本
const getCommissionTypeLabel = (type) => {
  const labelMap = {
    'ambassador_conversion': '直接推广佣金',
    'leader_team_conversion': '团队推广佣金',
    'promotion_bonus_fixed': '晋升固定奖励',
    'promotion_bonus_percentage': '晋升比例奖励'
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

// 计算营期进度百分比
const calculateProgress = () => {
  if (!performanceData.startDate || !performanceData.endDate) return 0;
  
  let startDate, endDate;
  
  // 当营期ID为1001时，使用固定的日期
  if (currentCampId.value === 1001) {
    startDate = new Date('2025-05-03');
    endDate = new Date('2025-06-05');
  } 
  // 当营期ID为1000时，使用固定的日期
  else if (currentCampId.value === 1000) {
    startDate = new Date('2025-04-10');
    endDate = new Date('2025-05-03');
  }
  else {
    // 其他营期使用后端返回的日期
    startDate = new Date(performanceData.startDate);
    endDate = new Date(performanceData.endDate);
  }
  
  const now = new Date();
  
  if (now < startDate) return 0;
  if (now > endDate) return 100;
  
  const totalDuration = endDate - startDate;
  const elapsedDuration = now - startDate;
  
  return Math.round((elapsedDuration / totalDuration) * 100);
};

// 计算已过天数
const calculateDaysElapsed = () => {
  if (!performanceData.startDate) return 0;
  
  let startDate;
  
  // 当营期ID为1001时，使用固定的开始日期
  if (currentCampId.value === 1001) {
    startDate = new Date('2025-05-03');
  } 
  // 当营期ID为1000时，使用固定的开始日期
  else if (currentCampId.value === 1000) {
    startDate = new Date('2025-04-10');
  }
  else {
    // 其他营期使用后端返回的日期
    startDate = new Date(performanceData.startDate);
  }
  
  const now = new Date();
  
  if (now < startDate) return 0;
  
  const diffTime = Math.abs(now - startDate);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
};

// 计算剩余天数
const calculateDaysLeft = () => {
  if (!performanceData.endDate) return 0;
  
  let endDate;
  
  // 当营期ID为1001时，使用固定的结束日期
  if (currentCampId.value === 1001) {
    endDate = new Date('2025-06-05');
  } 
  // 当营期ID为1000时，使用固定的结束日期
  else if (currentCampId.value === 1000) {
    endDate = new Date('2025-05-03');
  }
  else {
    // 其他营期使用后端返回的日期
    endDate = new Date(performanceData.endDate);
  }
  
  const now = new Date();
  
  // 如果当前日期已经超过结束日期，返回0
  if (now >= endDate) return 0;
  
  const diffTime = Math.abs(endDate - now);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
};

// 导航到上一个营期
const navigateToPrevCamp = () => {
  if (loading.value) return;
  currentCampId.value--;
  handleCampChange(currentCampId.value);
};

// 导航到下一个营期
const navigateToNextCamp = () => {
  if (loading.value) return;
  currentCampId.value++;
  handleCampChange(currentCampId.value);
};

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

.dashboard-container {
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

.welcome-section {
  display: flex;
  align-items: center;
  background: linear-gradient(to right, #f1f8ff, #ffffff); /* 修改背景渐变为蓝色系，与推广大使一致 */
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
  position: relative;
  overflow: hidden;
  height: 100px;
}

.welcome-canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  pointer-events: none;
}

.welcome-content {
  position: relative;
  z-index: 2;
}

.welcome-text {
  margin: 0;
  font-size: 24px;
  color: var(--text-color);
  display: flex;
  align-items: center;
  gap: 10px;
}

.welcome-subtitle {
  margin: 8px 0 0;
  color: #606266;
  font-size: 16px;
}

.content-container-vertical {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.combined-card, .team-card {
  border-radius: 8px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
  transition: all 0.3s;
  border: none;
}

.combined-card:hover, .team-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
}

.combined-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.section-divider {
  height: 1px;
  width: 100%;
  background-color: #f0f0f0;
  margin: 5px 0;
}

.section-title {
  font-size: 18px;
  color: var(--text-color);
  margin: 0 0 16px;
  font-weight: 600;
}

.camp-section {
  padding: 20px 15px;
}

.camp-info {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.camp-name-row {
  text-align: center;
}

.camp-name {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-color);
  background: linear-gradient(to right, #409EFF, #53a8ff);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  padding: 5px 0;
}

.camp-timeline-container {
  margin: 15px 0;
}

.camp-timeline {
  position: relative;
}

.timeline-dates {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 14px;
  color: #606266;
}

.timeline-track {
  height: 8px;
  background-color: #e4e7ed;
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}

.timeline-progress {
  position: absolute;
  height: 100%;
  background: linear-gradient(to right, #409EFF, #53a8ff);
  border-radius: 4px;
  transition: width 0.5s ease;
}

.timeline-indicator {
  position: absolute;
  top: 50%;
  width: 12px;
  height: 12px;
  background-color: #fff;
  border: 3px solid #409EFF;
  border-radius: 50%;
  transform: translate(-50%, -50%);
  z-index: 1;
  box-shadow: 0 0 0 3px rgba(64, 158, 255, 0.2);
  transition: left 0.5s ease;
}

.camp-progress-info {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
  margin-top: 15px;
}

.progress-stat {
  display: flex;
  align-items: center;
  gap: 5px;
}

.progress-label {
  font-size: 14px;
  color: #909399;
}

.progress-value {
  font-size: 16px;
  font-weight: 600;
  color: #606266;
}

.progress-divider {
  width: 1px;
  height: 24px;
  background-color: #e4e7ed;
}

.camp-id-display {
  display: flex;
  align-items: center;
  gap: 5px;
}

.camp-id-label {
  font-size: 14px;
  color: #909399;
}

.camp-id-value {
  font-size: 16px;
  font-weight: 700;
  color: #409EFF;
}

.editable-camp-id {
  position: relative;
  cursor: text;
}

.editable-camp-id:hover .camp-id-value {
  opacity: 0;
}

.editable-camp-id:hover .camp-id-input-wrapper {
  display: block;
}

.camp-id-input-wrapper {
  position: absolute;
  top: -5px;
  left: -5px;
  display: none;
  width: 80px;
}

.camp-id-input-hover :deep(.el-input__inner) {
  height: 28px;
  font-size: 16px;
  font-weight: 700;
  color: #409EFF;
  text-align: center;
  padding: 0 5px;
  border-width: 2px;
}

.camp-navigation {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
  margin-bottom: 10px;
  padding: 0 20%;
}

.camp-nav-btn {
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
  width: 48px !important;
  height: 48px !important;
  border: none !important;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, #409EFF, #53a8ff) !important;
  color: white !important;
}

.camp-nav-btn:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 4px 15px rgba(64, 158, 255, 0.5);
  background: linear-gradient(145deg, #53a8ff, #409EFF) !important;
}

.camp-nav-btn:active:not(:disabled) {
  transform: translateY(0) scale(0.95);
  box-shadow: 0 2px 6px rgba(64, 158, 255, 0.4);
}

.camp-nav-btn.is-disabled {
  opacity: 0.5;
  background: linear-gradient(145deg, #a0c4e4, #b6d3ee) !important;
  color: #ffffff !important;
  box-shadow: none !important;
  cursor: not-allowed;
}

.camp-nav-btn :deep(.el-icon) {
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

.prev-btn:not(:disabled):not(.is-loading) {
  animation: pulse-left 2s infinite;
}

.next-btn:not(:disabled):not(.is-loading) {
  animation: pulse-right 2s infinite;
}

@keyframes pulse-left {
  0% {
    box-shadow: -4px 0 0 0 rgba(64, 158, 255, 0.4);
  }
  70% {
    box-shadow: -4px 0 0 5px rgba(64, 158, 255, 0);
  }
  100% {
    box-shadow: -4px 0 0 0 rgba(64, 158, 255, 0);
  }
}

@keyframes pulse-right {
  0% {
    box-shadow: 4px 0 0 0 rgba(64, 158, 255, 0.4);
  }
  70% {
    box-shadow: 4px 0 0 5px rgba(64, 158, 255, 0);
  }
  100% {
    box-shadow: 4px 0 0 0 rgba(64, 158, 255, 0);
  }
}

.stats-content {
  display: flex;
  gap: 30px;
}

.stat-item {
  flex: 1;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.02);
  padding: 24px 16px;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.stat-divider {
  width: 1px;
  background-color: #f0f0f0;
}

.stat-title {
  font-size: 16px;
  color: #606266;
}

.stat-value {
  font-size: 30px;
  font-weight: 600;
  color: var(--primary-color);
}

.commission-item .stat-value {
  color: var(--warning-color);
}

.stat-desc {
  font-size: 14px;
  color: #909399;
}

.commission-detail-btn-wrapper {
  margin-top: 10px;
}

.team-summary {
  display: flex;
  justify-content: space-between;
  align-items: stretch;
  gap: 16px;
}

.team-stat {
  flex: 1;
  background-color: rgba(0, 0, 0, 0.02);
  padding: 20px;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 8px;
}

.team-stat-title {
  font-size: 16px;
  color: #606266;
}

.team-stat-value {
  font-size: 28px;
  font-weight: 600;
  color: var(--warning-color);
}

.team-stat-desc {
  font-size: 14px;
  color: #909399;
}

/* 佣金明细弹窗样式 */
.commission-dialog {
  .commission-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 20px;
    border-bottom: 1px solid #ebeef5;
    padding-bottom: 15px;
  }
  
  .commission-info {
    flex: 1;
  }
  
  .info-row {
    margin-bottom: 10px;
    display: flex;
    align-items: center;
  }
  
  .info-label {
    width: 100px;
    color: #606266;
    font-weight: 500;
  }
  
  .info-value {
    color: #333;
  }
  
  .commission-total {
    background-color: #f5f7fa;
    padding: 10px 15px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    gap: 10px;
  }
  
  .total-label {
    font-weight: 500;
    color: #606266;
  }
  
  .total-value {
    font-size: 20px;
    font-weight: 600;
    color: #f56c6c;
  }
  
  .commission-table-wrapper {
    margin-top: 20px;
  }
  
  .commission-amount {
    font-weight: 600;
    color: #f56c6c;
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
    color: #909399;
    margin-right: 5px;
  }
}

@media (max-width: 768px) {
  .stats-content, .team-summary {
    flex-direction: column;
    gap: 16px;
  }
  
  .stat-divider {
    display: none;
  }
  
  .main-content {
    padding: 16px;
  }
}

@media (max-width: 480px) {
  .welcome-text {
    font-size: 20px;
  }
  
  .welcome-section {
    height: auto;
    padding: 16px;
  }
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
  color: var(--primary-color);
}

.nav-item.active {
  color: var(--primary-color);
  font-weight: 600;
}

.nav-item.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background-color: var(--primary-color);
}

.refresh-btn {
  width: 32px !important;
  height: 32px !important;
  padding: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.refresh-btn :deep(.el-icon) {
  display: flex;
  align-items: center;
  justify-content: center;
}
</style> 