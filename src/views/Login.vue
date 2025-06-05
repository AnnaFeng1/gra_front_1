<template>
  <div class="login-container">
    <!-- 背景藤曼效果 -->
    <GrowingVines 
      :paused="isFormHovered" 
      :dots-count="100" 
      :connection-distance="150" 
      :mouse-radius="180"
      :dot-speed="1.0"
      :attraction-strength="0.12"
      line-color="rgba(64, 158, 255, 0.5)"
      node-color="rgba(64, 158, 255, 0.65)"
    />
    
    <div class="login-box" 
      @mouseenter="isFormHovered = true"
      @mouseleave="isFormHovered = false">
      <div class="login-header">
        <div class="logo">营销推广管理系统</div>
      </div>
      
      <el-form 
        ref="loginFormRef" 
        :model="loginForm" 
        :rules="loginRules" 
        class="login-form" 
        @keyup.enter="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名"
            :prefix-icon="User"
            clearable
            autofocus
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>
        
        <div class="login-options">
          <el-checkbox v-model="rememberMe">记住我</el-checkbox>
          <a href="#" class="forget-link">忘记密码?</a>
        </div>
        
        <el-form-item>
          <el-button 
            :loading="loading" 
            type="primary" 
            class="login-button" 
            @click="handleLogin"
          >
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form-item>
      </el-form>
      
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { User, Lock } from '@element-plus/icons-vue';
import { login, getUserInfo } from '@/api/auth';
import GrowingVines from '@/components/GrowingVines.vue';

const router = useRouter();
const loading = ref(false);
const rememberMe = ref(false);
// 表单悬停状态
const isFormHovered = ref(false);

// 登录表单数据
const loginForm = reactive({
  username: '',
  password: ''
});

// 表单验证规则
const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6个字符', trigger: 'blur' }
  ]
};

// 登录表单引用
const loginFormRef = ref(null);

// 处理登录
const handleLogin = async () => {
  if (loading.value) return;
  
  // 确保表单引用存在
  if (!loginFormRef.value) {
    console.error('登录表单引用不存在');
    return;
  }
  
  loginFormRef.value.validate(async (valid) => {
    if (!valid) return;
    
    try {
      loading.value = true;
      
      const response = await login(loginForm.username, loginForm.password);
      
      if (response.code === 1) {
        // 登录成功，保存token
        // 确保token值是正确的JWT字符串
        localStorage.setItem('token', response.data);
        
        // 如果选择了"记住我"，保存用户名
        if (rememberMe.value) {
          localStorage.setItem('rememberedUsername', loginForm.username);
        } else {
          localStorage.removeItem('rememberedUsername');
        }
        
        // 获取用户信息，包括角色
        const userInfoResponse = await getUserInfo();
        if (userInfoResponse.code === 1) {
          const userRole = userInfoResponse.data.role;
          // 保存用户角色到localStorage
          localStorage.setItem('userRole', userRole);
          localStorage.setItem('userInfo', JSON.stringify(userInfoResponse.data));
          
          ElMessage.success('登录成功');
          
          // 根据角色跳转到不同的首页
          if (userRole === 'admin') {
            router.push('/admin-dashboard');
          } else if (userRole === 'leader') {
            router.push('/leader-dashboard');
          } else if (userRole === 'ambassador') {
            router.push('/dashboard');
          } else {
            // 未知角色，默认跳转到首页，系统会根据角色重定向
            router.push('/');
          }
        } else {
          ElMessage.error('获取用户信息失败');
          // 清除登录状态
          localStorage.removeItem('token');
        }
      } else {
        ElMessage.error(response.msg || '登录失败，请检查用户名和密码');
      }
    } catch (error) {
      console.error('登录失败:', error);
      ElMessage.error('登录失败，请稍后重试');
    } finally {
      loading.value = false;
    }
  });
};

// 在组件挂载时检查是否有记住的用户名
onMounted(() => {
  const rememberedUsername = localStorage.getItem('rememberedUsername');
  if (rememberedUsername) {
    loginForm.username = rememberedUsername;
    rememberMe.value = true;
  }
});
</script>

<style scoped>
:root {
  --primary-color: #409EFF;
  --text-color: #2c3e50;
  --border-color: #dcdfe6;
  --background-color: #f5f9fc;
  --box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  --font-family: 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
}

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  width: 100vw;
  background: linear-gradient(135deg, #f6f9fc 0%, #eaeff5 100%);
  font-family: var(--font-family);
  position: relative;
  overflow: hidden;
}

