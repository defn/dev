import { DurableObject } from "cloudflare:workers";

import type { Env } from "./env.ts";

export class MyDurableObject extends DurableObject {
  constructor(ctx: DurableObjectState, env: Env<MyDurableObject>) {
    super(ctx, env);
  }

  async sayHello(thing: string) {
    this.ctx.storage.sql.exec(
      `
        CREATE TABLE IF NOT EXISTS my_table (
            id INTEGER PRIMARY KEY,
            name TEXT,
            value INTEGER
        );
    `,
    );

    this.ctx.storage.sql.exec(
      `
        INSERT INTO my_table (id, name, value)
        VALUES (0, 'default_name', 1)
        ON CONFLICT(id) DO UPDATE SET
            value = my_table.value + 1;
    `,
    );

    let result = this.ctx.storage.sql
      .exec("SELECT value FROM my_table WHERE id = 0")
      .one();

    return result.value;
  }
}
