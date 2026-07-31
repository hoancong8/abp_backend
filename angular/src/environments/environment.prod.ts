import { Environment } from '@abp/ng.core';

const baseUrl = 'http://163.227.231.23:4200';

const oAuthConfig = {
  issuer: 'http://163.227.231.23:8080/',
  redirectUri: baseUrl,
  clientId: 'AbpSolution1_App',
  responseType: 'code',
  scope: 'offline_access AbpSolution1',
  requireHttps: false,
};

export const environment = {
  production: true,
  application: {
    baseUrl,
    name: 'AbpSolution1',
  },
  oAuthConfig,
  apis: {
    default: {
      url: 'http://163.227.231.23:8080',
      rootNamespace: 'AbpSolution1',
    },
    AbpAccountPublic: {
      url: oAuthConfig.issuer,
      rootNamespace: 'AbpAccountPublic',
    },
  },
  remoteEnv: {
    url: '/getEnvConfig',
    mergeStrategy: 'deepmerge'
  }
} as Environment;
