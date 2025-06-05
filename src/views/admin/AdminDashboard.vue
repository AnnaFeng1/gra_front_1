<template>
  <div class="admin-dashboard">
    <AdminNavBar activePage="dashboard" />
    <div class="main-content">
      <!-- 欢迎信息 -->
      <div class="welcome-section">
        <!-- 添加动效背景 Canvas -->
        <canvas ref="welcomeCanvas" class="welcome-canvas"></canvas>
        <div class="welcome-content">
          <h2 class="welcome-text">欢迎！{{ userInfo.username }} <el-tag type="danger">系统管理员</el-tag></h2>
        </div>
        <!-- 添加刷新按钮 -->
        <div class="welcome-actions">
          <el-tooltip
            content="刷新数据"
            placement="bottom"
            :disabled="loading"
          >
            <el-button 
              class="refresh-btn" 
              :disabled="loading"
              @click="refreshData"
              type="primary"
              circle
              :loading="loading">
              <el-icon :size="22"><RefreshRight /></el-icon>
            </el-button>
          </el-tooltip>
        </div>
      </div>
      
      <!-- 当前目标营期数据概览 -->
      <div class="data-overview" v-loading="isLoading">
        <!-- 当前目标营期和汇总数据卡片 -->
        <el-card class="overview-card" v-loading="loading">
          <div class="overview-content">
            <!-- 营期信息部分 -->
            <div class="camp-section">
              <h3 class="section-title">当前目标营期</h3>
              <div class="camp-info">
                <div class="camp-name-row">
                  <span class="camp-name">{{ overviewData.campInfo?.campName || '加载中...' }}</span>
                </div>
                
                <div class="camp-timeline-container">
                  <div class="camp-timeline">
                    <div class="timeline-dates">
                      <span class="start-date">{{ formatDate(overviewData.campInfo?.startDate) }}</span>
                      <span class="end-date">{{ formatDate(overviewData.campInfo?.endDate) }}</span>
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
                    :content="currentCampId === 1001 ? '当前已是最近营期' : '查看下一个营期'"
                    placement="top"
                  >
                    <el-button 
                      class="camp-nav-btn next-btn" 
                      :disabled="loading || currentCampId === 1001"
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
            
            <!-- 数据统计部分 -->
            <div class="stats-section">
              <h3 class="section-title">推广数据统计</h3>
              <div class="stats-grid">
                <div class="stat-card">
                  <div class="stat-icon conversions-icon">
                    <i class="el-icon-data-line"></i>
                  </div>
                  <div class="stat-info">
                    <div class="stat-title">总转化数</div>
                    <div class="stat-value">{{ overviewData.totalConversions || 0 }}</div>
                    <div class="stat-desc">当前目标营期转化</div>
                  </div>
                </div>
                
                <div class="stat-card">
                  <div class="stat-icon teams-icon">
                    <i class="el-icon-s-cooperation"></i>
                  </div>
                  <div class="stat-info">
                    <div class="stat-title">推广团队数</div>
                    <div class="stat-value">{{ overviewData.totalTeams || 0 }}</div>
                    <div class="stat-desc">活跃团队总数</div>
                  </div>
                </div>
                
                <div class="stat-card">
                  <div class="stat-icon ambassadors-icon">
                    <i class="el-icon-user"></i>
                  </div>
                  <div class="stat-info">
                    <div class="stat-title">推广大使数</div>
                    <div class="stat-value">{{ overviewData.totalAmbassadors || 0 }}</div>
                    <div class="stat-desc">参与推广人数</div>
                  </div>
                </div>
                
                <div class="stat-card">
                  <div class="stat-icon commission-icon">
                    <i class="el-icon-money"></i>
                  </div>
                  <div class="stat-info">
                    <div class="stat-title">总佣金金额</div>
                    <div class="stat-value">¥{{ formatAmount(overviewData.totalCommission) }}</div>
                    <div class="stat-desc">已发放佣金</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </div>
      
      <!-- 推广之星图表区域 -->
      <div class="marketing-stars-charts" v-loading="marketingStarsData.loading">
        <div class="chart-header">
          <div class="title">
            <h2>推广之星 - {{ overviewData.currentCamp?.campName || '当前目标营期' }}</h2>
            <span class="subtitle">展示当前目标营期的最佳团队和推广大使数据</span>
          </div>
        </div>
        
        <div class="charts-container">
          <div class="chart-card team-chart-card">
            <div class="chart-icon">
              <el-icon class="trophy-icon"><TrophyBase /></el-icon>
            </div>
            <div class="chart-content" ref="teamChartRef">
              <div v-if="!marketingStarsData.loading && (!marketingStarsData.topTeams || marketingStarsData.topTeams.length === 0)" class="no-data">
                <el-empty description="暂无团队数据" />
              </div>
            </div>
          </div>
          
          <div class="chart-card ambassador-chart-card">
            <div class="chart-icon">
              <el-icon class="medal-icon"><Medal /></el-icon>
            </div>
            <div class="chart-content" ref="ambassadorChartRef">
              <div v-if="!marketingStarsData.loading && (!marketingStarsData.topAmbassadors || marketingStarsData.topAmbassadors.length === 0)" class="no-data">
                <el-empty description="暂无推广大使数据" />
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 创建一个包装容器包含趋势和佣金分析图表 -->
      <div class="charts-row-container">
        <!-- 转化趋势分析图表 -->
        <div class="trends-chart-section" v-loading="trendsData.loading">
          <div class="chart-header">
            <div class="title">
              <h2>转化趋势分析</h2>
              <span class="subtitle">展示多个营期的转化数据变化趋势</span>
            </div>
          </div>
          
          <div class="trends-chart-container">
            <div class="chart-card trends-chart-card">
              <div class="chart-icon">
                <el-icon class="trend-icon"><TrendCharts /></el-icon>
              </div>
              <div class="trends-chart-content" ref="trendsChartRef">
                <div v-if="!trendsData.loading && (!trendsData.trendData || trendsData.trendData.length === 0)" class="no-data">
                  <el-empty description="暂无趋势数据" />
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 佣金分配分析图表 -->
        <div class="commission-chart-section" v-loading="commissionData.loading">
          <div class="chart-header">
            <div class="title">
              <h2>佣金分配分析</h2>
              <span class="subtitle">展示当前目标营期的佣金分配情况</span>
            </div>
          </div>
          
          <div class="commission-chart-container">
            <div class="chart-card commission-chart-card">
              <div class="chart-icon">
                <el-icon class="money-icon"><Money /></el-icon>
              </div>
              <div class="commission-chart-content" ref="commissionChartRef">
                <div v-if="!commissionData.loading && (!commissionData.byType || commissionData.byType.length === 0)" class="no-data">
                  <el-empty description="暂无佣金分配数据" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import AdminNavBar from '@/components/AdminNavBar.vue';
