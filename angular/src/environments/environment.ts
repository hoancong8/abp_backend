import { Environment } from '@abp/ng.core';

const baseUrl = 'http://localhost:4200';

const oAuthConfig = {
  issuer: 'http://localhost:8080/',
  redirectUri: baseUrl,
  clientId: 'AbpSolution1_App',
  responseType: 'code',
  scope: 'offline_access AbpSolution1',
  requireHttps: false,
};

export const environment = {
  production: false,
  application: {
    baseUrl,
    name: 'AbpSolution1',
  },
  oAuthConfig,
  apis: {
    default: {
      url: 'http://localhost:8080',
      rootNamespace: 'AbpSolution1',
    },
    AbpAccountPublic: {
      url: oAuthConfig.issuer,
      rootNamespace: 'AbpAccountPublic',
    },
  },
} as Environment;
