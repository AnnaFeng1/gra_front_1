<template>
  <div class="individual-ambassador-management" @wheel.stop>
    <!-- 标题和搜索区域 -->
    <div class="header-card">
      <div class="title-area">
        <h2>独立推广大使管理</h2>
        <div class="button-group">
          <el-tooltip content="添加推广大使" placement="bottom">
            <el-button type="primary" :icon="Plus" @click="handleAddAmbassador" circle></el-button>
          </el-tooltip>
        </div>
      </div>
      
      <div class="search-area">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索用户名/邮箱/电话"
          :prefix-icon="Search"
          clearable
          @clear="loadData"
          @keyup.enter.native="handleSearch"
        >
          <template #append>
            <el-button :icon="Search" @click="handleSearch"></el-button>
          </template>
        </el-input>
      </div>
    </div>
    
    <!-- 表格区域 -->
    <div class="table-card">
      <el-table
        v-loading="loading"
        :data="ambassadorList"
        style="width: 100%"
        @sort-change="handleSortChange"
        :header-cell-style="{ background: '#f5f7fa', color: '#606266' }"
        :cell-style="{ padding: '12px 0' }"
      >
        <el-table-column prop="id" label="ID" width="80" sortable="custom"></el-table-column>
        <el-table-column prop="username" label="用户名" sortable="custom"></el-table-column>
        <el-table-column prop="email" label="电子邮箱" min-width="180"></el-table-column>
        <el-table-column prop="phone" label="电话" min-width="140"></el-table-column>
        <el-table-column prop="created_at" label="创建时间" min-width="180" sortable="custom">
          <template #default="scope">
            {{ formatDate(scope.row.created_at) }}
          </template>
        </el-table-column>
        <el-table-column prop="conversions" label="转化数" width="100" align="center" sortable="custom"></el-table-column>
        <el-table-column prop="commission" label="总佣金(元)" min-width="120" align="right" sortable="custom">
          <template #default="scope">
            {{ formatCurrency(scope.row.commission) }}
          </template>
        </el-table-column>
        
        <!-- 操作列 -->
        <el-table-column label="操作" width="180" fixed="right" align="center">
          <template #default="scope">
            <div class="action-buttons-group">
              <el-tooltip content="查看详情" placement="top">
                <el-button 
                  type="primary" 
                  circle 
                  size="small" 
                  @click="handleViewDetails(scope.row)"
                >
                  <el-icon><View /></el-icon>
                </el-button>
              </el-tooltip>
              
              <el-tooltip content="编辑" placement="top">
                <el-button 
                  type="warning" 
                  circle 
                  size="small" 
                  @click="handleEdit(scope.row)"
                >
                  <el-icon><Edit /></el-icon>
                </el-button>
              </el-tooltip>
              
              <el-tooltip content="删除" placement="top">
                <el-button 
                  type="danger" 
                  circle 
                  size="small" 
                  @click="handleDelete(scope.row)"
                >
                  <el-icon><Delete /></el-icon>
                </el-button>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>
    
    <!-- 分页区域 -->
    <div class="pagination-card">
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
    
    <!-- 添加/编辑独立推广大使对话框 -->
    <el-dialog
      :title="dialogType === 'add' ? '添加独立推广大使' : '编辑独立推广大使'"
      v-model="formVisible"
      width="500px"
      @closed="resetForm"
      destroy-on-close
    >
      <el-form 
        ref="formRef" 
        :model="formData" 
        :rules="formRules" 
        label-width="100px"
        label-position="right"
        class="ambassador-form"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="formData.username" placeholder="请输入用户名"></el-input>
        </el-form-item>
        
        <el-form-item label="密码" prop="password" v-if="dialogType === 'add'">
          <el-input 
            v-model="formData.password" 
            type="password" 
            placeholder="请输入密码" 
            show-password
          ></el-input>
        </el-form-item>
        
        <el-form-item label="电子邮箱" prop="email">
          <el-input v-model="formData.email" placeholder="请输入电子邮箱"></el-input>
        </el-form-item>
        
        <el-form-item label="电话" prop="phone">
          <el-input v-model="formData.phone" placeholder="请输入电话号码"></el-input>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="formVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting">提交</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 查看推广大使详情对话框 -->
    <el-dialog
      title="推广大使详情"
      v-model="detailVisible"
      width="600px"
      destroy-on-close
    >
      <div v-loading="detailLoading" class="detail-container">
        <template v-if="ambassadorDetail">
          <div class="detail-section">
            <h3 class="detail-title">基本信息</h3>
            <el-descriptions :column="1" size="default" border>
              <el-descriptions-item label="ID">{{ ambassadorDetail.id }}</el-descriptions-item>
              <el-descriptions-item label="用户名">{{ ambassadorDetail.username }}</el-descriptions-item>
              <el-descriptions-item label="电子邮箱">{{ ambassadorDetail.email || '未设置' }}</el-descriptions-item>
              <el-descriptions-item label="电话">{{ ambassadorDetail.phone || '未设置' }}</el-descriptions-item>
              <el-descriptions-item label="创建时间">{{ formatDate(ambassadorDetail.created_at) }}</el-descriptions-item>
              <el-descriptions-item label="最后更新时间">{{ formatDate(ambassadorDetail.updated_at) }}</el-descriptions-item>
            </el-descriptions>
          </div>
          
          <div class="detail-section">
            <h3 class="detail-title">转化统计</h3>
            <el-descriptions :column="2" size="default" border>
              <el-descriptions-item label="总转化数">{{ ambassadorDetail.conversion_stats?.total_conversions || 0 }}</el-descriptions-item>
              <el-descriptions-item label="当前营期转化数">{{ ambassadorDetail.conversion_stats?.current_camp_conversions || 0 }}</el-descriptions-item>
              <el-descriptions-item label="最近转化时间" :span="2">
                {{ ambassadorDetail.conversion_stats?.last_conversion_time ? formatDate(ambassadorDetail.conversion_stats.last_conversion_time) : '暂无记录' }}
              </el-descriptions-item>
            </el-descriptions>
          </div>
          
          <div class="detail-section">
            <h3 class="detail-title">佣金统计</h3>
            <el-descriptions :column="2" size="default" border>
              <el-descriptions-item label="总佣金">{{ formatCurrency(ambassadorDetail.commission_stats?.total_commission || 0) }} 元</el-descriptions-item>
              <el-descriptions-item label="当前营期佣金">{{ formatCurrency(ambassadorDetail.commission_stats?.current_camp_commission || 0) }} 元</el-descriptions-item>
            </el-descriptions>
        </div>
        </template>
      </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="detailVisible = false">关闭</el-button>
          <el-tooltip content="编辑推广大使" placement="top">
            <el-button type="warning" circle @click="handleEditFromDetail">
              <el-icon><Edit /></el-icon>
            </el-button>
          </el-tooltip>
        </span>
      </template>
    </el-dialog>
    
    <!-- 删除确认对话框 -->
    <el-dialog
      title="确认删除"
      v-model="deleteVisible"
      width="400px"
      destroy-on-close
    >
      <div class="delete-confirm-content">
        <p>确定要删除推广大使 <strong>{{ ambassadorToDelete?.username }}</strong> 吗？</p>
        <p class="delete-warning">注意：只能删除没有任何推广记录的独立推广大使！</p>
      </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="deleteVisible = false">取消</el-button>
          <el-tooltip content="确认删除" placement="top">
            <el-button type="danger" circle @click="confirmDelete" :loading="deleting">
              <el-icon><Delete /></el-icon>
            </el-button>
          </el-tooltip>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { getIndependentAmbassadorsList, addIndependentAmbassador, getIndependentAmbassadorDetail, updateIndependentAmbassador, deleteIndependentAmbassador } from '@/api/admin';
