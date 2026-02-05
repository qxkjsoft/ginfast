<template>
 <div class="snow-page">
    <div class="snow-inner">
        <a-card :loading="loading" :bordered="false">
                <a-space wrap>
                    <a-button type="primary" @click="handleCreate" v-hasPerm="['plugins:{{.DirName}}{{.FileName}}:add']">
                        <template #icon>
                            <icon-plus />
                        </template>
                        <span>新增数据</span>
                    </a-button>
                </a-space>

            <a-table :data="treeDataList" :loading="loading" :pagination="false"
                :bordered="{ wrapper: true, cell: true }" :row-key="'{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}'" :default-expand-all-rows="true">
                <template #columns>
{{- range .Columns}}
{{- if .ListShow}}
                    {{- if eq .GoType "time.Time"}}
                    <a-table-column title="{{.Comment}}" data-index="{{.JsonTag}}"  :width="150"  ellipsis tooltip>
                        <template #cell="{ record }">
                            {{`{{ record['`}}{{.JsonTag}}{{`'] ? formatTime(record['`}}{{.JsonTag}}{{`']) : "" }}`}}
                        </template>
                    </a-table-column>
                    {{- else}}
                    <a-table-column title="{{.Comment}}" data-index="{{.JsonTag}}"  :width="150"  ellipsis tooltip/>
                    {{- end}}
{{- end}}
{{- end}}
                    <a-table-column title="操作" :width="280">
                        <template #cell="{ record }">
                            <a-space>
                                <a-button size="small" @click="handleAddChild(record)" v-hasPerm="['plugins:{{.DirName}}{{.FileName}}:add']">
                                    <template #icon>
                                        <icon-plus />
                                    </template>
                                    新增子级
                                </a-button>
                                <a-button size="small" @click="handleEdit(record)" v-hasPerm="['plugins:{{.DirName}}{{.FileName}}:edit']">
                                    编辑
                                </a-button>
                                <a-popconfirm content="确定要删除这条数据吗？" @ok="handleDelete(record.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}})">
                                    <a-button size="small" status="danger" v-hasPerm="['plugins:{{.DirName}}{{.FileName}}:delete']">
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
        <a-modal v-model:visible="modalVisible" :title="modalTitle" :on-before-ok="handleSave"
            @cancel="handleCancel">
            <a-form :model="editingData" :rules="rules" ref="formRef">
                {{- if .ParentIdField}}
                <a-form-item field="{{.ParentIdField.JsonTag}}" label="父级">
                    <a-tree-select
                        v-model="editingData.{{.ParentIdField.JsonTag}}"
                        :data="parentTreeData"
                        :field-names="{
                            key: '{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}',
                            title: 'name',
                            children: 'children'
                        }"
                        allow-clear
                        allow-search
                        placeholder="请选择父级，未选择则默认为顶级节点"
                    />
                </a-form-item>
                {{- end}}
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) (not .IsParentKey) .FormShow }}
                <a-form-item field="{{.JsonTag}}" label="{{.Comment}}">
                    {{- if eq .FrontendType "number"}}
                    {{- if or (eq .FormType "") (eq .FormType "number")}}
                    <a-input-number v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                    {{- else if eq .FormType "select"}}
                    <a-select v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}">
                    {{- if ne .DictType ""}}
                        <a-option v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-option>
                    {{- end}}
                    </a-select>
                    {{- else if eq .FormType "radio"}}
                    <a-radio-group v-model="editingData.{{.JsonTag}}">
                    {{- if ne .DictType ""}}
                        <a-radio v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-radio>
                    {{- end}}
                    </a-radio-group>
                    {{- else}}
                    <a-input-number v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />{{- end}}
                    {{- else if eq .GoType "time.Time"}}
                    {{- if eq .FormType "input"}}
                    <a-input v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                    {{- else if eq .FormType "select"}}
                    <a-select v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}">
                        {{- if ne .DictType ""}}
                        <a-option v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-option>
                        {{- end}}
                    </a-select>
                    {{- else if eq .FormType "radio"}}
                    <a-radio-group v-model="editingData.{{.JsonTag}}">
                        {{- if ne .DictType ""}}
                        <a-radio v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-radio>
                        {{- end}}
                    </a-radio-group>
                    {{- else}}
                    <a-date-picker value-format="YYYY-MM-DDTHH:mm:ss[Z]" v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}" />{{- end}}
                    {{- else}}
                    {{- if eq .FormType "textarea"}}
                    <a-textarea v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                    {{- else if eq .FormType "number"}}
                    <a-input-number v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                    {{- else if eq .FormType "select"}}
                    <a-select v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}">
                        {{- if ne .DictType ""}}
                        <a-option v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-option>
                        {{- end}}
                    </a-select>
                    {{- else if eq .FormType "radio"}}<a-radio-group v-model="editingData.{{.JsonTag}}">
                        {{- if ne .DictType ""}}
                        <a-radio v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-radio>
                        {{- end}}
                    </a-radio-group>
                    {{- else if eq .FormType "checkbox"}}
                    <a-checkbox-group
                        :modelValue="editingData.{{.JsonTag}} ? JSON.parse(editingData.{{.JsonTag}}) : []"
                        @update:modelValue="(val: any) => editingData.{{.JsonTag}} = val.length > 0 ? JSON.stringify(val) : undefined">
                        {{- if ne .DictType ""}}
                        <a-checkbox v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-checkbox>
                        {{- end}}
                    </a-checkbox-group>
                    {{- else if eq .FormType "datetime"}}<a-date-picker value-format="YYYY-MM-DDTHH:mm:ss[Z]" v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}" />
                    {{- else if eq .FormType "file"}}
                    <FileUpload v-model="editingData.{{.JsonTag}}" title="{{.Comment}}" />
                    {{- else if eq .FormType "image"}}
                    <ImageUpload v-model="editingData.{{.JsonTag}}" title="{{.Comment}}" />
                    {{- else if eq .FormType "images"}}
                    <MultiImageUpload v-model="{{.JsonTag}}List" title="{{.Comment}}" />
                    {{- else if eq .FormType "richtext"}}
                    <WangEditor v-model="editingData.{{.JsonTag}}" />
                    {{- else}}<a-input v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />{{- end}}
                    {{- end}}
                </a-form-item>
{{- end}}
{{- end}}
            </a-form>
        </a-modal>
    </div>
