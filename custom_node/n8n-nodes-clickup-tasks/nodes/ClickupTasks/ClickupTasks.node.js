"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ClickupTasks = void 0;
class ClickupTasks {
    constructor() {
        this.description = {
            displayName: 'Clickup Tasks',
            name: 'clickupTasks',
            icon: 'file:clickupTasks.svg',
            group: [],
            version: 1,
            description: 'Consume Clickup API',
            defaults: {
                name: 'Clickup Tasks',
            },
            inputs: ["main"],
            outputs: ["main"],
            credentials: [
                {
                    name: 'clickupApi',
                    required: true,
                },
            ],
            requestDefaults: {
                baseURL: 'https://api.clickup.com/api/v2',
                headers: {
                    Accept: 'application/json',
                    'Content-Type': 'application/json',
                },
            },
            properties: [
                {
                    displayName: 'Space ID',
                    name: 'space_id',
                    type: 'number',
                    default: 90122217238,
                    required: true,
                    description: 'The space to get all the tasks from all Backlog lists',
                },
                {
                    displayName: 'Date Done Greater Than',
                    name: 'date_done_gt_timestamp',
                    type: 'number',
                    default: 1746468769057,
                    required: true,
                    description: 'The date done greater than in timestamp, ex: 1746468769057',
                },
            ],
        };
    }
    async execute() {
        const returnData = [];
        const credentials = await this.getCredentials('clickupApi');
        const apiKey = credentials.apiKey;
        const date_done_gt_timestamp = this.getNodeParameter('date_done_gt_timestamp', 0);
        console.log('date_done_gt_timestamp', date_done_gt_timestamp);
        const options = {
            headers: {
                Authorization: apiKey,
                'Content-Type': 'application/json',
            },
            method: 'GET',
            uri: 'https://api.clickup.com/api/v2/space/90122217238/folder',
            json: true,
        };
        let allTasks = [];
        try {
            const response = await this.helpers.request(options);
            for (const project of response.folders) {
                const options = {
                    headers: {
                        Authorization: apiKey,
                        'Content-Type': 'application/json',
                    },
                    method: 'GET',
                    uri: ` https://api.clickup.com/api/v2/folder/${project.id}/list`,
                    json: true,
                };
                const listsResponse = await this.helpers.request(options);
                for (const list of listsResponse.lists) {
                    if (list.name === 'Backlog') {
                        const options = {
                            headers: {
                                Authorization: apiKey,
                                'Content-Type': 'application/json',
                            },
                            method: 'GET',
                            uri: `https://api.clickup.com/api/v2/list/${list.id}/task?include_markdown_description=true&subtasks=true&include_closed=true&date_done_gt=${Number(date_done_gt_timestamp)}`,
                            json: true,
                        };
                        const tasksResponse = await this.helpers.request(options);
                        const tasks = tasksResponse.tasks.map((task) => ({
                            id: task.id,
                            name: task.name,
                            date_done: new Date(Number(task.date_done)),
                            status: task.status.status,
                            description: task.description,
                            markdown_description: task.markdown_description,
                            text_content: task.text_content,
                            time_estimate: task.time_estimate,
                        }));
                        allTasks.push(...tasks);
                    }
                }
            }
            for (const task of allTasks) {
                returnData.push(task);
            }
        }
        catch (error) {
            if (this.continueOnFail()) {
                returnData.push({ error: error.message });
            }
            else {
                throw error;
            }
        }
        return [this.helpers.returnJsonArray(returnData)];
    }
}
exports.ClickupTasks = ClickupTasks;
//# sourceMappingURL=ClickupTasks.node.js.map