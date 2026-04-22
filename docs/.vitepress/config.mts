import { defineConfig } from 'vitepress'

const repository = process.env.GITHUB_REPOSITORY?.split('/')[1]
const base = process.env.GITHUB_ACTIONS && repository ? `/${repository}/` : '/'

export default defineConfig({
  title: 'Apeiraco Scoop-Bucket',
  description: 'Static documentation site for Apeiraco Scoop-Bucket.',
  base,
  cleanUrls: true,
  ignoreDeadLinks: true,
  vite: {
    resolve: {
      preserveSymlinks: true,
    },
    plugins: [
      {
        name: 'rewrite-root-doc-links',
        enforce: 'pre',
        transform(code, id) {
          if (!id.endsWith('.md')) {
            return null
          }

          return code
            .replace(/\]\(README_CN\.md\)/g, '](./zh/)')
            .replace(/\]\(README\.md\)/g, '](../)')
            .replace(/\]\(LICENSE\)/g, '](license.md)')
            .replace(/href="README_CN\.md"/g, 'href="./zh/"')
            .replace(/href="README\.md"/g, 'href="../"')
            .replace(/href="LICENSE"/g, 'href="license"')
        },
      },
    ],
  },
  themeConfig: {
    search: {
      provider: 'local',
    },
    socialLinks: [
      { icon: 'github', link: 'https://github.com/apeiraco/scoop-bucket' },
    ],
  },
  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
      themeConfig: {
        nav: [
          { text: 'Home', link: '/' },
          { text: 'License', link: '/license' },
          { text: 'GitHub', link: 'https://github.com/apeiraco/scoop-bucket' },
        ],
      },
    },
    zh: {
      label: '简体中文',
      lang: 'zh-CN',
      link: '/zh/',
      themeConfig: {
        nav: [
          { text: '首页', link: '/zh/' },
          { text: '许可证', link: '/zh/license' },
          { text: 'GitHub', link: 'https://github.com/apeiraco/scoop-bucket' },
        ],
      },
    },
  },
})