import { ref, reactive, onMounted, onBeforeUnmount, markRaw } from 'vue';
import { Search, Refresh, Plus, View, Edit, Delete } from '@element-plus/icons-vue';
import { ElMessage, ElMessageBox } from 'element-plus';

export default {
  name: 'IndividualAmbassadorManagement',
  components: {
    // 使用markRaw保证图标组件不会被Vue包装成响应式对象
    Search: markRaw(Search),
    Refresh: markRaw(Refresh),
    Plus: markRaw(Plus),
    View: markRaw(View),
    Edit: markRaw(Edit),
    Delete: markRaw(Delete)
  },
  setup() {
      // 列表数据
    const ambassadorList = ref([]);
    const loading = ref(false);
    const total = ref(0);
    const currentPage = ref(1);
    const pageSize = ref(10);
    const searchKeyword = ref('');
    const sortField = ref('id');
    const sortOrder = ref('desc');
    
    // 表单相关
    const formRef = ref(null);
    const formVisible = ref(false);
    const submitting = ref(false);
    const dialogType = ref('add'); // 'add' 或 'edit'
    
    const formData = reactive({
        username: '',
      password: '',
        email: '',
      phone: ''
    });
    
    const formRules = {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
        { min: 3, max: 20, message: '用户名长度需在3到20个字符之间', trigger: 'blur' }
      ],
      password: [
        { required: true, message: '请输入密码', trigger: 'blur' },
        { min: 8, message: '密码长度不能少于8个字符', trigger: 'blur' }
        ],
        email: [
        { type: 'email', message: '请输入正确的电子邮箱格式', trigger: 'blur' }
        ],
        phone: [
        { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
      ]
    };
    
    // 详情相关
    const detailVisible = ref(false);
    const detailLoading = ref(false);
    const ambassadorDetail = ref(null);
    
    // 删除相关
    const deleteVisible = ref(false);
    const ambassadorToDelete = ref(null);
    const deleting = ref(false);
    
    // 加载列表数据
    const loadData = async () => {
      loading.value = true;
      
      // 构建请求参数
      const params = {
        page: currentPage.value,
        size: pageSize.value,
        sort_field: sortField.value,
        sort_order: sortOrder.value
      };
      
      // 添加搜索关键词（如果有）
      if (searchKeyword.value && searchKeyword.value.trim() !== '') {
        params.keyword = searchKeyword.value.trim();
      }
      
      console.log('开始请求独立推广大使列表数据，参数:', params);
      
      // 调用API获取数据
      try {
        const response = await getIndependentAmbassadorsList(params);
        console.log('获取独立推广大使列表响应:', response);
        
        // 注意：根据request.js中的响应拦截器，这里的response已经是response.data
        // 并且已经检查过code===1了
        
        // 检查数据结构
        if (!response.data) {
          ElMessage.warning('API返回了成功状态，但没有数据');
          // 设置为空数组
          ambassadorList.value = [];
          total.value = 0;
          return;
        }
        
        const data = response.data;
        console.log('响应中的data字段:', data);
        
        // 尝试多种可能的数据结构
        if (Array.isArray(data)) {
          // 如果data直接是数组
          ambassadorList.value = data;
          total.value = data.length;
        } else if (data.records) {
          // 标准分页结构
          ambassadorList.value = data.records;
          total.value = data.total || data.records.length;
          currentPage.value = data.current || currentPage.value;
        } else if (data.list) {
          // 另一种可能的分页结构
          ambassadorList.value = data.list;
          total.value = data.total || data.list.length;
          currentPage.value = data.current || currentPage.value;
          } else {
          // 未知结构，尝试推断
          console.warn('未知的数据结构:', data);
          const possibleListFields = Object.keys(data).filter(key => 
            Array.isArray(data[key]) && data[key].length > 0
          );
          
          if (possibleListFields.length > 0) {
            const listField = possibleListFields[0];
            console.log(`尝试使用 ${listField} 作为列表字段`);
            ambassadorList.value = data[listField];
            total.value = ambassadorList.value.length;
          } else {
            ElMessage.warning('无法识别的数据结构，显示空列表');
            ambassadorList.value = [];
            total.value = 0;
          }
        }
        
        console.log('成功解析数据，获取到记录数:', ambassadorList.value.length);
      } catch (error) {
        console.error('获取独立推广大使列表失败:', error);
        
        // 因为request.js中已经处理了错误提示，这里不需要再次显示
        
        // 设置为空数组
        ambassadorList.value = [];
        total.value = 0;
      } finally {
        loading.value = false;
      }
    };
    
    // 滚动事件处理
    const handleWheel = (event) => {
      // 阻止滚动冒泡到父元素
      event.stopPropagation();
    };
    
    // 组件挂载和卸载时的事件处理
    onMounted(() => {
      loadData();
    });
    
    // 分页和排序处理
    const handleCurrentChange = (page) => {
      currentPage.value = page;
      loadData();
    };
    
    const handleSizeChange = (size) => {
      pageSize.value = size;
      currentPage.value = 1; // 重置到第一页
      loadData();
    };
    
    const handleSortChange = ({ prop, order }) => {
      sortField.value = prop || 'id';
      sortOrder.value = order === 'ascending' ? 'asc' : 'desc';
      loadData();
    };
    
    // 搜索处理
    const handleSearch = () => {
      currentPage.value = 1; // 重置到第一页
      loadData();
    };
    
    // 打开添加对话框
    const handleAddAmbassador = () => {
      dialogType.value = 'add';
      resetForm();
      formVisible.value = true;
    };
    
    // 重置表单
    const resetForm = () => {
      if (formRef.value) {
        formRef.value.resetFields();
      }
      Object.assign(formData, {
        username: '',
        password: '',
        email: '',
        phone: ''
      });
    };
    
    // 查看详情
    const handleViewDetails = async (row) => {
      detailVisible.value = true;
      detailLoading.value = true;
      ambassadorDetail.value = null;
      
      try {
        const response = await getIndependentAmbassadorDetail(row.id);
        ambassadorDetail.value = response.data;
      } catch (error) {
        console.error('获取推广大使详情失败:', error);
      } finally {
        detailLoading.value = false;
      }
    };
    
    // 编辑
    const handleEdit = (row) => {
      dialogType.value = 'edit';
      resetForm();
      
      // 填充表单数据
      Object.assign(formData, {
        id: row.id,
        username: row.username,
        email: row.email || '',
        phone: row.phone || '',
        password: '' // 编辑时不显示密码字段，由用户选择是否修改
      });
      
      formVisible.value = true;
    };
    
    // 从详情页进入编辑
    const handleEditFromDetail = () => {
      if (!ambassadorDetail.value) return;
      
      detailVisible.value = false;
      
      dialogType.value = 'edit';
      resetForm();
      
      // 填充表单数据
      Object.assign(formData, {
        id: ambassadorDetail.value.id,
        username: ambassadorDetail.value.username,
        email: ambassadorDetail.value.email || '',
        phone: ambassadorDetail.value.phone || '',
        password: ''
      });
      
      formVisible.value = true;
    };
    
    // 删除
    const handleDelete = (row) => {
      ambassadorToDelete.value = row;
      deleteVisible.value = true;
    };
    
    // 确认删除
    const confirmDelete = async () => {
      if (!ambassadorToDelete.value) return;
      
      deleting.value = true;
      
      try {
        await deleteIndependentAmbassador(ambassadorToDelete.value.id);
        ElMessage.success('删除推广大使成功');
        deleteVisible.value = false;
        
        // 刷新列表
        loadData();
      } catch (error) {
        console.error('删除推广大使失败:', error);
      } finally {
        deleting.value = false;
      }
    };
    
    // 提交表单 (修改原有方法)
    const submitForm = async () => {
      if (!formRef.value) return;
      
      formRef.value.validate(async (valid) => {
        if (valid) {
          submitting.value = true;
          
          try {
            let response;
            
            if (dialogType.value === 'add') {
              // 添加推广大使
              const params = {
                username: formData.username,
                password: formData.password
              };
              
              // 添加可选字段
              if (formData.email) params.email = formData.email;
              if (formData.phone) params.phone = formData.phone;
              
              response = await addIndependentAmbassador(params);
              ElMessage.success('添加推广大使成功');
          } else {
              // 更新推广大使
              const params = {
                username: formData.username
              };
              
              // 添加可选字段
              if (formData.email) params.email = formData.email;
              if (formData.phone) params.phone = formData.phone;
              if (formData.password) params.password = formData.password;
              
              response = await updateIndependentAmbassador(formData.id, params);
              ElMessage.success('更新推广大使成功');
            }
            
            formVisible.value = false;
            
            // 刷新列表
            loadData();
          } catch (error) {
            console.error(`${dialogType.value === 'add' ? '添加' : '更新'}推广大使失败:`, error);
            // request.js已经处理了错误提示
          } finally {
            submitting.value = false;
          }
          } else {
          ElMessage.warning('请正确填写表单信息');
          return false;
          }
        });
    };
    
    // 辅助方法
    const formatDate = (dateStr) => {
      if (!dateStr) return '';
      
      const date = new Date(dateStr);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      
      return `${year}-${month}-${day} ${hours}:${minutes}`;
    };
    
    const formatCurrency = (value) => {
      if (value === undefined || value === null) return '0.00';
      return parseFloat(value).toFixed(2);
    };
    
    return {
      // 图标
      Search,
      Refresh,
      Plus,
      View,
      Edit,
      Delete,
      
      // 搜索和筛选
      searchKeyword,
      handleSearch,
      
      // 表格数据
      ambassadorList,
      loading,
      total,
      
      // 分页
      currentPage,
      pageSize,
      handleCurrentChange,
      handleSizeChange,
      handleSortChange,
      
      // 加载数据
      loadData,
      
      // 表单相关
      formRef,
      formVisible,
      formData,
      formRules,
      dialogType,
      submitting,
      handleAddAmbassador,
      resetForm,
      submitForm,
      
      // 辅助方法
      formatDate,
      formatCurrency,
      
      // 详情相关
      detailVisible,
      detailLoading,
      ambassadorDetail,
      handleViewDetails,
      handleEditFromDetail,
      
      // 编辑相关
      handleEdit,
      
      // 删除相关
      deleteVisible,
      ambassadorToDelete,
      deleting,
      handleDelete,
      confirmDelete,
      
      // 滚动事件处理
      handleWheel
    };
  }
};
</script>

