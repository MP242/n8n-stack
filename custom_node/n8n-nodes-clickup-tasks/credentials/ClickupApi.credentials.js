"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ClickupApi = void 0;
class ClickupApi {
    constructor() {
        this.name = 'clickupApi';
        this.displayName = 'Clickup API';
        this.documentationUrl = 'https://clickup.com/api';
        this.properties = [
            {
                displayName: 'API Key',
                name: 'apiKey',
                type: 'string',
                typeOptions: {
                    password: true,
                },
                default: '',
                required: true,
                description: 'The API Key for Clickup',
            },
        ];
        this.authenticate = {
            type: 'generic',
            properties: {
                headers: {
                    Authorization: '={{$credentials.apiKey}}',
                },
            },
        };
        this.test = {
            request: {
                baseURL: 'https://api.clickup.com/api/v2',
                url: '/user',
                method: 'GET',
            },
        };
    }
}
exports.ClickupApi = ClickupApi;
//# sourceMappingURL=ClickupApi.credentials.js.map