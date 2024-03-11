export interface AirshipPlugin {
    perform(options: { method: string, value?: any }): Promise<{ value?: any }>;
  }
  