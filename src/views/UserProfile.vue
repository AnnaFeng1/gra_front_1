<template>
  <div class="user-profile-container">
    <!-- 页面顶部导航 -->
    <div class="header">
      <div class="logo">营销推广管理系统</div>
      <div class="navigation-actions">
        <el-button 
          class="back-btn" 
          @click="goToDashboard"
          type="primary" 
          plain>
          <i class="el-icon-back"></i> 返回首页
        </el-button>
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 欢迎信息 -->
      <div class="welcome-section">
        <canvas ref="welcomeCanvas" class="welcome-canvas"></canvas>
        <h2 class="welcome-text">个人中心</h2>
        <div class="header-actions">
          <el-button type="danger" @click="logout">退出登录</el-button>
        </div>
      </div>

      <!-- 个人信息卡片 -->
      <el-card class="profile-card" v-loading="loading">
        <template #header>
          <div class="card-header">
            <span><i class="el-icon-user"></i> 个人信息</span>
          </div>
        </template>
        
        <el-skeleton :loading="loading" animated>
          <template #template>
            <div style="padding: 20px">
              <el-skeleton-item variant="text" style="width: 100%; height: 40px" />
              <el-skeleton-item variant="text" style="margin-top: 20px; width: 100%; height: 40px" />
              <el-skeleton-item variant="text" style="margin-top: 20px; width: 100%; height: 40px" />
              <el-skeleton-item variant="text" style="margin-top: 20px; width: 100%; height: 40px" />
            </div>
          </template>
          
          <template #default>
            <div class="user-info-container">
              <!-- 用户基本信息展示 -->
              <div class="user-basic-info">
                <div class="user-avatar">
                  <div class="avatar-circle">
                    <span>{{ userInfo.username ? userInfo.username.charAt(0).toUpperCase() : 'U' }}</span>
                  </div>
                </div>
                <div class="user-details">
                  <h3 class="username">{{ userInfo.username || '用户名' }}</h3>
                  <div class="user-id">ID: {{ userInfo.id || '--' }}</div>
                  <div class="user-role">
                    <el-tag :type="getRoleTagType(userInfo.role)">{{ getRoleLabel(userInfo.role) }}</el-tag>
                  </div>
                </div>
              </div>
              
              <!-- 分隔线 -->
              <div class="section-divider"></div>
              
              <!-- 表单部分 -->
              <div class="form-section">
                <h3 class="section-title">编辑信息</h3>
                <el-form 
                  ref="formRef" 
                  :model="userForm" 
                  :rules="rules"
                  label-width="100px" 
                  v-loading="submitting"
                  class="edit-form"
                >
                  <el-form-item label="邮箱" prop="email">
                    <el-input v-model="userForm.email" placeholder="请输入邮箱">
                      <template #prefix><i class="el-icon-message"></i></template>
                    </el-input>
                  </el-form-item>
                  
                  <el-form-item label="手机号" prop="phone">
                    <el-input v-model="userForm.phone" placeholder="请输入手机号">
                      <template #prefix><i class="el-icon-mobile-phone"></i></template>
                    </el-input>
                  </el-form-item>
                  
                  <el-form-item label="修改密码" prop="password">
                    <el-input v-model="userForm.password" type="password" placeholder="输入新密码，不修改请留空" show-password>
                      <template #prefix><i class="el-icon-lock"></i></template>
                    </el-input>
                  </el-form-item>
                  
                  <el-form-item class="form-actions">
                    <el-button type="primary" @click="submitForm" :loading="submitting">
                      <i class="el-icon-check"></i> 保存修改
                    </el-button>
                    <el-button @click="resetForm">
                      <i class="el-icon-refresh-right"></i> 重置
                    </el-button>
                  </el-form-item>
                </el-form>
              </div>
            </div>
          </template>
        </el-skeleton>
      </el-card>
    </div>
  </div>
</template>