</div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { use{{.StructName}}PluginHook } from '../../hooks/{{.FileName}}';
import type { {{.StructName}}Data } from '../../api/{{.FileName}}';
import { formatTime } from '@/globals';
{{- $hasImageUpload := false}}
{{- $hasMultiImageUpload := false}}
{{- $hasWangEditor := false}}
{{- $hasFileUpload := false}}
{{- range .Columns}}
{{- if and (eq .GoType "string") (eq .FormType "image")}}
{{- if not $hasImageUpload}}
{{- $hasImageUpload = true}}
import ImageUpload from '@/components/upload/image-upload.vue';
{{- end}}
{{- else if and (eq .GoType "string") (eq .FormType "images")}}
{{- if not $hasMultiImageUpload}}
{{- $hasMultiImageUpload = true}}
import MultiImageUpload from '@/components/upload/multi-image-upload.vue';
{{- end}}
{{- else if and (eq .GoType "string") (eq .FormType "richtext")}}
{{- if not $hasWangEditor}}
{{- $hasWangEditor = true}}
import WangEditor from '@/components/wang-editor/index.vue';
{{- end}}
{{- else if and (eq .GoType "string") (eq .FormType "file")}}
{{- if not $hasFileUpload}}
{{- $hasFileUpload = true}}
import FileUpload from '@/components/upload/file-upload.vue';
{{- end}}
{{- end}}
{{- end}}
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) (ne .DictType "")}}
    {{- if .FormShow}}
