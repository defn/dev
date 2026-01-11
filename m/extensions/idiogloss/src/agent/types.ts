/**
 * Type definitions for agent communication.
 */

export interface AgentRequest {
  action: "ping" | "query" | "shutdown" | "stats";
  prompt?: string;
  max_turns?: number;
  content?: string;
  file_name?: string;
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
}

export type ResponseCallback = (response: AgentResponse) => void;
