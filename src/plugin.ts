export interface AirshipPlugin {
  perform(options: { method: string; value?: any }): Promise<{ value?: any }>;
}

export class AirshipPluginWrapper {
  constructor(private readonly plugin: AirshipPlugin) {}
  public perform(method: string, value?: any): Promise<any | undefined | null> {
    return this.plugin.perform({ method: method, value: value }).then(value => {
      return value.value;
    });
  }
}
