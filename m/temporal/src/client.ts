// @@@SNIPSTART typescript-esm-client
import { Client } from '@temporalio/client';
import { example } from './workflows.js';

const client = new Client();
const result = await client.workflow.execute(example, {
  taskQueue: 'fetch-esm',
  workflowId: `batch-${process.pid}`,
  args: [`Temporal: ${process.pid}`],
});
console.log(result); // Hello, Temporal!
// @@@SNIPEND
