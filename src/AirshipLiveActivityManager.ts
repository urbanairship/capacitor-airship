import {
  LiveActivity,
  LiveActivityListRequest,
  LiveActivityStartRequest,
  LiveActivityUpdateRequest,
  LiveActivityEndRequest,
  LiveActivitiesUpdatedEvent,
} from './types';

import type { AirshipPluginWrapper } from './AirshipPlugin';
import { EventType } from './EventType';
import { PluginListenerHandle } from '@capacitor/core';

/**
 * Live Activity manager.
 */
export class AirshipLiveActivityManager {
  constructor(private readonly plugin: AirshipPluginWrapper) {}

  /**
   * Lists any Live Activities for the request.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public list(request: LiveActivityListRequest): Promise<LiveActivity[]> {
    return this.plugin.perform('liveActivityManager#list', request);
  }

  /**
   * Lists all Live Activities.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public listAll(): Promise<LiveActivity[]> {
    return this.plugin.perform('liveActivityManager#listAll');
  }

  /**
   * Starts a Live Activity.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public start(request: LiveActivityStartRequest): Promise<LiveActivity> {
    return this.plugin.perform('liveActivityManager#start', request);
  }

  /**
   * Updates a Live Activity.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public update(request: LiveActivityUpdateRequest): Promise<void> {
    return this.plugin.perform('liveActivityManager#update', request);
  }

  /**
   * Ends a Live Activity.
   * @param request The request options.
   * @returns A promise with the result.
   */
  public end(request: LiveActivityEndRequest): Promise<void> {
    return this.plugin.perform('liveActivityManager#end', request);
  }

  /**
   * Adds a Live Activity listener.
   */
  public onChannelCreated(
    listener: (event: LiveActivitiesUpdatedEvent) => void,
  ): Promise<PluginListenerHandle> {
    return this.plugin.addListener(
      EventType.IOSLiveActivitiesUpdated,
      listener,
    );
  }
}
