<template>
  <div class="dashboard-container">
    <!-- 顶部导航栏 -->
    <div class="header">
      <div class="logo">营销推广管理系统</div>
      <div class="user-info">
        <el-button 
          class="user-center-btn" 
          @click="goToUserCenter">
          <i class="el-icon-user"></i> 个人中心
        </el-button>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 欢迎信息 -->
      <div class="welcome-section">
        <!-- 添加动效背景 Canvas -->
        <canvas ref="welcomeCanvas" class="welcome-canvas"></canvas>
        <h2 class="welcome-text">欢迎，{{ userInfo.username }}</h2>
        <div class="header-actions">
          <el-button v-if="userInfo.team_name" type="danger" @click="handleLeaveTeam">离开团队</el-button>
        </div>
      </div>
      
      <!-- 内容区域 - 改为上下排列 -->
      <div class="content-container-vertical">
        <!-- 当前营期和业绩数据卡片 -->
        <el-card class="combined-card">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-date"></i> 营期与业绩</span>
            </div>
          </template>
          <div class="combined-content">
            <!-- 营期信息部分 -->
            <div class="camp-section">
              <h3 class="section-title">当前营期</h3>
              <div class="camp-info">
                <div class="info-item">
                  <span class="info-label">营期名称:</span>
                  <span class="info-value camp-name">{{ currentCamp.camp_name }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">营期时间:</span>
                  <span class="info-value">{{ formatDate(currentCamp.start_date) }} 至 {{ formatDate(currentCamp.end_date) }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">推广层级:</span>
                  <span class="info-value level-badge" :class="levelClass">{{ promotionLevelText }}</span>
                </div>
                <!-- 推广层级进度条 -->
                <div class="level-progress-container">
                  <div class="level-progress-info">
                    <span>{{ levelProgressText }}</span>
                    <span>{{ levelNextGoalText }}</span>
                  </div>
                  <el-progress 
                    :percentage="levelProgressPercentage" 
                    :stroke-width="10"
                    :color="levelProgressColor"
                    class="level-progress">
                  </el-progress>
                  <div class="level-markers">
                    <div class="marker marker-initial" :class="{ active: successCount > 0 }">
                      <div class="marker-dot"></div>
                      <div class="marker-label">初级</div>
                    </div>
                    <div class="marker marker-medium" :class="{ active: successCount > 20 }">
                      <div class="marker-dot"></div>
                      <div class="marker-label">中级</div>
                    </div>
                    <div class="marker marker-high" :class="{ active: successCount > 50 }">
                      <div class="marker-dot"></div>
                      <div class="marker-label">高级</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            
            <!-- 分隔线 -->
            <div class="section-divider"></div>
            
            <!-- 业绩数据部分 -->
            <div class="stats-section">
              <h3 class="section-title">业绩数据</h3>
              <div class="stats-content">
                <div class="stat-item">
                  <div class="stat-title">成功推广数</div>
                  <div class="stat-value">{{ successCount }}</div>
                  <div class="stat-desc">本营期推广</div>
                </div>
                <div class="stat-divider"></div>
                <div class="stat-item commission-item">
                  <div class="stat-title">佣金总额</div>
                  <div class="stat-value">{{ commissionTotal }}</div>
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

        <!-- 成长进度卡片 -->
        <el-card class="progress-card">
          <template #header>
            <div class="card-header">
              <span><i class="el-icon-rank"></i> 成长进度</span>
            </div>
          </template>
          <div class="progress-content">
            <div class="progress-title">当前进度</div>
            <el-progress 
              :percentage="progressPercentage" 
              :stroke-width="20" 
              status="success"
              :format="format"
              class="custom-progress">
            </el-progress>
            <div class="progress-info">
              已推广 <span class="highlight">{{ progress.current_count || 0 }}</span> 人，
              目标 <span class="highlight">{{ progress.required_count || 50 }}</span> 人
            </div>
            <div class="progress-actions">
              <el-tooltip
                :content="canApplyPromotion ? '点击申请晋升' : `还需要完成${remainingPromotions}个推广才能申请晋升`"
                placement="top"
                effect="light"
              >
                <el-button 
                  type="primary" 
                  @click="handleApplyPromotion" 
                  class="promotion-btn"
                  :disabled="!canApplyPromotion">
                  {{ canApplyPromotion ? '申请晋升' : `还需${remainingPromotions}个推广` }}
                </el-button>
              </el-tooltip>
            </div>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 佣金明细弹窗 -->
    <el-dialog
      v-model="commissionDialogVisible"
      title="佣金明细"
      width="750px"
      class="commission-dialog"
      :close-on-click-modal="false"
      destroy-on-close
    >
      <div class="commission-header">
        <div class="commission-info">
          <div class="info-row">
            <span class="info-label">佣金类型:</span>
            <span class="info-value">{{ commissionDetails.commission_type || '直接转化佣金' }}</span>
          </div>
          <div class="info-row">
            <span class="info-label">当前营期:</span>
            <span class="info-value">
              <template v-if="commissionLoading">
                <i class="el-icon-loading" style="margin-right: 5px;"></i>加载中...
              </template>
              <template v-else>
                {{ selectedCampInfo.camp_name || `营期${currentCampPeriodId}` }}
              </template>
            </span>
          </div>
          <!-- 添加营期时间信息 -->
          <div class="info-row" v-if="selectedCampInfo.start_date || selectedCampInfo.end_date">
            <span class="info-label">营期时间:</span>
            <span class="info-value">
              {{ formatDate(selectedCampInfo.start_date) }} 至 {{ formatDate(selectedCampInfo.end_date) }}
            </span>
          </div>
          <!-- 添加营期ID输入区域 -->
          <div class="info-row camp-id-input">
            <span class="info-label">营期ID:</span>
            <el-input 
              v-model="currentCampPeriodId" 
              size="small" 
              style="width: 120px;" 
              placeholder="营期ID" 
              type="number"
            ></el-input>
            <el-button 
              size="small" 
              type="primary" 
              @click="reloadCommissionDetails" 
              :icon="RefreshRight"
              style="margin-left: 10px;"
            >刷新</el-button>
          </div>
        </div>
        <div class="commission-total">
          <span class="total-label">总佣金:</span>
          <span class="total-value">
            {{ formatCommissionAmount(commissionDetails.total_commission) }}
          </span>
        </div>
      </div>
      
      <!-- 添加加载状态 -->
      <div v-if="commissionLoading" class="loading-container">
        <el-icon class="is-loading"><Loading /></el-icon>
        <span>正在加载数据...</span>
      </div>
      
      <el-table 
        v-else
        :data="commissionDetails.details || []" 
        style="width: 100%" 
        stripe 
        border
      >
        <el-table-column label="客户ID" prop="customer_id" width="100" align="center" />
        <el-table-column label="客户姓名" prop="customer_name" width="130" align="center" />
        <el-table-column label="佣金金额" width="150" align="center">
          <template #default="scope">
            <span class="commission-amount">{{ formatCommissionAmount(scope.row.commission_amount) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="时间" prop="time" min-width="180" align="center" />
      </el-table>
      
      <div class="commission-footer" v-if="!commissionLoading && !commissionDetails.details?.length">
        <el-empty 
          description="当前营期没有佣金明细记录" 
          :image-size="120"
        >
          <template #description>
            <p>在营期ID: {{ currentCampPeriodId }} 中没有任何推广数据</p>
            <p class="empty-hint">您可以尝试查询其他营期或联系管理员</p>
          </template>
        </el-empty>
      </div>
      
      <div class="commission-footer" v-else-if="!commissionLoading && commissionDetails.details?.length">
        <div class="commission-summary">
          <div class="summary-item">
            <span class="summary-label">客户数量:</span>
            <span class="summary-value">{{ commissionDetails.details?.length || 0 }}位</span>
          </div>
          <div class="summary-item">
            <span class="summary-label">平均佣金:</span>
            <span class="summary-value">￥{{ calculateAverageCommission() }}</span>
          </div>
        </div>
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
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { ElMessage } from 'element-plus';
import { Loading, RefreshRight } from '@element-plus/icons-vue';
import {
  getUserInfo,
  getProgress,
  getCurrentCamp,
  getSuccessCount,
  getCommissionTotal,
  applyPromotion,
  leaveTeam,
  getCommissionDetail,
  getCampPeriodById,
} from '@/api/ambassador';
import { useRouter } from 'vue-router';

// 数据定义
const router = useRouter();
const userInfo = ref({});
const progress = ref({ current_count: 0, required_count: 50 });
const currentCamp = ref({ camp_name: '', start_date: '', end_date: '' });
const successCount = ref(0);
const commissionTotal = ref('￥0.00');
const avatarUrl = ref('');

// Canvas 相关引用
const welcomeCanvas = ref(null);
let animationFrame = null;

// 佣金明细相关数据
const commissionDialogVisible = ref(false);
const commissionDetails = ref({
  commission_type: '',
  camp_period_id: 0,
  details: [],
  total_commission: 0
});
const commissionLoading = ref(false);
const currentCampPeriodId = ref(1001); // 默认营期ID设为1001
// 添加选中的营期信息
const selectedCampInfo = ref({
  camp_name: '营期1001',
  start_date: '',
  end_date: ''
});

// 初始化粒子动画
const initParticleAnimation = () => {
  const canvas = welcomeCanvas.value;
  if (!canvas) return;
  
  const ctx = canvas.getContext('2d');
  const particles = [];
  const lines = [];
  
  // 设置Canvas尺寸
  const resizeCanvas = () => {
    const welcomeSection = canvas.parentElement;
    canvas.width = welcomeSection.offsetWidth;
    canvas.height = welcomeSection.offsetHeight;
  };
  
  // 监听窗口大小变化
  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();
  
  // 粒子类
  class Particle {
    constructor() {
      this.x = Math.random() * canvas.width;
      this.y = Math.random() * canvas.height;
      this.size = Math.random() * 3 + 1;
      this.speedX = Math.random() * 1 - 0.5;
      this.speedY = Math.random() * 1 - 0.5;
      this.color = `rgba(64, 158, 255, ${Math.random() * 0.5 + 0.1})`;
    }
    
    update() {
      // 碰撞边界反弹
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
  
  // 线条类
  class Line {
    constructor() {
      this.x1 = Math.random() * canvas.width;
      this.y1 = Math.random() * canvas.height;
      this.x2 = this.x1 + (Math.random() * 100 - 50);
      this.y2 = this.y1 + (Math.random() * 100 - 50);
      this.speedX1 = Math.random() * 0.5 - 0.25;
      this.speedY1 = Math.random() * 0.5 - 0.25;
      this.speedX2 = Math.random() * 0.5 - 0.25;
      this.speedY2 = Math.random() * 0.5 - 0.25;
      this.width = Math.random() * 1.5 + 0.5;
      this.color = `rgba(64, 158, 255, ${Math.random() * 0.3 + 0.1})`;
    }
    
    update() {
      // 边界反弹
      if (this.x1 > canvas.width || this.x1 < 0) this.speedX1 = -this.speedX1;
      if (this.y1 > canvas.height || this.y1 < 0) this.speedY1 = -this.speedY1;
      if (this.x2 > canvas.width || this.x2 < 0) this.speedX2 = -this.speedX2;
      if (this.y2 > canvas.height || this.y2 < 0) this.speedY2 = -this.speedY2;
      
      this.x1 += this.speedX1;
      this.y1 += this.speedY1;
      this.x2 += this.speedX2;
      this.y2 += this.speedY2;
    }
    
    draw() {
      ctx.strokeStyle = this.color;
      ctx.lineWidth = this.width;
      ctx.beginPath();
      ctx.moveTo(this.x1, this.y1);
      ctx.lineTo(this.x2, this.y2);
      ctx.stroke();
    }
  }
  
  // 初始化粒子和线条
  const init = () => {
    // 创建粒子
    for (let i = 0; i < 15; i++) {
      particles.push(new Particle());
    }
    
    // 创建线条
    for (let i = 0; i < 8; i++) {
      lines.push(new Line());
    }
  };
  
  // 动画循环
  const animate = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // 更新并绘制线条
    lines.forEach(line => {
      line.update();
      line.draw();
    });
    
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
          ctx.strokeStyle = `rgba(64, 158, 255, ${0.2 - distance/500})`;
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

// 计算佣金层级相关的计算属性
const promotionLevelText = computed(() => {
  const count = successCount.value || 0;
  if (count > 50) {
    return '高级推广大使';
  } else if (count > 20) {
    return '中级推广大使';
  } else {
    return '初级推广大使';
  }
});

const levelClass = computed(() => {
  const count = successCount.value || 0;
  if (count > 50) {
    return 'level-high';
  } else if (count > 20) {
    return 'level-medium';
  } else {
    return 'level-basic';
  }
});

const levelProgressPercentage = computed(() => {
  // 修正计算逻辑，展示整体进度
  const count = successCount.value || 0;
  return Math.min(100, Math.floor((count / 50) * 100));
});

const levelProgressText = computed(() => {
  const count = successCount.value || 0;
  if (count > 50) {
    return '您已达到最高推广层级';
  } else if (count > 20) {
    return `已推广 ${count} 人（中级）`;
  } else {
    return `已推广 ${count} 人（初级）`;
  }
});

const levelNextGoalText = computed(() => {
  const count = successCount.value || 0;
  if (count > 50) {
    return '享受最高佣金比例';
  } else if (count > 20) {
    return `距高级还需 ${Math.max(0, 51 - count)} 人`;
  } else {
    return `距中级还需 ${Math.max(0, 21 - count)} 人`;
  }
});

const levelProgressColor = computed(() => {
  const count = successCount.value || 0;
  if (count > 50) {
    return '#67C23A';  // 绿色
  } else if (count > 20) {
    return '#E6A23C';  // 橙色
  } else {
    return '#409EFF';  // 蓝色
  }
});

// 计算属性
const progressPercentage = computed(() => {
  if (!progress.value || typeof progress.value.current_count !== 'number' || typeof progress.value.required_count !== 'number' || progress.value.required_count === 0) {
    return 0;
  }
  return Math.min(100, Math.floor((progress.value.current_count / progress.value.required_count) * 100));
});

// 格式化函数
const format = (percentage) => {
  return percentage + '%';
};

const formatDate = (dateStr) => {
  if (!dateStr) return '';
  return dateStr;
};

// 页面跳转
const goToUserCenter = () => {
  router.push('/profile');
};

// 申请晋升
const handleApplyPromotion = async () => {
  try {
    // 检查是否满足晋升条件
    const currentProgress = progress.value.current_count || 0;
    const requiredProgress = progress.value.required_count || 50;
    
    // 如果当前进度小于所需进度，显示错误提示并返回
    if (currentProgress < requiredProgress) {
      const remaining = requiredProgress - currentProgress;
      ElMessage({
        message: `晋升条件未满足！您当前还需要再完成${remaining}个推广才能申请晋升。`,
        type: 'warning',
        duration: 5000,
        showClose: true
      });
      return;
    }
    
    // 显示确认对话框
    await ElMessage.confirm(`您当前已完成${currentProgress}个推广，满足晋升条件。确认申请晋升吗？`, '申请晋升', {
      confirmButtonText: '确认申请',
      cancelButtonText: '取消',
      type: 'info'
    });
    
    // 用户确认后，发送申请
    const res = await applyPromotion();
    
    // 成功提示
    ElMessage({
      message: res.msg || '申请晋升成功！您的申请已提交，请等待管理员审核。',
      type: 'success',
      duration: 3000
    });
    
    // 刷新数据
    await fetchProgress();
  } catch (error) {
    // 如果是用户取消操作，不显示错误
    if (error === 'cancel') return;
    
    // 显示错误信息
    ElMessage({
      message: error.message || '申请晋升失败，请稍后重试',
      type: 'error',
      duration: 5000,
      showClose: true
    });
  }
};

// 离开团队
const handleLeaveTeam = async () => {
  try {
    await ElMessage.confirm('确认要离开当前团队吗？', '提示', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      type: 'warning'
    });
    
    const res = await leaveTeam();
    ElMessage.success(res.msg);
    // 重新获取用户信息
    await fetchUserInfo();
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.message || '操作失败');
    }
  }
};

// 加载用户信息
const fetchUserInfo = async () => {
  try {
    const res = await getUserInfo();
    if (res.code === 1 && res.data) {
      userInfo.value = res.data;
    } else {
      console.error('获取用户信息失败: 返回数据格式错误');
    }
  } catch (error) {
    console.error('获取用户信息失败', error);
    if (error.response) {
      console.error('错误状态码:', error.response.status);
      console.error('错误详情:', error.response.data);
      
      // 如果是401错误，可能是token问题，尝试重新登录
      if (error.response.status === 401) {
        ElMessage.error('登录状态已失效，请重新登录');
        setTimeout(() => {
          // 清除token并跳转到登录页
          localStorage.removeItem('token');
          router.push('/login');
        }, 1500);
      }
    }
  }
};

// 加载成长进度
const fetchProgress = async () => {
  try {
    const res = await getProgress();
    if (res.code === 1 && res.data) {
      progress.value = res.data;
    } else {
      console.error('获取成长进度失败: 返回数据格式错误');
    }
  } catch (error) {
    console.error('获取成长进度失败', error);
    // 设置默认值
    progress.value = { current_count: 0, required_count: 50 };
  }
};

// 加载当前营期
const fetchCurrentCamp = async () => {
  try {
    // 使用固定营期ID 1001
    const res = await getCurrentCamp(1001);
    if (res.code === 1 && res.data) {
      currentCamp.value = res.data;
      // 获取有营期ID相关的数据，使用固定ID 1001，但不再请求推广层级
      await Promise.all([
        fetchSuccessCount(),
        fetchCommissionTotal()
      ]);
    } else {
      console.error('获取当前营期失败: 返回数据格式错误');
      // 使用默认值
      currentCamp.value = { camp_name: '当前营期', start_date: '', end_date: '', camp_period_id: 1001 };
      // 尝试获取其他数据，不包含推广层级
      await Promise.all([
        fetchSuccessCount(),
        fetchCommissionTotal()
      ]);
    }
  } catch (error) {
    console.error('获取当前营期失败', error);
    // 使用默认值
    currentCamp.value = { camp_name: '当前营期', start_date: '', end_date: '', camp_period_id: 1001 };
    // 尝试获取其他数据，不包含推广层级
    await Promise.all([
      fetchSuccessCount(),
      fetchCommissionTotal()
    ]);
  }
};

// 加载成功推广数
const fetchSuccessCount = async () => {
  try {
    // 使用固定营期ID 1001
    const res = await getSuccessCount(1001);
    successCount.value = res.data?.success_count || 0;
  } catch (error) {
    console.error('获取推广数失败', error);
    // 设置默认值
    successCount.value = 0;
  }
};

// 加载佣金总额
const fetchCommissionTotal = async () => {
  try {
    // 修改逻辑：直接通过佣金明细接口获取数据，在前端计算总和
    const campId = 1001; // 固定使用营期ID 1001
    const res = await getCommissionDetail(campId);
    
    if (res.code === 1 && res.data && Array.isArray(res.data.details) && res.data.details.length > 0) {
      // 从明细中计算总额
      const totalAmount = res.data.details.reduce((sum, item) => {
        // 尝试将佣金金额转为数字
        let amount = 0;
        if (item.commission_amount !== undefined && item.commission_amount !== null) {
          // 如果是字符串并包含¥符号，去除符号
          if (typeof item.commission_amount === 'string' && item.commission_amount.includes('￥')) {
            amount = parseFloat(item.commission_amount.replace('￥', '')) || 0;
          } else {
            amount = parseFloat(item.commission_amount) || 0;
          }
        }
        return sum + amount;
      }, 0);
      
      // 格式化为带单个￥符号的金额字符串
      commissionTotal.value = `￥${totalAmount.toFixed(2)}`;
    } else if (res.code === 1 && res.data && typeof res.data.total_commission === 'number') {
      // 如果明细为空但有总额，使用总额
      commissionTotal.value = `￥${res.data.total_commission.toFixed(2)}`;
    } else {
      // 如果没有数据或数据格式不正确，使用默认值
      commissionTotal.value = '￥0.00';
    }
  } catch (error) {
    console.error('获取佣金总额失败', error);
    // 设置默认值
    commissionTotal.value = '￥0.00';
  }
};

// 计算平均佣金
const calculateAverageCommission = () => {
  const details = commissionDetails.value?.details || [];
  if (!details || details.length === 0) return '0.00';
  
  const total = details.reduce((sum, item) => sum + (item.commission_amount || 0), 0);
  return (total / details.length).toFixed(2);
};

// 查看佣金明细 - 修改为接受可选的campPeriodId参数，并更新营期信息
const viewCommissionDetails = async (campPeriodId) => {
  try {
    commissionDialogVisible.value = true;
    commissionLoading.value = true;
    
    // 使用传入的营期ID或当前选择的ID
    // 确保传入的是数字，而不是事件对象
    let targetCampId;
    if (campPeriodId && typeof campPeriodId === 'number') {
      targetCampId = campPeriodId;
    } else {
      targetCampId = parseInt(currentCampPeriodId.value) || 1001;
    }
    
    // 更新当前选择的营期ID
    currentCampPeriodId.value = targetCampId;
    
    // 尝试获取营期信息
    try {
      await updateCampInfoById(targetCampId);
    } catch (error) {
      console.error('获取营期信息失败，使用默认值', error);
      // 即使获取营期信息失败，也继续获取佣金明细
    }
    
    ElMessage.info('正在加载佣金明细...');
    
    console.log('请求营期ID:', targetCampId); // 调试日志
    
    const res = await getCommissionDetail(targetCampId);
    if (res.code === 1) {
      commissionDetails.value = res.data || {};
      
      // 对明细按时间降序排序，最新的排在前面
      if (commissionDetails.value.details && commissionDetails.value.details.length > 0) {
        commissionDetails.value.details.sort((a, b) => new Date(b.time) - new Date(a.time));
        
        // 如果有数据则显示成功提示
        ElMessage.success(`成功加载${selectedCampInfo.value.camp_name || `营期${targetCampId}`}的佣金明细`);
      } else {
        // 如果没有明细数据，显示友好提示
        ElMessage.warning(`${selectedCampInfo.value.camp_name || `营期${targetCampId}`}中没有任何推广数据记录`);
      }
    } else {
      ElMessage.error(res.msg || '获取佣金明细失败');
    }
  } catch (error) {
    console.error('获取佣金明细失败', error);
    // 显示更具体的错误提示
    if (error.message && error.message.includes("doesn't exist")) {
      ElMessage.error('佣金明细接口错误：数据库表不存在，请联系开发人员修复');
    } else {
      ElMessage.error('获取佣金明细失败，请稍后重试');
    }
  } finally {
    commissionLoading.value = false;
  }
};

// 添加方法：通过ID获取并更新营期信息
const updateCampInfoById = async (campId) => {
  try {
    // 如果当前营期ID与请求的ID相同，直接使用它
    if (currentCamp.value && currentCamp.value.camp_period_id === campId) {
      selectedCampInfo.value = { ...currentCamp.value };
      return;
    }
    
    // 调用API获取特定营期的信息
    const res = await getCampPeriodById(campId);
    if (res.code === 1 && res.data) {
      // 更新selectedCampInfo为API返回的数据
      selectedCampInfo.value = res.data;
    } else {
      // 如果API返回失败或没有数据，使用默认值
      selectedCampInfo.value = {
        camp_name: `营期${campId}`,
        camp_period_id: campId,
        start_date: '',
        end_date: ''
      };
      console.warn(`获取营期${campId}信息失败，使用默认值`);
    }
    
  } catch (error) {
    console.error('获取营期信息失败', error);
    // 设置默认值
    selectedCampInfo.value = {
      camp_name: `营期${campId}`,
      camp_period_id: campId,
      start_date: '',
      end_date: ''
    };
  }
};

// 重新加载佣金明细
const reloadCommissionDetails = () => {
  // 检查输入的ID是否有效
  if (!currentCampPeriodId.value) {
    ElMessage.warning('请输入有效的营期ID');
    return;
  }
  
  // 将输入框的值转换为数字
  const campId = parseInt(currentCampPeriodId.value);
  if (isNaN(campId) || campId <= 0) {
    ElMessage.warning('营期ID必须是正整数');
    return;
  }
  
  // 加载指定营期的佣金明细
  // 直接传递数字ID，不传递事件对象
  viewCommissionDetails(campId);
};

// 处理查看佣金明细按钮点击
const handleViewCommissionDetails = () => {
  // 如果当前有营期信息，先更新选中的营期数据
  if (currentCamp.value && currentCamp.value.camp_period_id) {
    // 设置当前营期ID为系统当前营期
    currentCampPeriodId.value = currentCamp.value.camp_period_id;
    // 复制当前营期信息到选中营期
    selectedCampInfo.value = { ...currentCamp.value };
  } else {
    // 如果没有当前营期信息，使用默认值1001
    currentCampPeriodId.value = 1001;
    selectedCampInfo.value = {
      camp_name: '营期1001',
      start_date: '',
      end_date: ''
    };
  }
  
  // 不传递参数，让viewCommissionDetails函数内部使用默认值
  viewCommissionDetails();
};

// 在页面加载时添加字体链接和初始化动画
onMounted(() => {
  // 添加Google字体链接
  const fontLink = document.createElement('link');
  fontLink.rel = 'stylesheet';
  fontLink.href = 'https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Nunito:wght@400;500;600;700&family=Source+Sans+Pro:wght@400;600;700&display=swap';
  document.head.appendChild(fontLink);
  
  // 数据加载
  loadData();
  
  // 初始化粒子动画，并获取清理函数
  const cleanupParticleAnimation = initParticleAnimation();
  
  // 组件卸载时清理
  onUnmounted(() => {
    if (cleanupParticleAnimation) {
      cleanupParticleAnimation();
    }
  });
});

// 加载数据的函数
const loadData = async () => {
  try {
    await fetchUserInfo();
    await fetchProgress();
    await fetchCurrentCamp();
  } catch (error) {
    console.error('加载数据失败', error);
    ElMessage({
      message: '数据加载失败：后端数据库查询存在问题，请联系系统管理员',
      type: 'error',
      duration: 8000
    });
  }
};

// 添加一个格式化佣金金额的方法
const formatCommissionAmount = (amount) => {
  if (amount === undefined || amount === null) return '￥0.00';
  
  // 如果已经是格式化的字符串，直接返回
  if (typeof amount === 'string' && amount.includes('￥')) {
    return amount;
  }
  
  // 尝试转换为数字
  const numAmount = parseFloat(amount);
  
  // 如果是有效数字，进行格式化
  if (!isNaN(numAmount)) {
    return `￥${numAmount.toFixed(2)}`;
  }
  
  // 默认返回
  return '￥0.00';
};

// 添加计算属性 - 在script setup部分的computed部分添加
// 是否可以申请晋升
const canApplyPromotion = computed(() => {
  const currentCount = progress.value.current_count || 0;
  const requiredCount = progress.value.required_count || 50;
  return currentCount >= requiredCount;
});

// 还需要完成的推广数量
const remainingPromotions = computed(() => {
  const currentCount = progress.value.current_count || 0;
  const requiredCount = progress.value.required_count || 50;
  return Math.max(0, requiredCount - currentCount);
});
</script>

<style scoped>
/* 全局字体变量 */
:root {
  --main-font: 'Microsoft YaHei', '微软雅黑', 'Source Sans Pro', 'Nunito', 'HarmonyOS Sans SC', 'PingFang SC', 'Hiragino Sans GB', sans-serif;
  --title-font: 'Microsoft YaHei', '微软雅黑', 'Montserrat', 'HarmonyOS Sans SC', 'PingFang SC', 'Hiragino Sans GB', sans-serif;
  --number-font: 'Microsoft YaHei', '微软雅黑', 'DIN Alternate', 'DIN Condensed', 'Source Sans Pro', 'HarmonyOS Sans SC', sans-serif;
}

.dashboard-container {
  min-height: 100vh;
  background-color: #f5f9fc;
  display: flex;
  flex-direction: column;
  width: 100vw;
  margin: 0;
  padding: 0;
  overflow-x: hidden;
  box-sizing: border-box;
  font-family: var(--main-font);
  letter-spacing: 0.01em; /* 微调字间距以适应微软雅黑 */
  line-height: 1.5;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

.header {
  background-color: #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 12px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  position: sticky;
  top: 0;
  z-index: 100;
  width: 100%;
  box-sizing: border-box;
}

.logo {
  font-size: 20px;
  font-weight: 600;
  color: #409EFF;
  letter-spacing: 0.5px;
  font-family: var(--title-font);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-center-btn {
  background-color: transparent;
  color: #606266;
  border: 1px solid #dcdfe6;
  font-size: 14px;
  height: 36px;
  padding: 0 16px;
  border-radius: 4px;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 5px;
}

.user-center-btn:hover {
  color: #409EFF;
  border-color: #c6e2ff;
  background-color: #ecf5ff;
}

.user-center-btn i {
  font-size: 16px;
}

.main-content {
  padding: 24px;
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: 24px;
  width: 100%;
  min-width: 100%;
  box-sizing: border-box;
  margin: 0;
}

.welcome-section {
  margin-bottom: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(to right, #f1f8ff, #ffffff);
  padding: 16px 20px;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
  position: relative;
  overflow: hidden; /* 确保动画不会溢出 */
}

.welcome-canvas {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  pointer-events: none; /* 确保可以点击背景下的元素 */
}

.welcome-text {
  font-size: 22px;
  color: #2c3e50;
  font-weight: 600;
  margin: 0;
  font-family: var(--title-font);
  letter-spacing: 0.02em;
  position: relative;
  z-index: 2; /* 确保文字在动画上方 */
}

.header-actions {
  display: flex;
  gap: 10px;
  position: relative;
  z-index: 2; /* 确保按钮在动画上方 */
}

.content-container-vertical {
  display: flex;
  flex-direction: column;
  gap: 24px;
  width: 100%;
}

.progress-card, .combined-card {
  margin-bottom: 0;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
  transition: all 0.3s;
  overflow: hidden;
  width: 100%;
  border: none;
}

.progress-card {
  background: linear-gradient(145deg, #f9fdff, #f0f8ff);
}

.combined-card {
  background: linear-gradient(145deg, #ffffff, #f8fbff);
}

.progress-card:hover, .combined-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  color: #409EFF;
  padding: 5px 0;
  font-family: var(--title-font);
  letter-spacing: 0.03em;
}

.card-header span {
  font-size: 18px; /* 增大标题字体大小 */
  display: flex;
  align-items: center;
  gap: 6px;
}

.card-header span i {
  font-size: 18px; /* 图标大小与文字匹配 */
}

.combined-content {
  padding: 16px 20px;
  display: flex;
  flex-direction: column;
  gap: 25px;
}

.section-title {
  font-size: 18px;
  color: #2c3e50;
  margin: 0 0 15px 0;
  font-weight: 600;
  position: relative;
  padding-left: 12px;
  border-left: 3px solid #409EFF;
  font-family: var(--title-font);
  letter-spacing: 0.02em;
}

.section-divider {
  height: 1px;
  background: linear-gradient(to right, rgba(0,0,0,0.03), rgba(0,0,0,0.08), rgba(0,0,0,0.03));
  width: 100%;
  margin: 5px 0;
}

.camp-section, .stats-section {
  padding: 0;
}

.camp-info {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.info-item {
  display: flex;
  align-items: center;
}

.info-label {
  width: 90px;
  font-weight: 500;
  color: #606266;
  font-size: 14px;
}

.info-value {
  color: #2c3e50;
  font-size: 15px;
  font-weight: 500;
}

.level-badge {
  display: inline-block;
  padding: 2px 10px;
  background-color: #ecf5ff;
  color: #409EFF;
  border-radius: 4px;
  font-weight: 600;
  border: 1px solid #d9ecff;
  letter-spacing: 0.03em;
}

.level-basic {
  background-color: #ecf5ff;
  color: #409EFF;
  border-color: #d9ecff;
}

.level-medium {
  background-color: #fdf6ec;
  color: #E6A23C;
  border-color: #faecd8;
}

.level-high {
  background-color: #f0f9eb;
  color: #67C23A;
  border-color: #e1f3d8;
}

.level-progress-container {
  margin-top: 15px;
  padding: 5px 0;
}

.level-progress-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 5px;
  font-size: 13px;
  color: #606266;
  letter-spacing: 0.02em;
}

.level-progress {
  margin: 10px 0;
}

.level-markers {
  display: flex;
  margin-top: 5px;
  padding: 0 2px;
  position: relative;
  justify-content: space-between;
}

.level-markers::before {
  content: '';
  position: absolute;
  height: 1px;
  background-color: #E4E7ED;
  width: 100%;
  top: 6px;
  z-index: 0;
}

.marker {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

/* 根据实际层级规则调整位置 */
.marker-initial {
  position: absolute;
  left: 0;
}

.marker-medium {
  position: absolute;
  left: 40%; /* 20/50 = 40% */
}

.marker-high {
  position: absolute;
  right: 0;
}

.marker-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: #DCDFE6;
  margin-bottom: 5px;
  z-index: 1;
}

.marker.active .marker-dot {
  background-color: #67C23A;
}

.marker-label {
  font-size: 12px;
  color: #909399;
  font-weight: 500;
  letter-spacing: 0.03em;
}

.marker.active .marker-label {
  color: #67C23A;
  font-weight: 600;
}

.progress-content {
  padding: 16px 20px;
}

.progress-title {
  font-size: 16px;
  color: #2c3e50;
  margin-bottom: 20px;
  font-weight: 600;
  font-family: var(--title-font);
  letter-spacing: 0.02em;
}

.custom-progress :deep(.el-progress-bar__outer) {
  border-radius: 10px;
  background-color: #e9f1fd;
}

.custom-progress :deep(.el-progress-bar__inner) {
  border-radius: 10px;
  background: linear-gradient(to right, #409EFF, #67c23a);
}

.progress-info {
  margin-top: 16px;
  text-align: center;
  color: #606266;
  font-size: 15px;
  letter-spacing: 0.02em;
}

.progress-actions {
  margin-top: 25px;
  display: flex;
  justify-content: center;
}

.promotion-btn {
  width: 150px;
  height: 40px;
  font-weight: 600;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
}

.promotion-btn:not(:disabled):hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.promotion-btn:disabled {
  background-color: #a0cfff;
  border-color: #a0cfff;
  color: #ffffff;
  cursor: not-allowed;
  opacity: 0.8;
}

.promotion-btn:disabled:hover {
  background-color: #a0cfff;
  border-color: #a0cfff;
  color: #ffffff;
}

.highlight {
  color: #409EFF;
  font-weight: 700;
  font-size: 18px;
  font-family: var(--number-font);
}

.stats-content {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding: 10px 0;
}

.stat-item {
  text-align: center;
  padding: 0 15px;
  flex: 1;
}

.stat-divider {
  width: 1px;
  height: 60px;
  background: linear-gradient(to bottom, rgba(0,0,0,0.03), rgba(0,0,0,0.08), rgba(0,0,0,0.03));
}

.stat-title {
  color: #606266;
  margin-bottom: 10px;
  font-size: 15px;
  font-weight: 500;
  letter-spacing: 0.02em;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #409EFF;
  margin-bottom: 6px;
  font-family: var(--number-font);
  letter-spacing: 0.01em;
}

.stat-desc {
  color: #909399;
  font-size: 12px;
  letter-spacing: 0.02em;
}

.commission-item {
  position: relative;
  padding-bottom: 30px; /* 增大底部空间以容纳更大的按钮 */
}

.commission-detail-btn-wrapper {
  position: absolute;
  bottom: -5px;
  right: 0;
  text-align: right;
  width: 100%;
}

.commission-detail-btn {
  font-size: 14px;
  padding: 6px 16px;
  border-radius: 20px;
  background-color: #409EFF;
  border-color: #409EFF;
  color: #fff;
  font-weight: 500;
  transition: all 0.3s;
  box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
}

.commission-detail-btn:hover {
  color: #fff;
  background-color: #66b1ff;
  border-color: #66b1ff;
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(64, 158, 255, 0.4);
}

.footer {
  text-align: center;
  padding: 15px;
  color: #909399;
  font-size: 13px;
  margin-top: 20px;
  width: 100%;
  box-sizing: border-box;
  background-color: #fff;
  border-top: 1px solid #f0f0f0;
  letter-spacing: 0.03em;
}

/* 响应式设计 */
@media (max-width: 1400px) {
  .main-content {
    padding: 20px;
    gap: 20px;
  }
  
  .content-container-vertical {
    gap: 20px;
  }
}

@media (max-width: 992px) {
  /* 移除之前的响应式布局，因为现在始终是上下排列 */
}

@media (max-width: 768px) {
  .header {
    padding: 12px 15px;
  }
  
  .welcome-section {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
    padding: 12px 15px;
  }
  
  .welcome-text {
    font-size: 20px;
  }
  
  .main-content {
    padding: 12px;
  }
  
  .combined-content, .progress-content {
    padding: 12px 15px;
  }
  
  .card-header {
    font-size: 16px;
  }
  
  .card-header span {
    font-size: 17px; /* 响应式调整 */
  }
  
  .info-label {
    width: 80px;
    font-size: 13px;
  }
  
  .info-value {
    font-size: 14px;
  }
  
  .stat-value {
    font-size: 24px;
  }
}

@media (max-width: 576px) {
  .progress-actions {
    flex-direction: column;
  }
  
  .stats-content {
    flex-direction: column;
    gap: 20px;
  }
  
  .stat-divider {
    width: 80%;
    height: 1px;
    margin: 5px auto;
  }
  
  .stat-item {
    padding: 10px 0;
  }
}

.camp-name {
  font-weight: 600;
  color: #409EFF;
  font-size: 16px;
}

/* 佣金明细弹窗样式 */
.commission-dialog :deep(.el-dialog__header) {
  padding: 20px;
  border-bottom: 1px solid #f0f0f0;
  margin: 0;
}

.commission-dialog :deep(.el-dialog__title) {
  font-weight: 600;
  color: #409EFF;
  font-size: 18px;
  font-family: var(--title-font);
  letter-spacing: 0.03em;
}

.commission-dialog :deep(.el-dialog__body) {
  padding: 20px 25px;
}

.commission-dialog :deep(.el-dialog__footer) {
  padding: 15px 20px;
  border-top: 1px solid #f0f0f0;
}

.commission-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px dashed #e0e0e0;
}

.commission-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.info-row {
  display: flex;
  align-items: center;
}

.info-label {
  font-weight: 500;
  color: #606266;
  margin-right: 8px;
  width: 80px;
  display: inline-block;
  font-size: 14px;
}

.info-value {
  color: #2c3e50;
  font-weight: 500;
  font-size: 14px;
}

.commission-total {
  text-align: right;
  padding: 8px 15px;
  background: #f8f9fb;
  border-radius: 6px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
}

.total-label {
  color: #606266;
  font-weight: 500;
  margin-right: 10px;
  font-size: 15px;
}

.total-value {
  color: #f56c6c;
  font-weight: 700;
  font-size: 20px;
  font-family: var(--number-font);
}

.commission-amount {
  color: #f56c6c;
  font-weight: 600;
  font-family: var(--number-font);
}

.commission-footer {
  margin-top: 20px;
  padding-top: 15px;
  border-top: 1px dashed #e0e0e0;
}

.commission-summary {
  display: flex;
  justify-content: space-between;
  padding: 10px 15px;
  background: #f8f9fb;
  border-radius: 6px;
}

.summary-item {
  display: flex;
  align-items: center;
}

.summary-label {
  font-weight: 500;
  color: #606266;
  margin-right: 8px;
  font-size: 14px;
}

.summary-value {
  color: #409EFF;
  font-weight: 600;
  font-size: 15px;
  font-family: var(--number-font);
}

/* 新增样式 */
.camp-id-input {
  margin-top: 10px;
  display: flex;
  align-items: center;
}

.camp-id-input .el-input {
  width: 120px;
}

.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 30px 0;
  color: #909399;
  flex-direction: column;
  gap: 10px;
}

.loading-container .el-icon {
  font-size: 24px;
  color: #409EFF;
  margin-bottom: 10px;
}

/* 添加空状态样式 */
.el-empty :deep(.el-empty__description) {
  margin-top: 15px;
}

.empty-hint {
  font-size: 13px;
  color: #909399;
  margin-top: 5px;
}

.commission-footer .el-empty {
  padding: 20px 0;
}

/* 调整表格内文字居中 */
.el-table :deep(td) {
  text-align: center;
}

/* 响应式调整 */
@media (max-width: 576px) {
  .commission-header {
    flex-direction: column;
    gap: 15px;
  }
  
  .commission-total {
    width: 100%;
    text-align: center;
  }
  
  .commission-summary {
    flex-direction: column;
    gap: 10px;
  }
  
  .summary-item {
    justify-content: space-between;
    width: 100%;
  }
}
</style> 