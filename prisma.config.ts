import 'dotenv/config';
import path from 'node:path';
import { defineConfig, env } from 'prisma/config';

export default defineConfig({
  schema: path.join('prisma', 'schema.prisma'),
  migrations: {
    path: path.join('prisma', 'migrations'),
  },
  datasource: {
    // Prisma CLI y Prisma Migrate usan la conexión Session Pooler.
    // La aplicación utilizará DATABASE_URL en su cliente de Prisma.
    url: env('DIRECT_URL'),
  },
});
