import { ref, computed } from 'vue';
import type { {{.StructName}}Data, {{.StructName}}ListParams, {{.StructName}}ListResult, {{.StructName}}Result } from '../api/{{.FileName}}';
import {
    get{{.StructName}}List,
    create{{.StructName}},
    update{{.StructName}},
    delete{{.StructName}},
    get{{.StructName}}
} from '../api/{{.FileName}}';

export const use{{.StructName}}PluginHook = () => {
    // State
    const dataList = ref<{{.StructName}}Data[]>([]);
    const loading = ref<boolean>(false);
    const total = ref<number>(0);
    const currentPage = ref<number>(1);
    const pageSize = ref<number>(10);
    const searchParams = ref<Partial<{{.StructName}}ListParams>>({});

    // Computed
    const getDataList = computed(() => dataList.value);
    const isLoading = computed(() => loading.value);
    const getTotal = computed(() => total.value);
    const getCurrentPage = computed(() => currentPage.value);
    const getPageSize = computed(() => pageSize.value);
    const getSearchParams = computed(() => searchParams.value);

    // Actions
    const fetchDataList = async (params?: Partial<{{.StructName}}ListParams>) => {
        loading.value = true;
        try {
            // 更新分页参数和搜索条件
            if (params?.pageNum !== undefined) {
                currentPage.value = params.pageNum;
            }
            if (params?.pageSize !== undefined) {
                pageSize.value = params.pageSize;
            }
            
            // 更新搜索参数
            if (params) {
                searchParams.value = { ...searchParams.value, ...params };
            }

            // 构造请求参数
            const requestParams: {{.StructName}}ListParams = {
                pageNum: currentPage.value,
                pageSize: pageSize.value,
                ...searchParams.value
            };

            const response: {{.StructName}}ListResult = await get{{.StructName}}List(requestParams);

            // 根据返回的数据结构处理
            if (Array.isArray(response.data.list)) {
                // 如果返回的是数组格式（旧格式）
                dataList.value = response.data.list || [];
                total.value = response.data.total || 0;
            }
        } finally {
            loading.value = false;
        }
    };

    const createData = async (data: Omit<{{.StructName}}Data, '{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}'>) => {
        try {
            const response = await create{{.StructName}}(data);
            return response;
        } catch (error) {
            throw error;
        }
    };

    const updateData = async (data: Partial<{{.StructName}}Data>) => {
        try {
            const response = await update{{.StructName}}(data);
            return response;
        } catch (error) {
            throw error;
        }
    };

    const deleteData = async ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) => {
        try {
            await delete{{.StructName}}({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
            dataList.value = dataList.value.filter((item: {{.StructName}}Data) => item.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}} !== {{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
            // 减少总数
            total.value = Math.max(0, total.value - 1);
        } catch (error) {
            throw error;
        }
    };

    // 根据ID获取用户详情
    const getDetail = async ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) : Promise<{{.StructName}}Result> => {
        try {
            const response = await get{{.StructName}}({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
            return response;
        } catch (error) {
            throw error;
        }
    };
    
    // 重置搜索条件
    const resetSearchParams = () => {
        searchParams.value = {};
        currentPage.value = 1;
    };

    return {
        // State
        dataList,
        loading,
        total,
        currentPage,
        pageSize,
        searchParams,

        // Computed
        getDataList,
        isLoading,
        getTotal,
        getCurrentPage,
        getPageSize,
        getSearchParams,

        // Actions
        fetchDataList,
        createData,
        updateData,
        deleteData,
        resetSearchParams,
        getDetail
    };
};