import { ref, reactive, onMounted, onUnmounted, nextTick } from 'vue';
import { ElMessage } from 'element-plus';
import { getDashboardOverview, getMarketingStars, getConversionTrends, getCommissionDistribution } from '@/api/admin';
import { RefreshRight, ArrowLeft, ArrowRight, TrophyBase, Medal, TrendCharts, Money } from '@element-plus/icons-vue';
import * as echarts from 'echarts/core';
import { BarChart, PieChart, LineChart } from 'echarts/charts';
import { TooltipComponent, TitleComponent, LegendComponent, GridComponent } from 'echarts/components';
import { CanvasRenderer } from 'echarts/renderers';

// 注册必须的组件
echarts.use([
  BarChart,
  PieChart,
  LineChart,
  TooltipComponent,
  TitleComponent,
  LegendComponent,
  GridComponent,
  CanvasRenderer
]);

// 创建欢迎Canvas的引用
const welcomeCanvas = ref(null);

// 数据加载状态
const loading = ref(false);
const isLoading = ref(false);

// 用户信息，初始化为空
const userInfo = ref({
  username: '',
  role: 'admin'
});

// 当前目标营期ID
const currentCampId = ref(1001);

// 概览数据
const overviewData = reactive({
  totalConversions: 0,
  totalTeams: 0,
  totalAmbassadors: 0,
  totalCommission: 0,
  campInfo: {
    campId: '',
    campName: '加载中...',
    startDate: null,
    endDate: null,
    daysLeft: 0
  }
});

// 推广之星数据
const marketingStarsData = reactive({
  topTeams: [],
  topAmbassadors: [],
  loading: false
});

// 趋势数据
const trendsData = reactive({
  loading: false,
  trendData: [],
  currentCampId: null
});

// 佣金分配数据
const commissionData = reactive({
  loading: false,
  dimension: 'type', // 只保留类型维度
  totalCommission: 0,
  byType: [],
  campInfo: null
});

// 图表DOM引用
const teamChartRef = ref(null);
const ambassadorChartRef = ref(null);
const trendsChartRef = ref(null);
const commissionChartRef = ref(null);
let teamChart = null;
let ambassadorChart = null;
let trendsChart = null;
let commissionChart = null;

// 组件是否已卸载的标志
const isComponentUnmounted = ref(false);

// 格式化日期
const formatDate = (dateStr) => {
  // 当营期ID为1001时，覆盖日期显示
  if (currentCampId.value === 1001) {
    // 检查是否是开始日期或结束日期
    if (dateStr === overviewData.campInfo?.startDate) {
      return '2025-05-03';
    } else if (dateStr === overviewData.campInfo?.endDate) {
      return '2025-06-05';
    }
  }
  // 当营期ID为1000时，覆盖日期显示
  else if (currentCampId.value === 1000) {
    // 检查是否是开始日期或结束日期
    if (dateStr === overviewData.campInfo?.startDate) {
      return '2025-04-10';
    } else if (dateStr === overviewData.campInfo?.endDate) {
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

// 计算营期进度百分比
const calculateProgress = () => {
  if (!overviewData.campInfo) return 0;
  
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
    if (!overviewData.campInfo.startDate || !overviewData.campInfo.endDate) return 0;
    startDate = new Date(overviewData.campInfo.startDate);
    endDate = new Date(overviewData.campInfo.endDate);
  }
  
  const now = new Date();
  
  if (now < startDate) return 0;
  if (now > endDate) return 100;
  
  const totalDuration = endDate - startDate;
  const elapsedDuration = now - startDate;
  
  return Math.round((elapsedDuration / totalDuration) * 100);
};

// 计算已经过的天数
const calculateDaysElapsed = () => {
  if (!overviewData.campInfo) return 0;
  
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
    if (!overviewData.campInfo.startDate) return 0;
    startDate = new Date(overviewData.campInfo.startDate);
  }
  
  const now = new Date();
  
  if (now < startDate) return 0;
  
  const diffTime = Math.abs(now - startDate);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
};

// 计算剩余天数
const calculateDaysLeft = () => {
  if (!overviewData.campInfo) return 0;
  
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
    if (!overviewData.campInfo.endDate) return 0;
    endDate = new Date(overviewData.campInfo.endDate);
  }
  
  const now = new Date();
  
  // 如果当前日期已经超过结束日期，返回0
  if (now >= endDate) return 0;
  
  const diffTime = Math.abs(endDate - now);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
};

// 从localStorage获取用户信息
const fetchUserInfo = () => {
  // 尝试从localStorage获取用户信息
  const storedUserInfo = localStorage.getItem('userInfo');
  
  if (storedUserInfo) {
    try {
      const parsedUserInfo = JSON.parse(storedUserInfo);
      userInfo.value.username = parsedUserInfo.username || '';
    } catch (e) {
      console.error('解析用户信息失败:', e);
    }
  }
  
  // 如果没有获取到用户名，使用默认值
  if (!userInfo.value.username) {
    userInfo.value.username = '管理员';
  }
};

