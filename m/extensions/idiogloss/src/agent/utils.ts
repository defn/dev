/**
 * Utility functions for agent communication.
 */

export const LOG_TRUNCATE_LENGTH = 100;

/**
 * Truncate a string for logging purposes.
 */
export function truncate(
  str: string,
  maxLen: number = LOG_TRUNCATE_LENGTH,
): string {
  if (str.length <= maxLen) {
    return str;
  }
  return str.slice(0, maxLen) + `... (${str.length} chars)`;
}