/* 添加背景装饰元素 */
.login-container::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(64, 158, 255, 0.1) 0%, rgba(64, 158, 255, 0) 70%);
  transform: rotate(30deg);
  z-index: 0;
  animation: pulse 15s infinite alternate ease-in-out;
}

.login-container::after {
  content: '';
  position: absolute;
  bottom: -50%;
  left: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(64, 158, 255, 0.08) 0%, rgba(64, 158, 255, 0) 60%);
  transform: rotate(-25deg);
  z-index: 0;
  animation: pulse 12s infinite alternate-reverse ease-in-out;
}

@keyframes pulse {
  0% {
    opacity: 0.5;
    transform: rotate(30deg) scale(1);
  }
  50% {
    opacity: 0.8;
    transform: rotate(30deg) scale(1.05);
  }
  100% {
    opacity: 0.5;
    transform: rotate(30deg) scale(1);
  }
}

.login-box {
  width: 400px;
  padding: 35px;
  background-color: rgba(255, 255, 255, 0.85);
  border-radius: 16px;
  box-shadow: 
    0 20px 50px rgba(0, 0, 0, 0.12), 
    0 10px 20px rgba(0, 0, 0, 0.05),
    0 0 0 1px rgba(255, 255, 255, 0.1) inset,
    0 0 1px rgba(64, 158, 255, 0.2);
  transition: all 0.5s cubic-bezier(0.215, 0.61, 0.355, 1);
  position: relative;
  z-index: 100;
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.15);
  overflow: hidden;
}

.login-box::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 3px;
  background: linear-gradient(90deg, transparent, #409EFF, transparent);
  transition: all 0.6s ease;
}

.login-box::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  width: 100%;
  background: linear-gradient(to bottom, 
    rgba(255, 255, 255, 0.1) 0%, 
    rgba(255, 255, 255, 0.05) 40%, 
    rgba(255, 255, 255, 0) 100%);
  pointer-events: none;
}

.login-box:hover {
  transform: translateY(-5px);
  box-shadow: 
    0 25px 50px rgba(0, 0, 0, 0.15), 
    0 10px 20px rgba(0, 0, 0, 0.05),
    0 0 0 1px rgba(255, 255, 255, 0.2) inset,
    0 0 1px rgba(64, 158, 255, 0.3);
}

.login-box:hover::before {
  left: 100%;
}

.login-header {
  text-align: center;
  margin-bottom: 40px;
  padding-top: 10px;
}

.logo {
  font-size: 28px;
  font-weight: bold;
  color: var(--primary-color);
  letter-spacing: 1px;
  text-shadow: 0 2px 4px rgba(64, 158, 255, 0.2);
  padding: 5px 0;
}

.login-form {
  margin-bottom: 25px;
}

.login-form :deep(.el-input__wrapper) {
  box-shadow: 0 0 0 1px rgba(220, 223, 230, 0.5) inset;
  border-radius: 8px;
  padding: 0 15px;
  transition: all 0.3s ease;
}

.login-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px var(--primary-color) inset;
}

.login-form :deep(.el-input__inner) {
  height: 45px;
}

.login-form :deep(.el-form-item) {
  margin-bottom: 20px;
}

.login-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
  color: #606266;
  padding: 0 5px;
}

.forget-link {
  color: var(--primary-color);
  text-decoration: none;
  font-size: 14px;
}

.forget-link:hover {
  text-decoration: underline;
}

.login-button {
  width: 100%;
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 50px;
  transition: all 0.3s ease;
  background: linear-gradient(135deg, #409EFF 0%, #007FFF 100%);
  border: none;
  box-shadow: 0 5px 15px rgba(64, 158, 255, 0.3);
  letter-spacing: 2px;
}

.login-button:not(.is-loading):hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(64, 158, 255, 0.5);
  background: linear-gradient(135deg, #3a8ee6 0%, #0066cc 100%);
}

.login-button:not(.is-loading):active {
  transform: translateY(1px);
  box-shadow: 0 3px 10px rgba(64, 158, 255, 0.4);
}

/* 响应式设计 */
@media (max-width: 480px) {
  .login-box {
    width: 90%;
    padding: 20px;
  }
}
</style> 