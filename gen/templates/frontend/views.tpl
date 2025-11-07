<template>
    <div class="snow-fill">
        <a-card :loading="loading">
                <a-space wrap>
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
                    <a-input-search v-model="searchForm.{{.JsonTag}}" placeholder="请输入{{.Comment}}搜索" style="width: 240px;"
                        @search="handleSearch" allow-clear />
{{- end}}
{{- end}}
                    <a-button type="primary" @click="handleSearch">查询</a-button>
                    <a-button @click="handleReset">重置</a-button>
                    <a-button type="primary" @click="handleCreate" v-hasPerm="['plugins:{{.DirName}}:add']">
                        <template #icon>
                            <icon-plus />
                        </template>
                        <span>新增数据</span>
                    </a-button>
                </a-space>

            <a-table :data="dataList" :loading="loading" :pagination="paginationConfig"
                :bordered="{ wrapper: true, cell: true }" @page-change="handlePageChange"
                @page-size-change="handlePageSizeChange">
                <template #columns>
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
                    <a-table-column title="{{.Comment}}" data-index="{{.JsonTag}}"  :width="150"  ellipsis tooltip/>
{{- else if .IsPrimary}}
                    <a-table-column title="{{.Comment}}" data-index="{{.JsonTag}}" :width="70" align="center" />
{{- end}}
{{- end}}
                    <a-table-column title="操作" :width="200">
                        <template #cell="{ record }">
                            <a-space>
                                <a-button size="small" @click="handleEdit(record)" v-hasPerm="['plugins:{{.DirName}}:edit']">
                                    编辑
                                </a-button>
                                <a-popconfirm content="确定要删除这条数据吗？" @ok="handleDelete(record.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}})">
                                    <a-button size="small" status="danger" v-hasPerm="['plugins:{{.DirName}}:delete']">
                                        删除
                                    </a-button>
                                </a-popconfirm>
                            </a-space>
                        </template>
                    </a-table-column>
                </template>
            </a-table>

        </a-card>

        <!-- 编辑/创建弹窗 -->
        <a-modal v-model:visible="modalVisible" :title="editingData.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}} ? '编辑数据' : '新增数据'" :on-before-ok="handleSave"
            @cancel="handleCancel">
            <a-form :model="editingData" :rules="rules" ref="formRef">
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) }}
                <a-form-item field="{{.JsonTag}}" label="{{.Comment}}">
                    {{- if eq .FrontendType "number"}}<a-input-number v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                    {{- else if eq .GoType "time.Time"}}<a-date-picker value-format="YYYY-MM-DDTHH:mm:ss[Z]" v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}" />
                    {{- else}}<a-input v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />{{- end}}
                </a-form-item>
{{- end}}
{{- end}}
            </a-form>
        </a-modal>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { use{{.StructName}}PluginStore } from '../store/{{.DirName}}';
import type { {{.StructName}}Data } from '../api/{{.DirName}}';
import { storeToRefs } from 'pinia';
const {{.StructNameLower}}Store = use{{.StructName}}PluginStore();
const {
    fetchDataList,
    createData,
    updateData,
    deleteData,
    getDetail,
    resetSearchParams
} = {{.StructNameLower}}Store;
const { dataList, loading, total, currentPage, pageSize } = storeToRefs({{.StructNameLower}}Store);

const modalVisible = ref(false);
const formRef = ref();

// 搜索表单
const searchForm = reactive({
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
    {{.JsonTag}}: '',
{{- end}}
{{- end}}
});

const editingData = reactive({
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
    {{.JsonTag}}: {{if eq .FrontendType "string"}}''{{else if eq .FrontendType "number"}}0{{else if eq .FrontendType "boolean"}}false{{else}}''{{end}},
{{- else if .IsPrimary}}
    {{.JsonTag}}: 0,
{{- end}}
{{- end}}
});

const rules = {
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
    {{.JsonTag}}: [{ required: true, message: '请输入{{.Comment}}' }],
{{- end}}
{{- end}}
};

// 分页配置
const paginationConfig = computed(() => ({
    total: total.value,
    current: currentPage.value,
    pageSize: pageSize.value,
    showTotal: true,
    showJumper: true,
    showPageSize: true,
    pageSizeOptions: [10, 20, 30, 50],
}));

// 获取数据列表
const loadData = async (pageNum: number = currentPage.value, pageSizeVal: number = pageSize.value) => {
    await fetchDataList({
        pageNum,
        pageSize: pageSizeVal,
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
        {{.JsonTag}}: searchForm.{{.JsonTag}} || undefined,
{{- end}}
{{- end}}
    });
};

// 处理分页变化
const handlePageChange = (page: number) => {
    loadData(page, pageSize.value);
};

// 处理页面大小变化
const handlePageSizeChange = (size: number) => {
    loadData(1, size); // 页码重置为1
};

// 搜索处理
const handleSearch = () => {
    loadData(1); // 搜索时重置到第一页
};

// 重置搜索
const handleReset = () => {
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
    searchForm.{{.JsonTag}} = '';
{{- end}}
{{- end}}
    resetSearchParams();
    loadData(1);
};

// 新增数据
const handleCreate = () => {
    // 重置表单数据
    Object.assign(editingData, {
{{- range .Columns}}
{{- if and (not .IsPrimary) (ne .FieldName "CreatedAt") (ne .FieldName "UpdatedAt") (ne .FieldName "DeletedAt") (ne .FieldName "CreatedBy") (ne .FieldName "TenantId")}}
        {{.JsonTag}}: {{if eq .FrontendType "string"}}''{{else if eq .FrontendType "number"}}0{{else if eq .FrontendType "boolean"}}false{{else}}''{{end}},
{{- else if .IsPrimary}}
        {{.JsonTag}}: 0,
{{- end}}
{{- end}}
    });
    modalVisible.value = true;
};

// 编辑数据
const handleEdit = async (record: {{.StructName}}Data) => {
    // 获取详情
    const detail = await getDetail(record.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
    // 赋值给编辑数据
    Object.assign(editingData, detail.data);
    modalVisible.value = true;
};

// 删除数据
const handleDelete = async ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) => {
    try {
        await deleteData({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
        // 重新加载当前页数据
        await loadData();
        // 显示删除成功消息
        // 这里可以使用项目的消息提示机制
    } catch (error) {
        // 显示删除失败消息
        console.error('删除失败:', error);
    }
};

// 保存数据
const handleSave = async () => {
    const isValid = await formRef.value?.validate();
    if (isValid) return false;
    try {
        if (editingData.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}) {
            // 更新数据
            await updateData(editingData);
        } else {
            // 创建数据
            await createData(editingData);
        }
        // 重新加载数据
        await loadData();
    } catch (error) {
        console.error('保存失败:', error);
        return false;
    }
    return true;
};

// 取消操作
const handleCancel = () => {
    modalVisible.value = false;
};

onMounted(async () => {
    // 初始化加载数据
    await loadData();
})

</script>

<style scoped lang="scss">

</style>