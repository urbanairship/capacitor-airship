import type { PluginListenerHandle } from '@capacitor/core';

import type { EventType, EventTypeMap } from './EventType';

export interface AirshipPlugin {
  perform(options: { method: string; value?: any }): Promise<{ value?: any }>;
  addListener(
    eventName: string,
    listenerFunc: (...args: any[]) => any,
  ): Promise<PluginListenerHandle>;
}

export class AirshipPluginWrapper {
  constructor(private readonly plugin: AirshipPlugin) {}
  public perform(method: string, value?: any): Promise<any | undefined | null> {
    return this.plugin.perform({ method: method, value: value }).then(value => {
      return value.value;
    });
  }

  public addListener<T extends EventType>(
    eventType: T,
    listener: (event: EventTypeMap[T]) => any,
  ): Promise<PluginListenerHandle> {
    return this.plugin.addListener(eventType, listener);
  }
}
