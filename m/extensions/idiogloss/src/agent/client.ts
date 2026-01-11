import * as net from "net";
import { spawn, ChildProcess } from "child_process";
import { log } from "../utils/logger";
import { truncate } from "./utils";
import type { AgentRequest, AgentResponse, ResponseCallback } from "./types";

const DEFAULT_SOCKET_PATH = "/tmp/idiogloss.sock";
const WORKSPACE_DIR = "/home/ubuntu/m";
const MISE_PATH = "/home/ubuntu/.local/bin/mise";

// Re-export types for convenience
export type {
  AgentRequest,
  AgentResponse,
  ContentStats,
  ServerInfo,
} from "./types";

export class AgentClient {
  private socketPath: string;
  private socket: net.Socket | null = null;
  private serverProcess: ChildProcess | null = null;
  private connected = false;
  private buffer = "";
  private pendingCallbacks: ResponseCallback[] = [];

  constructor(socketPath: string = DEFAULT_SOCKET_PATH) {
    this.socketPath = socketPath;
  }

  /**
   * Start the agent server process.
   */
  async startServer(_bazelWorkspace?: string): Promise<void> {
    if (this.serverProcess) {
      log("Agent server already running");
      return;
    }

    log(`Starting agent server at ${this.socketPath}`);
    log(`[server] Working directory: ${WORKSPACE_DIR}`);

    // Start the server via mise exec to load environment configs
    this.serverProcess = spawn(
      MISE_PATH,
      [
        "exec",
        "--",
        "bazel",
        "run",
        "//agents/idiogloss:server_py",
        "--",
        this.socketPath,
      ],
      {
        cwd: WORKSPACE_DIR,
        stdio: ["ignore", "pipe", "pipe"],
      },
    );

    this.serverProcess.stdout?.on("data", (data) => {
      log(`[agent stdout] ${data.toString().trim()}`);
    });

    this.serverProcess.stderr?.on("data", (data) => {
      log(`[agent stderr] ${data.toString().trim()}`);
    });

    this.serverProcess.on("exit", (code) => {
      log(`Agent server exited with code ${code}`);
      this.serverProcess = null;
      this.connected = false;
    });

    // Wait for server to start
    await this.waitForSocket(5000);
  }

  /**
   * Wait for the socket file to exist.
   */
  private async waitForSocket(timeoutMs: number): Promise<void> {
    const start = Date.now();
    const fs = await import("fs");

    log(`[connect] Waiting for socket file: ${this.socketPath}`);

    while (Date.now() - start < timeoutMs) {
      if (fs.existsSync(this.socketPath)) {
        log(`[connect] Socket file found after ${Date.now() - start}ms`);
        return;
      }
      await new Promise((resolve) => setTimeout(resolve, 100));
    }

    log(`[connect] Socket file not found after ${timeoutMs}ms`);
    throw new Error(
      `Socket ${this.socketPath} not available after ${timeoutMs}ms`,
    );
  }

  /**
   * Connect to the agent server.
   */
  async connect(): Promise<void> {
    log(`[connect] connect() called, connected=${this.connected}`);
    if (this.connected) {
      log("[connect] Already connected, returning");
      return;
    }

    log(`[connect] Creating connection to ${this.socketPath}`);

    return new Promise((resolve, reject) => {
      this.socket = net.createConnection(this.socketPath);

      this.socket.on("connect", () => {
        this.connected = true;
        log("[connect] Socket connected successfully");
        resolve();
      });

      this.socket.on("error", (err) => {
        log(`[connect] Socket error: ${err.message}`);
        this.connected = false;
        reject(err);
      });

      this.socket.on("close", () => {
        log("[connect] Socket closed");
        this.connected = false;
      });

      this.socket.on("data", (data: Buffer) => {
        this.handleData(data);
      });
    });
  }

  /**
   * Handle incoming data from the socket.
   */
  private handleData(data: Buffer): void {
    this.buffer += data.toString();

    // Process complete lines
    let newlineIndex: number;
    while ((newlineIndex = this.buffer.indexOf("\n")) !== -1) {
      const line = this.buffer.slice(0, newlineIndex);
      this.buffer = this.buffer.slice(newlineIndex + 1);

      if (line.trim()) {
        try {
          const response = JSON.parse(line) as AgentResponse;
          const callback = this.pendingCallbacks.shift();
          if (callback) {
            callback(response);
          }
        } catch (e) {
          log(`Failed to parse response: ${e}`);
        }
      }
    }
  }

  /**
   * Send a request to the agent.
   */
  async send(request: AgentRequest): Promise<AgentResponse> {
    if (!this.connected || !this.socket) {
      throw new Error("Not connected to agent server");
    }

    // Log request with truncated content
    const logReq = { ...request };
    if (logReq.content) {
      logReq.content = truncate(logReq.content);
    }
    if (logReq.prompt) {
      logReq.prompt = truncate(logReq.prompt);
    }
    log(`[agent] -> ${JSON.stringify(logReq)}`);

    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error("Request timeout"));
      }, 60000); // 60 second timeout

      this.pendingCallbacks.push((response) => {
        clearTimeout(timeout);
        // Log response with truncated content
        const logResp = { ...response };
        if (logResp.response) {
          logResp.response = truncate(logResp.response);
        }
        log(`[agent] <- ${JSON.stringify(logResp)}`);
        resolve(response);
      });

      const line = JSON.stringify(request) + "\n";
      this.socket!.write(line);
    });
  }

  /**
   * Send a query to the agent.
   */
  async query(prompt: string, maxTurns: number = 5): Promise<AgentResponse> {
    return this.send({
      action: "query",
      prompt,
      max_turns: maxTurns,
    });
  }

  /**
   * Get stats for file content.
   */
  async getStats(fileName: string, content: string): Promise<AgentResponse> {
    return this.send({
      action: "stats",
      file_name: fileName,
      content,
    });
  }

  /**
   * Ping the agent server.
   */
  async ping(): Promise<boolean> {
    try {
      const response = await this.send({ action: "ping" });
      return response.pong === true;
    } catch {
      return false;
    }
  }

  /**
   * Disconnect from the agent server.
   */
  disconnect(): void {
    if (this.socket) {
      this.socket.destroy();
      this.socket = null;
    }
    this.connected = false;
    this.buffer = "";
    this.pendingCallbacks = [];
  }

  /**
   * Stop the agent server.
   */
  async stopServer(): Promise<void> {
    if (this.connected) {
      try {
        await this.send({ action: "shutdown" });
      } catch {
        // Ignore errors during shutdown
      }
      this.disconnect();
    }

    if (this.serverProcess) {
      this.serverProcess.kill();
      this.serverProcess = null;
    }
  }

  /**
   * Check if connected to the agent.
   */
  isConnected(): boolean {
    return this.connected;
  }
}

// Singleton instance
let clientInstance: AgentClient | null = null;

export function getAgentClient(socketPath?: string): AgentClient {
  if (!clientInstance) {
    clientInstance = new AgentClient(socketPath);
  }
  return clientInstance;
}

export function disposeAgentClient(): void {
  if (clientInstance) {
    clientInstance.stopServer();
    clientInstance = null;
  }
}