// 获取推广数据概览
const fetchOverviewData = async () => {
  try {
    const response = await getDashboardOverview(currentCampId.value);
    console.log('接口返回的原始数据:', response);
    
    if (response.code === 1 && response.data) {
      console.log('接口返回的data数据:', response.data);
      
      // 适应不同的字段名称（驼峰或下划线命名）
      const totalConversions = response.data.totalConversions ?? response.data.total_conversions ?? 0;
      const totalTeams = response.data.totalTeams ?? response.data.total_teams ?? 0;
      const totalAmbassadors = response.data.totalAmbassadors ?? response.data.total_ambassadors ?? 0;
      const totalCommission = response.data.totalCommission ?? response.data.total_commission ?? 0;
      
      // 更新数据
      overviewData.totalConversions = totalConversions;
      overviewData.totalTeams = totalTeams;
      overviewData.totalAmbassadors = totalAmbassadors;
      overviewData.totalCommission = totalCommission;
      
      // 处理 campInfo
      const campInfoData = response.data.campInfo ?? response.data.camp_info;
      if (campInfoData) {
        console.log('接口返回的campInfo数据:', campInfoData);
        
        // 适应不同的字段名称
        overviewData.campInfo = {
          campId: campInfoData.campId ?? campInfoData.camp_id ?? '',
          campName: campInfoData.campName ?? campInfoData.camp_name ?? '未知营期',
          startDate: campInfoData.startDate ?? campInfoData.start_date ?? null,
          endDate: campInfoData.endDate ?? campInfoData.end_date ?? null,
          daysLeft: campInfoData.daysLeft ?? campInfoData.days_left ?? 0
        };
        
        // 确保使用后端返回的营期名称
        console.log('设置的营期名称:', overviewData.campInfo.campName);
      } else {
        console.warn('接口没有返回campInfo数据');
        // 如果后端未返回 campInfo，设置默认值
        overviewData.campInfo = {
          campId: '',
          campName: '数据未返回',
          startDate: null,
          endDate: null,
          daysLeft: 0
        };
      }
    } else {
      console.error('接口返回错误:', response);
      ElMessage.warning(response.msg || response.message || '获取推广数据概览失败');
    }
  } catch (error) {
    console.error('获取推广数据概览失败:', error);
    ElMessage.error('获取推广数据概览失败，请稍后重试');
    throw error; // 向上抛出错误，让refreshData捕获处理
  }
};

// 获取推广之星数据
const fetchMarketingStarsData = async () => {
  try {
    const response = await getMarketingStars(currentCampId.value);
    console.log('推广之星数据:', response);
    
    if (response.code === 1 && response.data) {
      // 处理返回数据，适配字段名称（驼峰或下划线命名）
      const topTeams = response.data.topTeams || response.data.top_teams || [];
      const topAmbassadors = response.data.topAmbassadors || response.data.top_ambassadors || [];
      
      // 处理团队数据字段
      marketingStarsData.topTeams = topTeams.map(team => ({
        teamId: team.teamId || team.team_id,
        teamName: team.teamName || team.team_name,
        leaderId: team.leaderId || team.leader_id,
        leaderName: team.leaderName || team.leader_name,
        totalConversions: team.totalConversions || team.total_conversions || 0,
        totalCommission: team.totalCommission || team.total_commission || 0,
        memberCount: team.memberCount || team.member_count || 0,
        rank: team.rank || 0
      }));
      
      // 处理推广大使数据字段
      marketingStarsData.topAmbassadors = topAmbassadors.map(ambassador => ({
        userId: ambassador.userId || ambassador.user_id,
        userName: ambassador.userName || ambassador.username || ambassador.user_name,
        teamId: ambassador.teamId || ambassador.team_id,
        teamName: ambassador.teamName || ambassador.team_name,
        conversions: ambassador.conversions || 0,
        totalCommission: ambassador.totalCommission || ambassador.total_commission || 0,
        rank: ambassador.rank || 0
      }));
      
      // 渲染图表
      nextTick(() => {
        renderTeamChart();
        renderAmbassadorChart();
      });
    } else {
      console.error('获取推广之星数据失败:', response);
      ElMessage.warning(response.msg || '获取推广之星数据失败');
    }
  } catch (error) {
    console.error('获取推广之星数据异常:', error);
    ElMessage.error('获取推广之星数据失败，请稍后重试');
    throw error; // 向上抛出错误，让refreshData捕获处理
  }
};

// 获取转化趋势数据
const fetchTrendsData = async () => {
  try {
    const response = await getConversionTrends(currentCampId.value, 10);
    console.log('转化趋势数据:', response);
    
    if (response.code === 1 && response.data) {
      // 添加字段名称兼容性处理
      trendsData.currentCampId = response.data.currentCampId || response.data.current_camp_id || currentCampId.value;
      
      // 处理trendData字段，兼容下划线命名
      const trendDataArray = response.data.trendData || response.data.trend_data || [];
      
      // 处理每个趋势数据项，确保字段名称一致
      trendsData.trendData = trendDataArray.map(item => ({
        campId: item.campId || item.camp_id,
        campName: item.campName || item.camp_name,
        period: item.period,
        totalConversions: item.totalConversions || item.total_conversions,
        totalCommission: item.totalCommission || item.total_commission
      }));
      
      console.log('处理后的趋势数据:', trendsData.trendData);
      
      // 渲染趋势图表
      nextTick(() => {
        renderTrendsChart();
      });
    } else {
      console.error('获取转化趋势数据失败:', response);
      ElMessage.warning(response.msg || '获取转化趋势数据失败');
    }
  } catch (error) {
    console.error('获取转化趋势数据异常:', error);
    ElMessage.error('获取转化趋势数据失败，请稍后重试');
    throw error;
  }
};