const {{.JsonTag}}Option = ref(dictFilter("{{.DictType}}"));
    {{- end}}
{{- end}}
{{- end}}
const {
    loading,
    treeDataList,
    createData,
    updateData,
    deleteData,
    getDetail,
    loadTreeData
} = use{{.StructName}}PluginHook();

const modalVisible = ref(false);
const formRef = ref();
const modalTitle = ref('');

const editingData = reactive<Partial<{{.StructName}}Data>>({
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude)}}
    {{.JsonTag}}: undefined,
{{- else if .IsPrimary}}
    {{.JsonTag}}: undefined,
{{- end}}
{{- end}}
});

const rules = {
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) (not .IsParentKey) .Required }}
    {{.JsonTag}}: [{ required: true, message: '{{.Comment}}不能为空' }],
{{- end}}
{{- end}}
};

/**
 * 过滤树形数据，排除指定ID及其子节点
 * @param nodes 树形节点
 * @param excludeId 要排除的节点ID
 * @returns 过滤后的树形数据
 */
const filterTreeExclude = (nodes: {{.StructName}}Data[], excludeId?: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}): {{.StructName}}Data[] => {
    if (!excludeId) {
        return nodes;
    }
    return nodes
        .filter((node) => node.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}} !== excludeId)
        .map((node) => {
            const newNode = { ...node };
            if (newNode.children && newNode.children.length > 0) {
                const filteredChildren = filterTreeExclude(newNode.children, excludeId);
                if (filteredChildren.length > 0) {
                    newNode.children = filteredChildren;
                } else {
                    delete newNode.children;
                }
            }
            return newNode;
        });
};

/**
 * 用于树形选择器的父级数据计算属性
 * 自动根据当前编辑数据ID排除该节点及其子节点，避免循环引用
 */
const parentTreeData = computed(() => {
    const clonedData = JSON.parse(JSON.stringify(treeDataList.value)) as {{.StructName}}Data[];
    return filterTreeExclude(clonedData, editingData.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
});

// 新增数据
const handleCreate = () => {
    // 重置表单数据
    Object.assign(editingData, {
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude)}}
        {{.JsonTag}}: undefined,
{{- else if .IsPrimary}}
        {{.JsonTag}}: undefined,
{{- end}}
{{- end}}
    });
    modalTitle.value = '新增数据';
    modalVisible.value = true;
};

// 新增子级数据
const handleAddChild = (record: {{.StructName}}Data) => {
    // 重置表单数据
    Object.assign(editingData, {
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude)}}
        {{.JsonTag}}: undefined,
{{- else if .IsPrimary}}
        {{.JsonTag}}: undefined,
{{- end}}
{{- end}}
    });
    {{- if .ParentIdField}}
    // 设置父级ID为当前行的ID
    editingData.{{.ParentIdField.JsonTag}} = record.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}};
    {{- end}}
    modalTitle.value = '新增子级数据';
    modalVisible.value = true;
};

// 编辑数据
const handleEdit = async (record: {{.StructName}}Data) => {
    // 获取详情
    const detail = await getDetail(record.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
    // 赋值给编辑数据
    Object.assign(editingData, detail.data);
    modalTitle.value = '编辑数据';
    modalVisible.value = true;
};

// 删除数据
const handleDelete = async ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) => {
    try {
        await deleteData({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
        // 重新加载树形数据
        await loadTreeData();
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
        const dataToSave = JSON.parse(JSON.stringify(editingData));
        if (editingData.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}) {
            // 更新数据
            await updateData(dataToSave);
        } else {
            // 创建数据
            await createData(dataToSave);
        }
        // 重新加载树形数据
        await loadTreeData();
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
    // 初始化加载树形数据
    await loadTreeData();
})

</script>

<style scoped lang="scss">

</style>