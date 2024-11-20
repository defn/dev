export async function greetHTTP(name: string): Promise<string> {
  return `Hello, ${name}!`;
}