// 获取佣金分配数据
const fetchCommissionData = async () => {
  try {
    // 如果组件已卸载，不执行任何操作
    if (isComponentUnmounted.value) {
      console.warn('组件已卸载，取消获取佣金数据');
      return;
    }
    
    commissionData.loading = true;
    
    // 确保在获取新数据前销毁现有图表
    if (commissionChartRef.value && commissionChartRef.value.__echarts__) {
      try {
        echarts.dispose(commissionChartRef.value);
      } catch (e) {
        console.error('销毁旧图表失败:', e);
      }
    }
    
    const response = await getCommissionDistribution('type', currentCampId.value);
    console.log('佣金分配数据:', response);
    
    // 二次检查组件是否已卸载
    if (isComponentUnmounted.value) {
      console.warn('组件在数据返回时已卸载，取消后续操作');
      return;
    }
    
    if (response.code === 1 && response.data) {
      // 处理返回数据，适配字段名称（驼峰或下划线命名）
      commissionData.totalCommission = response.data.totalCommission || response.data.total_commission || 0;
      
      // 处理campInfo数据
      const campInfoData = response.data.campInfo || response.data.camp_info;
      if (campInfoData) {
        commissionData.campInfo = {
          campId: campInfoData.campId || campInfoData.camp_id,
          campName: campInfoData.campName || campInfoData.camp_name,
          startDate: campInfoData.startDate || campInfoData.start_date,
          endDate: campInfoData.endDate || campInfoData.end_date
        };
      }
      
      // 处理byType数据
      const byTypeData = response.data.byType || response.data.by_type || [];
      commissionData.byType = byTypeData.map(item => ({
        type: item.type,
        typeName: item.typeName || item.type_name,
        amount: item.amount,
        count: item.count,
        percentage: item.percentage
      }));
      
      // 如果组件仍然挂载，则渲染图表
      if (!isComponentUnmounted.value) {
        // 等待DOM完全更新后再初始化图表
        setTimeout(() => {
          renderCommissionChart();
        }, 100);
      }
    } else {
      console.error('获取佣金分配数据失败:', response);
      if (!isComponentUnmounted.value) {
        ElMessage.warning(response.msg || '获取佣金分配数据失败');
      }
    }
  } catch (error) {
    console.error('获取佣金分配数据异常:', error);
    if (!isComponentUnmounted.value) {
      ElMessage.error('获取佣金分配数据失败，请稍后重试');
    }
  } finally {
    // 仅在组件未卸载时更新状态
    if (!isComponentUnmounted.value) {
      commissionData.loading = false;
    }
  }
};

// 渲染团队图表
const renderTeamChart = () => {
  if (!teamChartRef.value) return;
  
  // 销毁已有图表
  if (teamChart) {
    teamChart.dispose();
  }
  
  // 检查是否有数据
  if (!marketingStarsData.topTeams || marketingStarsData.topTeams.length === 0) {
    return;
  }
  
  // 初始化图表
  teamChart = echarts.init(teamChartRef.value);
  
  // 准备数据
  const teams = marketingStarsData.topTeams.slice(0, 5);
  
  // 打印数据进行调试
  console.log('团队图表数据:', teams);
  
  // 为柱状图准备数据
  const teamNames = teams.map(team => team.teamName || '未知团队');
  const conversions = teams.map(team => team.totalConversions || 0);
  
  // 创建黄色渐变色方案 - 从左到右逐渐变淡
  const colorList = [
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#E6A23C' },
      { offset: 1, color: '#F3D19E' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#E9AB4D' },
      { offset: 1, color: '#F5D7AE' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#ECB45F' },
      { offset: 1, color: '#F7DDBE' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#EFBD71' },
      { offset: 1, color: '#F9E4CE' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#F2C683' },
      { offset: 1, color: '#FBEADF' }
    ])
  ];
  
  // 设置图表选项
  const option = {
    title: {
      text: '最佳推广团队',
      left: 'center',
      textStyle: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#303133',
        fontFamily: '"PingFang SC", "Microsoft YaHei", sans-serif'
      },
      subtext: '当前目标营期团队转化数据',
      subtextStyle: {
        color: '#909399',
        fontSize: 12
      }
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow',
        shadowStyle: {
          color: 'rgba(0, 0, 0, 0.05)'
        }
      },
      formatter: function(params) {
        const team = teams[params[0].dataIndex];
        return `
          <div style="font-weight:bold;margin-bottom:8px;font-size:14px;">${team.teamName || '未知'}</div>
          <div style="display:flex;justify-content:space-between;margin-bottom:3px;">
            <span style="margin-right:15px;">转化数:</span>
            <span style="font-weight:600;color:#E6A23C">${team.totalConversions || 0}</span>
          </div>
          <div style="display:flex;justify-content:space-between;margin-bottom:3px;">
            <span style="margin-right:15px;">佣金:</span>
            <span style="font-weight:600;color:#E6A23C">¥${(team.totalCommission || 0).toFixed(2)}</span>
          </div>
          <div style="display:flex;justify-content:space-between;margin-bottom:3px;">
            <span style="margin-right:15px;">成员数:</span>
            <span style="font-weight:600;color:#909399">${team.memberCount || 0}人</span>
          </div>
          <div style="display:flex;justify-content:space-between;">
            <span style="margin-right:15px;">负责人:</span>
            <span style="font-weight:600;color:#606266">${team.leaderName || '未设置'}</span>
          </div>
        `;
      },
      backgroundColor: 'rgba(255,255,255,0.95)',
      borderColor: '#eee',
      borderWidth: 1,
      padding: [10, 15],
      textStyle: {
        color: '#333'
      },
      extraCssText: 'box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15); border-radius: 4px;'
    },
    grid: {
      left: '5%',
      right: '5%',
      bottom: '8%',
      top: '18%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: teamNames,
      axisLabel: {
        interval: 0,
        rotate: 30,
        fontSize: 12,
        color: '#606266'
      },
      axisTick: {
        alignWithLabel: true
      },
      axisLine: {
        lineStyle: {
          color: '#dcdfe6'
        }
      }
    },
    yAxis: {
      type: 'value',
      name: '转化数',
      nameTextStyle: {
        color: '#909399',
        fontSize: 12,
        padding: [0, 0, 0, 30]
      },
      axisLabel: {
        color: '#909399'
      },
      splitLine: {
        lineStyle: {
          type: 'dashed',
          color: '#EBEEF5'
        }
      }
    },
    series: [
      {
        name: '转化数',
        type: 'bar',
        data: conversions.map((value, index) => {
          return {
            value,
            itemStyle: {
              color: colorList[index] || colorList[colorList.length - 1]
            }
          };
        }),
        barWidth: '45%',
        barGap: '10%',
        emphasis: {
          focus: 'series',
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.2)'
          }
        },
        label: {
          show: true,
          position: 'top',
          formatter: '{c}',
          fontSize: 12,
          color: '#606266'
        },
        itemStyle: {
          borderRadius: [6, 6, 0, 0],
          shadowColor: 'rgba(0, 0, 0, 0.1)',
          shadowBlur: 4,
          shadowOffsetY: 2
        }
      }
    ],
    // 添加动画效果
    animationDuration: 1500,
    animationEasing: 'elasticOut',
    animationDelay: function (idx) {
      return idx * 100;
    }
  };
  
  // 应用选项
  teamChart.setOption(option);
  
  // 响应窗口调整
  window.addEventListener('resize', () => {
    if (teamChart && !isComponentUnmounted.value) {
      teamChart.resize();
    }
  });
};

