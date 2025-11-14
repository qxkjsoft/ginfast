import { http } from '@/utils/http';
import { baseUrlApi } from "@/api/utils";

import { BaseResult } from "@/api/types";


export interface {{.StructName}}Data {
{{- range .Columns}}
    {{.JsonTag}}: {{.FrontendType}};{{if .Comment}} // {{.Comment}}{{end}}
{{- end}}
}

export type {{.StructName}}ListResult = BaseResult<{
    list: {{.StructName}}Data[];
    total: number;
}>;

export interface {{.StructName}}ListParams {
    pageNum: number;
    pageSize: number;
{{- range .Columns}}
    {{.JsonTag}}?: {{.FrontendType}};{{if .Comment}} // {{.Comment}}{{end}}
{{- end}}
}


export type {{.StructName}}Result = BaseResult<{{.StructName}}Data>;

export const get{{.StructName}}List = (params: {{.StructName}}ListParams) => {
    return http.request<{{.StructName}}ListResult>("get", baseUrlApi("plugins/{{.DirName}}/{{.FileName}}/list"), { params });
};

export const create{{.StructName}} = (data: Omit<{{.StructName}}Data, '{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}'>) => {
    return http.request<{{.StructName}}Data>("post", baseUrlApi("plugins/{{.DirName}}/{{.FileName}}/add"), { data });
};

export const update{{.StructName}}= (data: Partial<{{.StructName}}Data>) => {
    return http.request<{{.StructName}}Data>("put", baseUrlApi(`plugins/{{.DirName}}/{{.FileName}}/edit`), { data });
};

export const delete{{.StructName}} = ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) => {
    return http.request<BaseResult>("delete", baseUrlApi(`plugins/{{.DirName}}/{{.FileName}}/delete`), { data: { {{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}} } });
};


export const get{{.StructName}} = ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) => {
    return http.request<{{.StructName}}Result>("get", baseUrlApi(`plugins/{{.DirName}}/{{.FileName}}/{{"${"}}{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}{{"}"}}`));
};