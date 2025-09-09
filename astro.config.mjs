import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import react from '@astrojs/react';
import sharp from 'sharp';
import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({
  output: 'server',
  adapter: node({
    mode: 'standalone',
    port:3000,
    host:'0.0.0.0'
  }),
  integrations: [tailwind(), react()],
  assets: {
    addSharpInstructions: true,
    services: [
      {
        name: 'sharp',
        constructor: sharp,
      },
    ],
  },
});