// 渲染推广大使图表
const renderAmbassadorChart = () => {
  if (!ambassadorChartRef.value) return;
  
  // 销毁已有图表
  if (ambassadorChart) {
    ambassadorChart.dispose();
  }
  
  // 检查是否有数据
  if (!marketingStarsData.topAmbassadors || marketingStarsData.topAmbassadors.length === 0) {
    return;
  }
  
  // 初始化图表
  ambassadorChart = echarts.init(ambassadorChartRef.value);
  
  // 准备数据
  const ambassadors = marketingStarsData.topAmbassadors.slice(0, 5);
  
  // 打印数据进行调试
  console.log('推广大使图表数据:', ambassadors);
  
  // 为柱状图准备数据
  const userNames = ambassadors.map(a => a.userName || '未知');
  const conversions = ambassadors.map(a => a.conversions || 0);
  
  // 创建绿色渐变色方案 - 从左到右逐渐变淡
  const colorList = [
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#67C23A' },
      { offset: 1, color: '#B3E19D' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#79C853' },
      { offset: 1, color: '#BFE6AD' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#8BCE6C' },
      { offset: 1, color: '#CBECBD' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#9DD485' },
      { offset: 1, color: '#D7F1CD' }
    ]),
    new echarts.graphic.LinearGradient(0, 0, 0, 1, [
      { offset: 0, color: '#AFDB9E' },
      { offset: 1, color: '#E3F7DD' }
    ])
  ];
  
  // 设置图表选项
  const option = {
    title: {
      text: '最佳推广大使',
      left: 'center',
      textStyle: {
        fontSize: 18,
        fontWeight: 'bold',
        color: '#303133',
        fontFamily: '"PingFang SC", "Microsoft YaHei", sans-serif'
      },
      subtext: '当前目标营期个人贡献数据',
      subtextStyle: {
        color: '#909399',
        fontSize: 12
      }
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow',
        shadowStyle: {
          color: 'rgba(0, 0, 0, 0.05)'
        }
      },
      formatter: function(params) {
        const ambassador = ambassadors[params[0].dataIndex];
        return `
          <div style="font-weight:bold;margin-bottom:8px;font-size:14px;">${ambassador.userName || '未知'}</div>
          <div style="display:flex;justify-content:space-between;margin-bottom:3px;">
            <span style="margin-right:15px;">转化数:</span>
            <span style="font-weight:600;color:#67C23A">${ambassador.conversions || 0}</span>
          </div>
          <div style="display:flex;justify-content:space-between;margin-bottom:3px;">
            <span style="margin-right:15px;">佣金:</span>
            <span style="font-weight:600;color:#67C23A">¥${(ambassador.totalCommission || 0).toFixed(2)}</span>
          </div>
          <div style="display:flex;justify-content:space-between;">
            <span style="margin-right:15px;">团队:</span>
            <span style="font-weight:600;color:#606266">${ambassador.teamName || '无团队'}</span>
          </div>
        `;
      },
      backgroundColor: 'rgba(255,255,255,0.95)',
      borderColor: '#eee',
      borderWidth: 1,
      padding: [10, 15],
      textStyle: {
        color: '#333'
      },
      extraCssText: 'box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15); border-radius: 4px;'
    },
    grid: {
      left: '5%',
      right: '5%',
      bottom: '8%',
      top: '18%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: userNames,
      axisLabel: {
        interval: 0,
        rotate: 30,
        fontSize: 12,
        color: '#606266'
      },
      axisTick: {
        alignWithLabel: true
      },
      axisLine: {
        lineStyle: {
          color: '#dcdfe6'
        }
      }
    },
    yAxis: {
      type: 'value',
      name: '转化数',
      nameTextStyle: {
        color: '#909399',
        fontSize: 12,
        padding: [0, 0, 0, 30]
      },
      axisLabel: {
        color: '#909399'
      },
      splitLine: {
        lineStyle: {
          type: 'dashed',
          color: '#EBEEF5'
        }
      }
    },
    series: [
      {
        name: '转化数',
        type: 'bar',
        data: conversions.map((value, index) => {
          return {
            value,
            itemStyle: {
              color: colorList[index] || colorList[colorList.length - 1]
            }
          };
        }),
        barWidth: '45%',
        barGap: '10%',
        emphasis: {
          focus: 'series',
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.2)'
          }
        },
        label: {
          show: true,
          position: 'top',
          formatter: '{c}',
          fontSize: 12,
          color: '#606266'
        },
        itemStyle: {
          borderRadius: [6, 6, 0, 0],
          shadowColor: 'rgba(0, 0, 0, 0.1)',
          shadowBlur: 4,
          shadowOffsetY: 2
        }
      }
    ],
    // 添加动画效果
    animationDuration: 1500,
    animationEasing: 'elasticOut',
    animationDelay: function (idx) {
      return idx * 100;
    }
  };
  
  // 应用选项
  ambassadorChart.setOption(option);
  
  // 响应窗口调整
  window.addEventListener('resize', () => {
    if (ambassadorChart && !isComponentUnmounted.value) {
      ambassadorChart.resize();
    }
  });
};

