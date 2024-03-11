import type { AirshipPlugin } from './plugin';

export class AirshipRoot {

  constructor(private readonly plugin: AirshipPlugin) {
  }

  public echo(value: string): Promise<string> {
    return this.plugin.perform({ method: "echo", value: value }).then((value) => { return value.value })
  }
}