<style scoped>
.individual-ambassador-management {
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 20px;
  background-color: #f6f8fa;
  overflow: auto; /* 使组件成为一个可滚动容器 */
  overscroll-behavior: contain; /* 防止滚动传播 */
  position: relative; /* 提供一个定位上下文 */
  scrollbar-width: thin; /* Firefox */
  scrollbar-color: #c0c4cc #f6f8fa; /* Firefox */
}

/* 自定义滚动条样式 */
.individual-ambassador-management::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

.individual-ambassador-management::-webkit-scrollbar-track {
  background: #f6f8fa;
  border-radius: 4px;
}

.individual-ambassador-management::-webkit-scrollbar-thumb {
  background-color: #c0c4cc;
  border-radius: 4px;
  border: 2px solid #f6f8fa;
}

.individual-ambassador-management::-webkit-scrollbar-thumb:hover {
  background-color: #909399;
}

.header-card {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0; /* 防止头部卡片收缩 */
}

.title-area {
  display: flex;
  align-items: center;
  width: 100%;
}

.title-area h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 12px;
}

.title-area h2:before {
  content: '';
  position: absolute;
  left: 0;
  top: 4px;
  height: 18px;
  width: 4px;
  background: linear-gradient(to bottom, #409EFF, #1677FF);
  border-radius: 2px;
}

.button-group {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-right: auto; /* 添加右侧自动边距，使按钮靠近标题 */
  margin-left: 30px; /* 添加左侧边距，让按钮与标题保持一定距离 */
}

.button-group :deep(.el-button--circle) {
  width: 48px;
  height: 48px;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 2px 12px rgba(64, 158, 255, 0.3);
}

.button-group :deep(.el-button--circle:hover) {
  transform: translateY(-3px);
  box-shadow: 0 4px 18px rgba(64, 158, 255, 0.5);
}

.button-group :deep(.el-button--circle:active) {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.4);
}