// 渲染转化趋势图表
const renderTrendsChart = () => {
  if (!trendsChartRef.value) {
    console.warn('趋势图表容器不存在');
    return;
  }
  
  // 销毁已有图表
  if (trendsChart) {
    trendsChart.dispose();
  }
  
  // 检查是否有数据
  if (!trendsData.trendData || trendsData.trendData.length === 0) {
    console.warn('没有趋势数据可供渲染');
    return;
  }
  
  // 初始化图表
  try {
    trendsChart = echarts.init(trendsChartRef.value);
  } catch (error) {
    console.error('初始化趋势图表失败:', error);
    return;
  }
  
  // 准备数据
  const trends = trendsData.trendData;
  console.log('准备渲染的趋势数据:', trends);
  
  // 验证数据格式是否正确
  const hasValidCampId = trends.every(item => !!item.campId);
  const hasValidConversions = trends.every(item => typeof item.totalConversions === 'number');
  const hasValidCommissions = trends.every(item => typeof item.totalCommission === 'number');
  
  if (!hasValidCampId || !hasValidConversions || !hasValidCommissions) {
    console.error('趋势数据格式不正确:', {
      hasValidCampId,
      hasValidConversions,
      hasValidCommissions,
      sampleData: trends[0]
    });
  }
  
  // 创建固定的营期ID范围 (990-1001)
  const fixedPeriodIds = [];
  for (let i = 990; i <= 1001; i++) {
    fixedPeriodIds.push(i.toString());
  }
  
  // 创建与固定营期ID对应的数据映射
  const dataMap = {};
  trends.forEach(item => {
    dataMap[item.campId] = item;
  });
  
  // 根据固定的营期ID创建对应的转换数据数组
  const fixedConversions = fixedPeriodIds.map(id => {
    // 将null值替换为0，确保所有点都显示
    return dataMap[id] ? dataMap[id].totalConversions : 0;
  });
  
  // 使用固定的营期ID作为X轴数据
  console.log('趋势图表数据:', { 
    fixedPeriodIds, 
    fixedConversions, 
    originalPeriodIds: trends.map(item => item.campId),
    originalData: trends
  });
  
  // 设置图表选项
  const option = {
    title: {
      text: '转化趋势分析',
      left: 'center',
      textStyle: {
        fontSize: 16,
        fontWeight: 'bold',
        color: '#303133'
      }
    },
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'cross',
        label: {
          backgroundColor: '#6a7985'
        }
      },
      formatter: function(params) {
        const campId = fixedPeriodIds[params[0].dataIndex];
        const trend = dataMap[campId];
        
        if (!trend) {
          return `<div style="font-weight:bold;margin-bottom:5px;">营期 ${campId}</div>
                 <div>转化数: 0</div>
                 <div>佣金总额: ¥0.00</div>`;
        }
        
        return `
          <div style="font-weight:bold;margin-bottom:5px;">${trend.campName}</div>
          <div>营期ID: ${trend.campId}</div>
          <div>时间: ${trend.period}</div>
          <div>转化数: ${trend.totalConversions}</div>
          <div>佣金总额: ¥${trend.totalCommission.toFixed(2)}</div>
        `;
      }
    },
    legend: {
      data: ['转化数'],
      top: 30
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '8%', // 从10%减小到8%
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: fixedPeriodIds,
      name: '营期ID',
      nameLocation: 'middle',
      nameGap: 30,
      axisLabel: {
        interval: 0,
        rotate: 30 // 旋转标签，防止重叠
      }
    },
    yAxis: {
      type: 'value',
      name: '转化数'
    },
    series: [
      {
        name: '转化数',
        type: 'line',
        data: fixedConversions,
        smooth: true,
        showSymbol: true,
        symbolSize: 8,
        connectNulls: true, // 连接空值点
        lineStyle: {
          width: 3,
          color: '#67C23A'
        },
        itemStyle: {
          color: '#67C23A',
          borderWidth: 2
        },
        emphasis: {
          itemStyle: {
            borderWidth: 3,
            borderColor: '#67C23A',
            color: '#ffffff',
            shadowBlur: 10,
            shadowColor: 'rgba(103, 194, 58, 0.5)'
          }
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(103, 194, 58, 0.5)' },
            { offset: 1, color: 'rgba(103, 194, 58, 0.1)' }
          ])
        }
      }
    ]
  };
  
  // 应用选项
  try {
    trendsChart.setOption(option);
    console.log('趋势图表渲染成功');
    
    // 图表自适应容器大小
    trendsChart.resize();
  } catch (error) {
    console.error('设置趋势图表选项失败:', error);
  }
  
  // 响应窗口调整
  window.addEventListener('resize', () => {
    if (trendsChart) {
      trendsChart.resize();
    }
  });
};

