# Usa una imagen base de Node.js ligera para construir la aplicación
FROM node:18-alpine AS builder

# Establece el directorio de trabajo
WORKDIR /app

# Copia package.json y package-lock.json (si existe) para instalar dependencias
COPY package*.json ./

# Instala dependencias de producción
RUN npm install --omit=dev

# Copia el resto del código fuente
COPY . .

# Construye la aplicación Astro para producción
RUN npm run build

# --- Etapa de Ejecución ---
# Usa una imagen base de Node.js más pequeña para la aplicación final
FROM node:18-alpine

# Establece el directorio de trabajo
WORKDIR /app

# Copia solo los archivos necesarios de la etapa de construcción
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public 

# Expón el puerto que Astro usará (por defecto 3000 si no lo cambiaste en astro.config.mjs)
EXPOSE 3000

ENV PORT=3000

ENV HOST=0.0.0.0

# Comando para iniciar la aplicación Astro en producción
CMD ["node", "./dist/server/entry.mjs"]