.search-area {
  width: 300px;
}

.table-card {
  flex: 1;
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  overflow: auto;
  min-height: 300px; /* 确保表格区域有最小高度 */
}

/* 自定义Element Plus表格样式 */
:deep(.el-table) {
  --el-table-border-color: #ebeef5;
  --el-table-border: 1px solid var(--el-table-border-color);
  border-radius: 6px;
  overflow: hidden;
}

:deep(.el-table--border) {
  border: 1px solid #ebeef5;
  border-right: none;
  border-bottom: none;
}

:deep(.el-table--border .el-table__cell) {
  border-right: 1px solid #ebeef5;
}

:deep(.el-table__row:hover td) {
  background-color: #ecf5ff !important;
}

.action-buttons-group {
  display: flex;
  gap: 8px;
  justify-content: center;
}

/* 操作按钮样式 */
.action-buttons-group :deep(.el-button--circle) {
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.action-buttons-group :deep(.el-button--circle:hover) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.action-buttons-group :deep(.el-button--circle:active) {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.action-buttons-group :deep(.el-button--primary) {
  background-color: #409EFF;
}

.action-buttons-group :deep(.el-button--warning) {
  background-color: #E6A23C;
}

.action-buttons-group :deep(.el-button--danger) {
  background-color: #F56C6C;
}

.pagination-card {
  background-color: white;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  display: flex;
  justify-content: flex-end;
  flex-shrink: 0; /* 防止分页卡片收缩 */
}

/* 详情对话框样式 */
.detail-container {
  padding: 10px 0;
}

.detail-section {
  margin-bottom: 20px;
}

.detail-title {
  margin: 0 0 12px 0;
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 10px;
}

.detail-title:before {
  content: '';
  position: absolute;
  left: 0;
  top: 3px;
  height: 14px;
  width: 3px;
  background: #409EFF;
  border-radius: 2px;
}

/* 删除确认对话框样式 */
.delete-confirm-content {
  text-align: center;
  padding: 20px 0;
}

.delete-warning {
  margin-top: 16px;
  color: #E6A23C;
  font-size: 14px;
  background-color: #fdf6ec;
  padding: 8px 12px;
  border-radius: 4px;
}

/* 表单样式 */
.ambassador-form {
  padding: 10px 0;
}

:deep(.el-form-item__label) {
  font-weight: 500;
}

:deep(.el-input__inner) {
  border-radius: 4px;
}

:deep(.el-dialog__header) {
  padding: 20px;
  margin-right: 0;
  border-bottom: 1px solid #ebeef5;
}

:deep(.el-dialog__footer) {
  padding: 20px;
  border-top: 1px solid #ebeef5;
}

:deep(.el-dialog__body) {
  padding: 30px 20px;
}

/* 对话框中的图标按钮样式 */
.dialog-footer :deep(.el-button--circle) {
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  margin-left: 12px;
}

.dialog-footer :deep(.el-button--circle:hover) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.dialog-footer :deep(.el-button--circle:active) {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 防止文本选择样式 */
</style> 