// 渲染佣金分配图表
const renderCommissionChart = () => {
  // 确保组件仍然挂载
  if (isComponentUnmounted.value) {
    console.warn('组件已卸载，取消渲染佣金图表');
    return;
  }
  
  // 先检查DOM元素是否存在
  if (!commissionChartRef.value) {
    console.warn('佣金图表容器不存在');
    return;
  }
  
  // 获取类型维度数据
  const dimensionData = commissionData.byType || [];
  
  // 检查是否有数据
  if (dimensionData.length === 0) {
    console.warn('没有佣金分配数据可供渲染');
    return;
  }
  
  // 如果DOM元素上已有ECharts实例，先销毁它
  if (commissionChartRef.value.__echarts__) {
    try {
      echarts.dispose(commissionChartRef.value);
    } catch (e) {
      console.error('销毁旧图表实例失败:', e);
    }
  }
  
  try {
    // 重新创建图表实例
    const chartInstance = echarts.init(commissionChartRef.value);
    
    // 为饼图准备数据
    const pieData = dimensionData.map(item => {
      return {
        name: item.typeName,
        value: item.amount,
        percentage: item.percentage,
        count: item.count
      };
    });
    
    // 设置颜色方案
    const colorScheme = [
      '#4E79A7', '#F28E2B', '#E15759', '#76B7B2', '#59A14F', 
      '#EDC948', '#B07AA1', '#FF9DA7', '#9C755F', '#BAB0AC'
    ];
    
    // 设置图表选项
    const option = {
      backgroundColor: '#f8f9fa',
      title: {
        text: '佣金分配分析',
        subtext: `总佣金: ¥${commissionData.totalCommission.toFixed(2)}`,
        left: 'center',
        top: 10,
        textStyle: {
          fontSize: 16,
          fontWeight: 'bold',
          color: '#303133'
        },
        subtextStyle: {
          fontSize: 12,
          color: '#909399'
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: function(params) {
          return `
            <div style="font-weight:bold;margin-bottom:5px;">${params.name}</div>
            <div>金额: ¥${params.value.toFixed(2)}</div>
            <div>比例: ${params.data.percentage}%</div>
            <div>记录数: ${params.data.count}</div>
          `;
        }
      },
      legend: {
        orient: 'vertical',
        left: '5%',
        top: 'middle',
        textStyle: {
          fontSize: 12
        },
        itemWidth: 10,
        itemHeight: 10,
        itemGap: 8
      },
      color: colorScheme,
      series: [
        {
          name: '佣金分配',
          type: 'pie',
          radius: ['40%', '70%'],
          center: ['65%', '55%'],
          avoidLabelOverlap: true,
          data: pieData,
          label: {
            show: false,
            position: 'center'
          },
          labelLine: {
            show: false,
            length: 0,
            length2: 0
          },
          emphasis: {
            label: {
              show: false
            },
            labelLine: {
              show: false
            },
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          },
          itemStyle: {
            borderRadius: 5,
            borderColor: '#fff',
            borderWidth: 2
          },
          animationType: 'scale',
          animationEasing: 'elasticOut',
          animationDelay: function (idx) {
            return Math.random() * 200;
          }
        }
      ]
    };
    
    // 设置图表选项
    chartInstance.setOption(option);
    
    // 添加窗口调整事件监听器
    const handleResize = () => {
      if (chartInstance) {
        chartInstance.resize();
      }
    };
    
    window.addEventListener('resize', handleResize);
    
    // 存储清理函数
    return () => {
      window.removeEventListener('resize', handleResize);
      if (chartInstance) {
        try {
          chartInstance.dispose();
        } catch (e) {
          console.error('清理图表实例失败:', e);
        }
      }
    };
  } catch (error) {
    console.error('初始化或渲染图表失败:', error);
    ElMessage.error('图表渲染失败，请刷新页面重试');
  }
};

// 处理营期变更
const handleCampChange = () => {
  refreshData();
};

// 导航到上一个营期
const navigateToPrevCamp = () => {
  if (loading.value || isLoading.value || marketingStarsData.loading) return;
  currentCampId.value--;
  refreshData();
};

// 导航到下一个营期
const navigateToNextCamp = () => {
  if (loading.value || isLoading.value || marketingStarsData.loading) return;
  
  // 检查当前营期ID是否为1001，如果是则不允许进入下一个营期
  if (currentCampId.value === 1001) {
    ElMessage.warning('当前已是最近营期');
    return;
  }
  
  currentCampId.value++;
  refreshData();
};

// 刷新所有数据
const refreshData = () => {
  if (loading.value || isLoading.value || marketingStarsData.loading || trendsData.loading) return; // 防止重复请求
  
  isLoading.value = true;
  loading.value = true;
  
  // 重置数据状态
  marketingStarsData.loading = true;
  marketingStarsData.topTeams = [];
  marketingStarsData.topAmbassadors = [];
  
  trendsData.loading = true;
  trendsData.trendData = [];
  
  console.log('开始刷新数据，当前目标营期ID:', currentCampId.value);
  
  // 使用Promise.all同时请求所有数据
  Promise.all([
    fetchOverviewData(),
    fetchMarketingStarsData(),
    fetchTrendsData(),
    fetchCommissionData()
  ])
  .catch(error => {
    console.error('数据刷新失败:', error);
    ElMessage.error('数据刷新失败，请稍后重试');
  })
  .finally(() => {
    isLoading.value = false;
    loading.value = false;
    marketingStarsData.loading = false;
    trendsData.loading = false;
  });
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
      // 修改为蓝色系粒子，与推广大使长一致
      this.color = `rgba(64, 158, 255, ${Math.random() * 0.4 + 0.1})`;
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
          // 修改为蓝色系连接线，与推广大使长一致
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

// 存储清理函数
const cleanupAnimation = ref(null);

// 组件加载时的逻辑
onMounted(() => {
  // 重置卸载标志
  isComponentUnmounted.value = false;
  
  // 获取用户信息
  fetchUserInfo();
  
  // 初始化欢迎区域的粒子动画
  cleanupAnimation.value = initParticleAnimation();
  
  // 添加一个启动延迟避免初始化问题
  setTimeout(() => {
    // 统一使用refreshData获取所有数据
    refreshData();
  }, 100);
  
  // 添加窗口调整事件监听，确保图表正确调整大小
  const handleResize = () => {
    if (trendsChart) {
      trendsChart.resize();
    }
    
    if (commissionChartRef.value && commissionChartRef.value.__echarts__) {
      commissionChartRef.value.__echarts__.resize();
    }
  };
  
  window.addEventListener('resize', handleResize);
  
  // 存储清理函数，在组件卸载时使用
  return () => {
    window.removeEventListener('resize', handleResize);
  };
});

// 组件卸载时清理资源
onUnmounted(() => {
  // 标记组件已卸载
  isComponentUnmounted.value = true;
  console.log('组件被卸载，已设置isComponentUnmounted标志');
  
  if (cleanupAnimation.value && typeof cleanupAnimation.value === 'function') {
    cleanupAnimation.value();
  }
  
  // 清理所有事件监听器
  window.removeEventListener('resize', () => {});
  
  // 清理图表实例
  const chartArray = [teamChart, ambassadorChart, trendsChart];
  chartArray.forEach(chart => {
    if (chart) {
      try {
        chart.dispose();
      } catch (error) {
        console.error('清理图表实例时出错:', error);
      }
    }
  });
  
  // 清理佣金图表
  if (commissionChartRef.value && commissionChartRef.value.__echarts__) {
    try {
      echarts.dispose(commissionChartRef.value);
    } catch (error) {
      console.error('清理佣金图表实例时出错:', error);
    }
  }
  
  // 重置变量
  teamChart = null;
  ambassadorChart = null;
  trendsChart = null;
});
</script>

<style scoped>
.admin-dashboard {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f7fa;
}

.main-content {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 欢迎条样式 */
.welcome-section {
  display: flex;
  align-items: center;
  /* 修改为蓝色系渐变背景，与推广大使长一致 */
  background: linear-gradient(to right, #f1f8ff, #ffffff);
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
  flex: 1;
}

.welcome-actions {
  position: relative;
  z-index: 2;
  margin-left: 15px;
}

.refresh-btn {
  transition: all 0.4s ease;
  box-shadow: 0 2px 10px rgba(64, 158, 255, 0.4);
  width: 48px !important;
  height: 48px !important;
  background: linear-gradient(145deg, #409EFF, #53a8ff) !important;
  border: none !important;
}

.refresh-btn:hover:not(:disabled) {
  transform: rotate(180deg) scale(1.05);
  box-shadow: 0 4px 15px rgba(64, 158, 255, 0.6);
  background: linear-gradient(145deg, #53a8ff, #409EFF) !important;
}

.refresh-btn:active:not(:disabled) {
  transform: rotate(180deg) scale(0.95);
}

.refresh-btn:not(:disabled):not(.is-loading) {
  animation: pulse 2s infinite;
}

/* 添加加载动画效果 */
.refresh-btn.is-loading {
  background: linear-gradient(145deg, #67a3e0, #5a95d8) !important;
  animation: none;
  opacity: 0.9;
}

.refresh-btn :deep(.is-loading) {
  animation: rotate 1s linear infinite;
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(64, 158, 255, 0.4);
  }
  70% {
    box-shadow: 0 0 0 6px rgba(64, 158, 255, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(64, 158, 255, 0);
  }
}

.welcome-text {
  margin: 0;
  font-size: 24px;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 10px;
}

/* 内容容器样式 */
.content-container-vertical {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 卡片样式 */
.overview-card {
  border-radius: 8px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.05);
  transition: all 0.3s;
  border: none;
}

.overview-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
}

.overview-content {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* 营期信息部分样式 */
.camp-section {
  padding: 20px 15px;
}

.section-title {
  font-size: 18px;
  color: #303133;
  margin: 0 0 16px;
  font-weight: 600;
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
  color: #303133;
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

/* 分隔线样式 */
.section-divider {
  height: 1px;
  width: 100%;
  background-color: #f0f0f0;
  margin: 5px 0;
}

/* 统计部分样式 */
.stats-section {
  padding: 20px 15px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.stat-card {
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 15px;
  transition: all 0.3s;
}

.stat-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.1);
}

.stat-icon {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 24px;
  color: #fff;
}

.conversions-icon {
  background-color: #409EFF;
}

.teams-icon {
  background-color: #67C23A;
}

.ambassadors-icon {
  background-color: #E6A23C;
}

.commission-icon {
  background-color: #F56C6C;
}

.stat-info {
  flex: 1;
}

.stat-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 5px;
}

.stat-desc {
  font-size: 12px;
  color: #C0C4CC;
}

/* 响应式调整 */
@media (max-width: 1200px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .main-content {
    padding: 16px;
  }
  
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 576px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .welcome-text {
    font-size: 20px;
  }
  
  .welcome-section {
    height: auto;
    padding: 16px;
  }
}

/* 推广之星图表样式 */
.marketing-stars-charts {
  margin: 15px 0; /* 从20px减小到15px */
  padding: 15px; /* 从20px减小到15px */
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.marketing-stars-charts:hover {
  box-shadow: 0 4px 16px 0 rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.chart-header .title {
  position: relative;
  padding-left: 12px;
}

.chart-header .title:before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 70%;
  background: linear-gradient(to bottom, #409EFF, #53a8ff);
  border-radius: 2px;
}

.chart-header h2 {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 2px 0;
}

.chart-header .subtitle {
  font-size: 12px;
  color: #909399;
}

.charts-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
  margin-top: 15px;
}

.chart-card {
  position: relative;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  padding: 20px;
  height: 320px; /* 从380px减小到320px */
  transition: all 0.3s ease;
  overflow: hidden;
}

.chart-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.chart-icon {
  position: absolute;
  top: 15px;
  right: 15px;
  width: 32px;
  height: 32px;
  display: flex;
  justify-content: center;
  align-items: center;
  border-radius: 50%;
  color: white;
  z-index: 1;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}

.trophy-icon {
  background: linear-gradient(135deg, #E6A23C, #F3D19E);
  font-size: 18px;
}

.medal-icon {
  background: linear-gradient(135deg, #67C23A, #B3E19D);
  font-size: 18px;
}

.chart-content {
  height: 100%;
  width: 100%;
}

.no-data {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .charts-container {
    grid-template-columns: 1fr;
  }
  
  .chart-card {
    height: 300px; /* 从340px减小到300px */
  }
}

/* 添加图表加载动画效果 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.chart-content {
  animation: fadeIn 0.6s ease-out;
}

/* 创建水平排列的图表容器 */
.charts-row-container {
  display: flex;
  gap: 20px;
  margin-bottom: 16px; /* 从24px减小到16px */
  width: 100%;
}

/* 趋势图表和佣金图表在同一行中均分空间 */
.trends-chart-section, 
.commission-chart-section {
  flex: 1;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  padding: 16px; /* 从24px减小到16px */
  position: relative;
  min-width: 0; /* 确保flex子项可以缩小到小于其内容尺寸 */
}

/* 响应式调整 */
@media (max-width: 1200px) {
  .charts-row-container {
    flex-direction: column;
  }
  
  .trends-chart-section, 
  .commission-chart-section {
    width: 100%;
    margin-bottom: 24px;
  }
}

/* 调整图表内容高度保持一致 */
.trends-chart-content,
.commission-chart-content {
  width: 100%;
  height: 280px; /* 从350px减小到280px */
  position: relative;
}

/* 调整图表内容高度保持一致 */
.trends-chart-content,
.commission-chart-content {
  width: 100%;
  height: 250px; /* 从280px进一步减小到250px */
  position: relative;
}
</style> 