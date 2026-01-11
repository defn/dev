/**
 * Type definitions for agent communication.
 */

export interface AgentRequest {
  action: "ping" | "query" | "shutdown" | "stats" | "alucard";
  prompt?: string;
  max_turns?: number;
  content?: string;
  file_name?: string;
  text?: string;
}

export interface ContentStats {
  lines: number;
  words: number;
  characters: number;
  characters_no_spaces: number;
}

export interface ServerInfo {
  server_start_time: number;
  server_pid: number;
}

/** Progress update from agent during streaming */
export interface AgentProgressUpdate {
  type: "tool_call" | "text";
  name?: string;
  input?: Record<string, unknown>;
  text?: string;
}

export interface AgentResponse {
  success: boolean;
  response?: string;
  error?: string;
  tool_calls?: Array<{ name: string; input: Record<string, unknown> }>;
  pong?: boolean;
  message?: string;
  file_name?: string;
  stats?: ContentStats;
  server_start_time?: number;
  server_pid?: number;
  alucard_response?: string;
  /** For progress updates */
  type?: "progress";
  update?: AgentProgressUpdate;
}

export type ResponseCallback = (response: AgentResponse) => void;
