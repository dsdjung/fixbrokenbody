import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const diary = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/diary' }),
  schema: z.object({
    title: z.string(),
    date: z.string(),
    summary: z.string().optional(),
    tags: z.array(z.string()).optional(),
  }),
});

const facts = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/facts' }),
  schema: z.object({
    title: z.string(),
    order: z.number().optional(),
  }),
});

export const collections = { diary, facts };