<script>
import { ref, reactive, onMounted, onUnmounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import { getUserProfile, updateUserProfile } from '@/api/user';
import { logout as apiLogout } from '@/api/auth';

export default {
  name: 'UserProfile',
  setup() {
    const router = useRouter();
    const formRef = ref(null);
    const loading = ref(true);
    const submitting = ref(false);
    const welcomeCanvas = ref(null);
    let animationFrame = null;
    
    const userInfo = ref({
      id: '',
      username: '',
      email: '',
      phone: '',
      role: ''
    });
    
    const userForm = reactive({
      email: '',
      phone: '',
      password: ''
    });
    
    const rules = {
      email: [
        { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
      ],
      phone: [
        { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
      ],
      password: [
        { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
      ]
    };
    
    // 初始化粒子动画
    const initParticleAnimation = () => {
      const canvas = welcomeCanvas.value;
      if (!canvas) return;
      
      const ctx = canvas.getContext('2d');
      const particles = [];
      
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
    
    // 获取用户个人信息
    const fetchUserProfile = async () => {
      loading.value = true;
      try {
        const res = await getUserProfile();
        if (res.code === 1 && res.data) {
          userInfo.value = res.data;
          // 初始化表单数据
          userForm.email = res.data.email || '';
          userForm.phone = res.data.phone || '';
          userForm.password = '';
        } else {
          ElMessage.error('获取用户信息失败');
        }
      } catch (error) {
        console.error('获取用户信息错误:', error);
        ElMessage.error('获取用户信息失败');
      } finally {
        loading.value = false;
      }
    };
    
    // 提交表单
    const submitForm = () => {
      if (!formRef.value) return;
      
      formRef.value.validate(async (valid) => {
        if (valid) {
          submitting.value = true;
          
          // 构建提交的数据，只包含实际修改的字段
          const updateData = {};
          if (userForm.email !== userInfo.value.email) {
            updateData.email = userForm.email;
          }
          if (userForm.phone !== userInfo.value.phone) {
            updateData.phone = userForm.phone;
          }
          if (userForm.password) {
            updateData.password = userForm.password;
          }
          
          // 如果没有修改任何内容，则不提交
          if (Object.keys(updateData).length === 0) {
            ElMessage.info('没有修改任何内容');
            submitting.value = false;
            return;
          }
          
          try {
            const res = await updateUserProfile(updateData);
            if (res.code === 1) {
              ElMessage.success('个人信息更新成功');
              // 更新本地数据
              userInfo.value = { ...userInfo.value, ...res.data };
              // 清空密码字段
              userForm.password = '';
            } else {
              ElMessage.error(res.msg || '更新失败');
            }
          } catch (error) {
            console.error('更新用户信息错误:', error);
            ElMessage.error('更新用户信息失败');
          } finally {
            submitting.value = false;
          }
        } else {
          ElMessage.warning('请正确填写表单');
        }
      });
    };
    
    // 重置表单
    const resetForm = () => {
      userForm.email = userInfo.value.email || '';
      userForm.phone = userInfo.value.phone || '';
      userForm.password = '';
      if (formRef.value) {
        formRef.value.clearValidate();
      }
    };
    
    // 退出登录
    const logout = () => {
      ElMessageBox.confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          await apiLogout();
          // 在请求成功后再清除token
          localStorage.removeItem('token');
          router.push('/login');
          ElMessage.success('退出登录成功');
        } catch (error) {
          console.error('退出登录错误:', error);
          // 即使登出API请求失败，也清除本地token并跳转到登录页
          localStorage.removeItem('token');
          router.push('/login');
          ElMessage.warning('登出请求失败，但已清除本地登录状态');
        }
      }).catch(() => {});
    };
    
    // 跳转到首页
    const goToDashboard = () => {
      router.push('/dashboard');
    };
    
    // 根据角色获取标签类型
    const getRoleTagType = (role) => {
      const typeMap = {
        'admin': 'danger',
        'ambassador': 'success',
        'brand': 'warning',
        'user': 'info'
      };
      return typeMap[role] || 'info';
    };
    
    // 根据角色获取显示名称
    const getRoleLabel = (role) => {
      const labelMap = {
        'admin': '管理员',
        'ambassador': '大使',
        'brand': '品牌方',
        'user': '普通用户'
      };
      return labelMap[role] || '未知角色';
    };
    
    onMounted(() => {
      fetchUserProfile();
      // 初始化粒子动画，并获取清理函数
      const cleanupParticleAnimation = initParticleAnimation();
      
      // 组件卸载时清理
      onUnmounted(() => {
        if (cleanupParticleAnimation) {
          cleanupParticleAnimation();
        }
      });
    });
    
    return {
      formRef,
      welcomeCanvas,
      loading,
      submitting,
      userInfo,
      userForm,
      rules,
      submitForm,
      resetForm,
      logout,
      goToDashboard,
      getRoleTagType,
      getRoleLabel
    };
  }
};
</script>

<style scoped>
/* 全局变量 */
:root {
  --main-font: 'Microsoft YaHei', '微软雅黑', 'Source Sans Pro', 'Nunito', 'HarmonyOS Sans SC', 'PingFang SC', 'Hiragino Sans GB', sans-serif;
  --title-font: 'Microsoft YaHei', '微软雅黑', 'Montserrat', 'HarmonyOS Sans SC', 'PingFang SC', 'Hiragino Sans GB', sans-serif;
}

.user-profile-container {
  min-height: 100vh;
  background-color: #f5f9fc;
  display: flex;
  flex-direction: column;
  width: 100vw;
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: var(--main-font);
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

.navigation-actions {
  display: flex;
  align-items: center;
  gap: 15px;
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 5px;
}

.main-content {
  padding: 24px;
  display: flex;
  flex-direction: column;
  flex: 1;
  gap: 24px;
  width: 100%;
  box-sizing: border-box;
  margin: 0;
}

.welcome-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(to right, #f1f8ff, #ffffff);
  padding: 16px 20px;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
  position: relative;
  overflow: hidden;
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

.welcome-text {
  font-size: 22px;
  color: #2c3e50;
  font-weight: 600;
  margin: 0;
  font-family: var(--title-font);
  letter-spacing: 0.02em;
  position: relative;
  z-index: 2;
}

.header-actions {
  display: flex;
  gap: 10px;
  position: relative;
  z-index: 2;
}

.profile-card {
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
  transition: all 0.3s;
  overflow: hidden;
  width: 100%;
  border: none;
  background: linear-gradient(145deg, #ffffff, #f8fbff);
}

.profile-card:hover {
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
  font-size: 18px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.card-header span i {
  font-size: 18px;
}

.user-info-container {
  padding: 20px;
}

.user-basic-info {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 20px;
}

.user-avatar {
  flex-shrink: 0;
}

.avatar-circle {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #409EFF, #53a8ff);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 32px;
  font-weight: bold;
  box-shadow: 0 4px 10px rgba(64, 158, 255, 0.3);
}

.user-details {
  flex-grow: 1;
}

.username {
  font-size: 24px;
  font-weight: 600;
  margin: 0 0 5px 0;
  color: #2c3e50;
}

.user-id {
  font-size: 14px;
  color: #606266;
  margin-bottom: 8px;
}

.user-role {
  margin-top: 5px;
}

.section-divider {
  height: 1px;
  background: linear-gradient(to right, rgba(0,0,0,0.03), rgba(0,0,0,0.08), rgba(0,0,0,0.03));
  width: 100%;
  margin: 15px 0 20px;
}

.section-title {
  font-size: 18px;
  color: #2c3e50;
  margin: 0 0 20px 0;
  font-weight: 600;
  position: relative;
  padding-left: 12px;
  border-left: 3px solid #409EFF;
  font-family: var(--title-font);
  letter-spacing: 0.02em;
}

.edit-form {
  max-width: 600px;
  margin: 0 auto;
}

.form-actions {
  margin-top: 30px;
  display: flex;
  justify-content: center;
  gap: 15px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header {
    padding: 12px 15px;
  }
  
  .welcome-section {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
    padding: 15px;
  }
  
  .welcome-text {
    font-size: 20px;
  }
  
  .main-content {
    padding: 15px;
  }
  
  .user-basic-info {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }
  
  .avatar-circle {
    margin-bottom: 10px;
  }
  
  .edit-form {
    padding: 0 10px;
  }
}
</style> 