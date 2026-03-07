import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const routineBlock = z.object({
  done: z.boolean(),
  note: z.string().optional(),
});

const diary = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/diary' }),
  schema: z.object({
    title: z.string(),
    date: z.string(),
    summary: z.string().optional(),
    tags: z.array(z.string()).optional(),
    instagram: z.array(z.string()).optional(),
    thumbnail: z.string().optional(),
    routine: z
      .object({
        morning: routineBlock.optional(),
        exercise: routineBlock.optional(),
        meal1: routineBlock.optional(),
        meal2: routineBlock.optional(),
        sleep: routineBlock.optional(),
      })
      .optional(),
  }),
});

const facts = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/facts' }),
  schema: z.object({
    title: z.string(),
    order: z.number().optional(),
    summary: z.string().optional(),
  }),
});

export const collections = { diary, facts };
