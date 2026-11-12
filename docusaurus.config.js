/** @type {import('@docusaurus/types').DocusaurusConfig} */
module.exports = {
  title: 'space101',
  tagline: 'набор космического инженера',
  url: 'https://space101.org', // Replace it with your deployed Pages URL
  baseUrl: '/', // When the unique domain is disabled, replace it with your project’s name.
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  organizationName: 'space101org', // Usually your GitHub org/user name.
  projectName: 'space101org.github.io', // Usually your repo name.
  trailingSlash: false,
  themeConfig: {
    navbar: {
      title: 'space101',
      logo: {
        alt: 'Logo',
        src: 'img/logo.png',
      },
      items: [
        {
          to: 'docs/',
          activeBasePath: 'docs',
          label: 'Docs',
          position: 'left',
        },
        {to: 'blog', label: 'Blog', position: 'left'},
        {
          href: 'https://vk.com',
          label: 'vk',
          position: 'right',
        },
                {
          href: 'https://t.me',
          label: 'tg',
          position: 'right',
        },
        {
          href: 'https://github.com/space101org',
          label: 'GitLab',
          position: 'right',
        },
      ],
    },
	colorMode: {
      defaultMode: 'light', // тема по умолчанию ('light' или 'dark')
      disableSwitch: true,  // скрывает переключатель тем
      respectPrefersColorScheme: false, // игнорирует системные настройки пользователя
	},
    footer: {
      style: 'dark',
      copyright: `© ${new Date().getFullYear()} space101`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/space101org/space101org.github.io/edit/main/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl:
            'https://github.com/space101org/space101org.github.io/edit/main/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
