/**
 * Timer Utilities - Debouncing and Heartbeat Patterns
 *
 * ## Debouncer
 *
 * Used to delay server requests until user stops typing. Without debouncing,
 * every keystroke would trigger a stats + alucard request, overwhelming the
 * server and wasting API calls.
 *
 * Current delay: 2 seconds idle before firing.
 *
 * The debouncer also supports:
 * - `flush()` - Execute immediately (used when server connects)
 * - `hasPending()` - Check if there's a queued update
 *
 * ## Heartbeat
 *
 * Monitors server health with periodic pings. If ping fails:
 *
 * 1. Triggers `onFailure` callback (restarts server)
 * 2. Doubles the interval (exponential backoff)
 * 3. Caps at maxInterval (prevents runaway retries)
 *
 * After successful check, interval resets to base value.
 *
 * Current config: 10s base, 10 minute max.
 *
 * ## Why Not setInterval?
 *
 * Using setTimeout with rescheduling instead of setInterval because:
 * - Can adjust interval dynamically (backoff)
 * - Prevents overlapping checks if onCheck/onFailure takes long
 * - Easier to stop cleanly without timer drift
 */

import { log } from "./logger";

/**
 * Debouncer - delays execution until idle for a specified duration.
 */
export class Debouncer<T> {
  private timer: NodeJS.Timeout | null = null;
  private pending: T | null = null;

  constructor(
    private readonly delay: number,
    private readonly onExecute: (value: T) => void | Promise<void>,
    private readonly label: string = "debounce",
  ) {}

  /**
   * Queue a value to be executed after the debounce delay.
   * Resets the timer if called again before execution.
   */
  call(value: T): void {
    this.pending = value;

    if (this.timer) {
      clearTimeout(this.timer);
    }

    this.timer = setTimeout(() => {
      this.execute();
    }, this.delay);

    log(`[${this.label}] Queued, waiting ${this.delay}ms for idle`);
  }

  /**
   * Execute immediately if there's a pending value.
   */
  flush(): void {
    if (this.pending !== null) {
      this.execute();
    }
  }

  /**
   * Cancel any pending execution.
   */
  cancel(): void {
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }
    this.pending = null;
  }

  /**
   * Check if there's a pending value.
   */
  hasPending(): boolean {
    return this.pending !== null;
  }

  /**
   * Get the pending value without executing.
   */
  getPending(): T | null {
    return this.pending;
  }

  private execute(): void {
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }

    if (this.pending !== null) {
      const value = this.pending;
      this.pending = null;
      log(`[${this.label}] Executing`);
      this.onExecute(value);
    }
  }
}

export interface HeartbeatOptions {
  /** Base interval in milliseconds */
  baseInterval: number;
  /** Maximum interval after backoff (milliseconds) */
  maxInterval: number;
  /** Callback to perform the health check, returns true if healthy */
  onCheck: () => Promise<boolean>;
  /** Callback when health check fails */
  onFailure: () => Promise<void>;
  /** Label for logging */
  label?: string;
}

/**
 * Heartbeat - periodic health check with exponential backoff on failure.
 */
export class Heartbeat {
  private timer: NodeJS.Timeout | null = null;
  private currentInterval: number;
  private running = false;
  private checking = false;

  private readonly baseInterval: number;
  private readonly maxInterval: number;
  private readonly onCheck: () => Promise<boolean>;
  private readonly onFailure: () => Promise<void>;
  private readonly label: string;

  constructor(options: HeartbeatOptions) {
    this.baseInterval = options.baseInterval;
    this.maxInterval = options.maxInterval;
    this.currentInterval = this.baseInterval;
    this.onCheck = options.onCheck;
    this.onFailure = options.onFailure;
    this.label = options.label ?? "heartbeat";
  }

  /**
   * Start the heartbeat monitoring.
   */
  start(): void {
    if (this.running) {
      return;
    }
    this.running = true;
    this.resetInterval();
    this.schedule();
    log(`[${this.label}] Started`);
  }

  /**
   * Stop the heartbeat monitoring.
   */
  stop(): void {
    if (!this.running) {
      return;
    }
    this.running = false;
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }
    log(`[${this.label}] Stopped`);
  }

  /**
   * Check if the heartbeat is running.
   */
  isRunning(): boolean {
    return this.running;
  }

  /**
   * Reset the interval to base value (call after successful recovery).
   */
  resetInterval(): void {
    if (this.currentInterval !== this.baseInterval) {
      log(
        `[${this.label}] Resetting interval: ${this.currentInterval / 1000}s -> ${this.baseInterval / 1000}s`,
      );
      this.currentInterval = this.baseInterval;
    }
  }

  private schedule(): void {
    if (!this.running) {
      return;
    }

    if (this.timer) {
      clearTimeout(this.timer);
    }

    log(`[${this.label}] Next check in ${this.currentInterval / 1000}s`);

    this.timer = setTimeout(async () => {
      await this.performCheck();
    }, this.currentInterval);
  }

  private async performCheck(): Promise<void> {
    if (!this.running || this.checking) {
      this.schedule();
      return;
    }

    this.checking = true;

    try {
      const healthy = await this.onCheck();

      if (healthy) {
        this.resetInterval();
        this.schedule();
      } else {
        log(`[${this.label}] Check failed, triggering recovery`);
        this.increaseInterval();
        await this.onFailure();
        // Schedule next check after failure handler completes
        if (this.running) {
          this.schedule();
        }
      }
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      log(`[${this.label}] Check error: ${msg}, triggering recovery`);
      this.increaseInterval();
      await this.onFailure();
      // Schedule next check after failure handler completes
      if (this.running) {
        this.schedule();
      }
    } finally {
      this.checking = false;
    }
  }

  private increaseInterval(): void {
    const newInterval = Math.min(this.currentInterval * 2, this.maxInterval);
    if (newInterval !== this.currentInterval) {
      log(
        `[${this.label}] Backing off: ${this.currentInterval / 1000}s -> ${newInterval / 1000}s`,
      );
      this.currentInterval = newInterval;
    }
  }
}
